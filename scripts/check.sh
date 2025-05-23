#!/bin/bash

DOMAIN="yourdomain.com"     # Replace if using a real domain
LOCAL_API="http://localhost:8000/api/posts"
PUBLIC_API="http://$DOMAIN/api/posts"
DB_PATH=~/my-blog/backend/blog.db

function check() {
    echo ""
    echo "🩺 Checking Your Self-Hosted Blog..."
    echo "------------------------------------"

    # 1. Frontend
    echo -n "🌐 Frontend (React): "
    curl -s --head http://localhost | head -n 1 | grep "200 OK" > /dev/null
    [ $? -eq 0 ] && echo "✅ Serving on http://localhost" || echo "❌ Not responding"

    # 2. FastAPI (Local)
    echo -n "⚙️  FastAPI Backend: "
    curl -s $LOCAL_API | grep title > /dev/null
    [ $? -eq 0 ] && echo "✅ Running at $LOCAL_API" || echo "❌ No response on port 8000"

    # 3. API via Domain
    echo -n "🌍 API via Domain ($DOMAIN): "
    curl -s $PUBLIC_API | grep title > /dev/null
    [ $? -eq 0 ] && echo "✅ Domain routing works" || echo "❌ Check NGINX or DNS"

    # 4. NGINX
    echo -n "🧰 NGINX: "
    ps aux | grep -v grep | grep nginx > /dev/null
    [ $? -eq 0 ] && echo "✅ Running" || echo "❌ Not running"

    # 5. Database
    echo -n "🗄️  SQLite DB: "
    if [ -f "$DB_PATH" ]; then
        count=$(sqlite3 $DB_PATH "SELECT COUNT(*) FROM posts;" 2>/dev/null)
        if [[ "$count" =~ ^[0-9]+$ ]]; then
            echo "✅ Found $count post(s)"
        else
            echo "⚠️  DB exists, but failed to query"
        fi
    else
        echo "❌ DB not found at $DB_PATH"
    fi

    echo "------------------------------------"
    echo "🧙 Done. May your server stay strong!"
}

check
#!/bin/bash

DOMAIN="yourdomain.com"     # Replace if using a real domain
LOCAL_API="http://localhost:8000/api/posts"
PUBLIC_API="http://$DOMAIN/api/posts"
DB_PATH=~/my-blog/backend/blog.db

function check() {
    echo ""
    echo "🩺 Checking Your Self-Hosted Blog..."
    echo "------------------------------------"

    # 1. Frontend
    echo -n "🌐 Frontend (React): "
    curl -s --head http://localhost | head -n 1 | grep "200 OK" > /dev/null
    [ $? -eq 0 ] && echo "✅ Serving on http://localhost" || echo "❌ Not responding"

    # 2. FastAPI (Local)
    echo -n "⚙️  FastAPI Backend: "
    curl -s $LOCAL_API | grep title > /dev/null
    [ $? -eq 0 ] && echo "✅ Running at $LOCAL_API" || echo "❌ No response on port 8000"

    # 3. API via Domain
    echo -n "🌍 API via Domain ($DOMAIN): "
    curl -s $PUBLIC_API | grep title > /dev/null
    [ $? -eq 0 ] && echo "✅ Domain routing works" || echo "❌ Check NGINX or DNS"

    # 4. NGINX
    echo -n "🧰 NGINX: "
    ps aux | grep -v grep | grep nginx > /dev/null
    [ $? -eq 0 ] && echo "✅ Running" || echo "❌ Not running"

    # 5. Database
    echo -n "🗄️  SQLite DB: "
    if [ -f "$DB_PATH" ]; then
        count=$(sqlite3 $DB_PATH "SELECT COUNT(*) FROM posts;" 2>/dev/null)
        if [[ "$count" =~ ^[0-9]+$ ]]; then
            echo "✅ Found $count post(s)"
        else
            echo "⚠️  DB exists, but failed to query"
        fi
    else
        echo "❌ DB not found at $DB_PATH"
    fi

    echo "------------------------------------"
    echo "🧙 Done. May your server stay strong!"
}

check
#!/bin/bash

DOMAIN="yourdomain.com"     # Replace if using a real domain
LOCAL_API="http://localhost:8000/api/posts"
PUBLIC_API="http://$DOMAIN/api/posts"
DB_PATH=~/my-blog/backend/blog.db

function check() {
    echo ""
    echo "🩺 Checking Your Self-Hosted Blog..."
    echo "------------------------------------"

    # 1. Frontend
    echo -n "🌐 Frontend (React): "
    curl -s --head http://localhost | head -n 1 | grep "200 OK" > /dev/null
    [ $? -eq 0 ] && echo "✅ Serving on http://localhost" || echo "❌ Not responding"

    # 2. FastAPI (Local)
    echo -n "⚙️  FastAPI Backend: "
    curl -s $LOCAL_API | grep title > /dev/null
    [ $? -eq 0 ] && echo "✅ Running at $LOCAL_API" || echo "❌ No response on port 8000"

    # 3. API via Domain
    echo -n "🌍 API via Domain ($DOMAIN): "
    curl -s $PUBLIC_API | grep title > /dev/null
    [ $? -eq 0 ] && echo "✅ Domain routing works" || echo "❌ Check NGINX or DNS"

    # 4. NGINX
    echo -n "🧰 NGINX: "
    ps aux | grep -v grep | grep nginx > /dev/null
    [ $? -eq 0 ] && echo "✅ Running" || echo "❌ Not running"

    # 5. Database
    echo -n "🗄️  SQLite DB: "
    if [ -f "$DB_PATH" ]; then
        count=$(sqlite3 $DB_PATH "SELECT COUNT(*) FROM posts;" 2>/dev/null)
        if [[ "$count" =~ ^[0-9]+$ ]]; then
            echo "✅ Found $count post(s)"
        else
            echo "⚠️  DB exists, but failed to query"
        fi
    else
        echo "❌ DB not found at $DB_PATH"
    fi

    echo "------------------------------------"
    echo "🧙 Done. May your server stay strong!"
}

check
