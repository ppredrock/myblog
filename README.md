# 📝 My Self-Hosted Blog

Welcome to my self-hosted, full-stack blog built with love, code, and a healthy disdain for cloud dependency. This project runs entirely on a macOS machine and combines:

- ⚛️ React frontend  
- 🐍 FastAPI backend  
- 💾 SQLite database  
- 🌐 NGINX for static serving & API proxy  
- 🔒 Let's Encrypt SSL (optional)  
- 💻 Self-hosted locally – because we do things our way

## 🚀 Features

- Create and read blog posts via REST API  
- Data stored locally in SQLite (`blog.db`)  
- Frontend served via NGINX  
- Backend served behind `/api`  
- Works with your custom domain and supports HTTPS  
- Tracked and version-controlled on GitHub

## 🛠️ Tech Stack

| Layer     | Tech                  |
|-----------|-----------------------|
| Frontend  | React (CRA)           |
| Backend   | FastAPI + Uvicorn     |
| Database  | SQLite + SQLAlchemy   |
| Server    | macOS + NGINX         |
| Deployment | Manual shell script  |

## ⚙️ How to Run Locally

Clone the repo and set it up:

```bash
git clone git@github.com:yourusername/my-blog.git
cd my-blog

# Frontend setup
cd frontend
npm install
npm run build

# Backend setup
cd ../backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000



# 🔧 NGINX Setup
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        root /usr/local/var/www/my-blog;
        index index.html;
        try_files $uri /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# 🔒 SSL (Optional)
If using a domain, install Certbot and run:
sudo certbot certonly --standalone -d yourdomain.com

Then add to your NGINX config:

ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

✨ Future Improvements
	•	Admin panel for writing posts
	•	Markdown-based post support
	•	Comment system integration
	•	Docker setup for easy deployment
	•	GitHub Actions for CI/CD

👤 Author

Crafted by Prakhar
📫 Email: manu.prakhar@gmail.com
🌍 Hosted on my own Mac – because I can

📜 License

MIT – clone it, break it, rebuild it, just give credit.
