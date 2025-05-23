#!/bin/bash

# === CONFIGURE ME ===
DOMAIN="yourdomain.com"         # 👈 Replace this
EMAIL="youremail@domain.com"    # 👈 Replace this
PROJECT_DIR=~/my-blog
FRONTEND_DIR="$PROJECT_DIR/frontend"
BACKEND_DIR="$PROJECT_DIR/backend"
WEBROOT="/usr/local/var/www/my-blog"
NGINX_CONFIG="/usr/local/etc/nginx/servers/my_blog.conf"
PORT=8000
DB_PATH="$BACKEND_DIR/blog.db"

echo "📦 Installing required packages..."
brew install python node nginx certbot

# === FRONTEND ===
echo "🎨 Creating React frontend..."
npx create-react-app "$FRONTEND_DIR"
cd "$FRONTEND_DIR"
npm install
npm run build

echo "📂 Moving frontend to NGINX web root..."
sudo mkdir -p "$WEBROOT"
sudo cp -r "$FRONTEND_DIR/build/"* "$WEBROOT/"

# === BACKEND ===
echo "🐍 Setting up FastAPI backend..."
mkdir -p "$BACKEND_DIR"
cd "$BACKEND_DIR"
python3 -m venv venv
source venv/bin/activate
pip install fastapi uvicorn sqlalchemy pydantic

cat <<EOF > "$BACKEND_DIR/main.py"
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
from sqlalchemy import Column, Integer, String, create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

DATABASE_URL = "sqlite:///$DB_PATH"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
Base = declarative_base()
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

class Post(Base):
    __tablename__ = "posts"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    content = Column(String)

Base.metadata.create_all(bind=engine)

class PostCreate(BaseModel):
    title: str
    content: str

class PostResponse(PostCreate):
    id: int

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://$DOMAIN", "http://$DOMAIN", "http://localhost"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/posts", response_model=List[PostResponse])
def get_posts():
    return db.query(Post).all()

@app.post("/api/posts", response_model=PostResponse)
def create_post(post: PostCreate):
    new_post = Post(title=post.title, content=post.content)
    db.add(new_post)
    db.commit()
    db.refresh(new_post)
    return new_post
EOF

# === BACKEND SERVICE ===
echo "🚀 Starting FastAPI backend..."
nohup "$BACKEND_DIR/venv/bin/uvicorn" main:app --host 0.0.0.0 --port $PORT &

# === NGINX CONFIG ===
echo "🔧 Writing NGINX config..."
sudo mkdir -p "$(dirname "$NGINX_CONFIG")"
sudo tee "$NGINX_CONFIG" > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        root $WEBROOT;
        index index.html;
        try_files \$uri /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:$PORT/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

sudo nginx -s reload || sudo nginx

# === SSL ===
read -p "🌐 Do you want to enable HTTPS with Let's Encrypt now? (y/n): " enable_ssl
if [[ $enable_ssl == "y" ]]; then
    echo "🔒 Getting SSL cert for $DOMAIN..."
    sudo certbot certonly --standalone -d "$DOMAIN" -d "www.$DOMAIN" --agree-tos --email "$EMAIL" --non-interactive

    echo "🔐 Updating NGINX for HTTPS..."
    sudo tee "$NGINX_CONFIG" > /dev/null <<EOF
server {
    listen 443 ssl;
    server_name $DOMAIN www.$DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    location / {
        root $WEBROOT;
        index index.html;
        try_files \$uri /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:$PORT/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}

server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    return 301 https://\$host\$request_uri;
}
EOF

    sudo nginx -s reload
    echo "✅ SSL enabled at https://$DOMAIN"
else
    echo "➡️ SSL skipped. Site live at http://$DOMAIN"
fi

echo "🎉 DONE! Your blog is live and self-hosted on your Mac."
