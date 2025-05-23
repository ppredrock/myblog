from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
from sqlalchemy import Column, Integer, String, create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

DATABASE_URL = "sqlite:////Users/prakharkulshrestha/my-blog/backend/blog.db"
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
    allow_origins=["https://yourdomain.com", "http://yourdomain.com", "http://localhost"],
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

@app.put("/api/posts/{post_id}", response_model=PostResponse)
def update_post(post_id: int, post: PostCreate):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if not db_post:
        raise HTTPException(status_code=404, detail="Post not found")
    
    db_post.title = post.title
    db_post.content = post.content
    db.commit()
    db.refresh(db_post)
    return db_post

