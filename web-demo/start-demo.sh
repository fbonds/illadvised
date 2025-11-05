#!/bin/bash

# Ill Advised Web Demo Launcher

echo "🚀 Starting Ill Advised Web Demo..."
echo ""
echo "This will start a local web server to demonstrate the app."
echo ""

# Check if port 8000 is available
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo "⚠️  Port 8000 is already in use."
    echo ""
    read -p "Try port 8001 instead? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        PORT=8001
    else
        echo "Exiting..."
        exit 1
    fi
else
    PORT=8000
fi

# Get local IP for mobile access
LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)

echo ""
echo "✅ Starting server on port $PORT..."
echo ""
echo "📱 Access the demo:"
echo "   Desktop:  http://localhost:$PORT"
if [ ! -z "$LOCAL_IP" ]; then
    echo "   Mobile:   http://$LOCAL_IP:$PORT"
fi
echo ""
echo "Press Ctrl+C to stop the server"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Start Python HTTP server
cd "$(dirname "$0")"
python3 -m http.server $PORT
