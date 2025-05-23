My Self-Hosted Blog
Welcome to my self-hosted, full-stack blog built with love, code, and a healthy disdain for cloud dependency. This pi
React frontend
FastAPI backend
SQLite
曲
database
NGINX for static serving & API proxy
Let's Encrypt SSL (optional)
Self-hosted locally - because we do things our way
##
Features
Create and read blog posts via REST API
- Data stored locally in SQLite ("blog.db')
- Frontend served via NGINX
- Backend served behind '/api
- Works with your custom domain and supports HTTPS
- Tracked and version-controlled on GitHub
## * Tech Stack
Layer
echi
Frontend
Backend
Database
React (CRA)
FastAPI + Uvicorn
SQLite + SQLAlchemy
macOs + NGINX
Deployment | Manual shell script
##
How to Run Locally
Clone the repo and set it up: bash
git clone git@github.com:yourusername/my-blog.git cd my-blog
# Frontend setup
cd frontend npm install npm run build
# Backend setup
cd ../backend
python -m venv venv
source venv/bin/activate pip install -r requirements.txt uvicorn main:app
-host 0.0.0.0 —port 8000
Then go to http://localhost
