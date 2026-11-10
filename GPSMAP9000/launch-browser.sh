#!/bin/bash

# Launch cog browser (WPEWebKit 2.38.2) in the GPSMAP 9000 container.
# Usage: bash launch-browser.sh <URL> [--width=WIDTH] [--height=HEIGHT]
#
# Device presets:
#   GPSMAP 9000 10":      bash launch-browser.sh <URL> --width=1920 --height=1200
#   GPSMAP 9000 13"-27":  bash launch-browser.sh <URL>  (default: 3840x2160)

CONTAINER_NAME="gpsmap9000"
WIDTH="3840"
HEIGHT="2160"

# First positional argument is the URL
if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
    URL="$1"
    shift
fi

# Parse remaining named options
for arg in "$@"; do
    case $arg in
        --width=*)
            WIDTH="${arg#*=}"
            shift
            ;;
        --height=*)
            HEIGHT="${arg#*=}"
            shift
            ;;
        --help)
            echo "Usage: $0 <URL> [OPTIONS]"
            echo ""
            echo "Arguments:"
            echo "  URL               Target URL to open in the browser (required)"
            echo ""
            echo "Options:"
            echo "  --width=WIDTH     Screen width in pixels  (default: 3840)"
            echo "  --height=HEIGHT   Screen height in pixels (default: 2160)"
            echo ""
            echo "GPSMAP 9000 Device Presets:"
            echo "  10\":              $0 <URL> --width=1920 --height=1200"
            echo "  13\" to 27\":      $0 <URL>  (default: 3840x2160)"
            echo ""
            echo "Examples:"
            echo "  $0 http://localhost:4200/"
            echo "  $0 http://localhost:4200/ --width=1920 --height=1200"
            echo "  $0 http://192.168.1.100:4200/?env=dev --width=3840 --height=2160"
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

if [ -z "$URL" ]; then
    echo "Error: URL is required."
    echo "Usage: $0 <URL> [--width=WIDTH] [--height=HEIGHT]"
    echo "Use --help for more information."
    exit 1
fi

# Rewrite localhost/127.0.0.1 to host.docker.internal so the container can reach the host
URL="${URL/localhost/host.docker.internal}"
URL="${URL/127.0.0.1/host.docker.internal}"

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Error: Container '${CONTAINER_NAME}' is not running."
    echo "Start it with: docker compose up -d"
    exit 1
fi

echo "Launching cog browser in container..."
echo "URL: $URL"

# Kill existing weston/cog processes and resize display (run as root, synchronously)
docker exec -u root ${CONTAINER_NAME} bash -c "
pkill -9 weston 2>/dev/null || true
pkill -9 cog 2>/dev/null || true
sleep 1

rm -rf /tmp/runtime-testuser
mkdir -p /tmp/runtime-testuser
chown testuser:testuser /tmp/runtime-testuser
chmod 700 /tmp/runtime-testuser

DISPLAY=:1 xrandr -s ${WIDTH}x${HEIGHT} 2>/dev/null || true
sleep 1
"

# Launch browser inside container (as testuser, in background)
docker exec -d ${CONTAINER_NAME} bash -c "
echo 'Waiting for X server...'
for i in {1..10}; do
    if DISPLAY=:1 xdpyinfo >/dev/null 2>&1; then
        echo 'X server is ready'
        break
    fi
    sleep 1
done

echo 'Starting Weston compositor...'
DISPLAY=:1 \
XDG_RUNTIME_DIR=/tmp/runtime-testuser \
weston --backend=x11-backend.so --width=${WIDTH} --height=${HEIGHT} > /tmp/weston.log 2>&1 &

WESTON_PID=\$!

echo 'Waiting for Weston...'
for i in {1..15}; do
    if [ -S /tmp/runtime-testuser/wayland-0 ]; then
        echo 'Weston is ready'
        break
    fi
    if [ \$i -eq 15 ]; then
        echo 'ERROR: Weston failed to start'
        cat /tmp/weston.log
        exit 1
    fi
    sleep 1
done

echo 'Launching cog...'
export DISPLAY=:1
export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/tmp/runtime-testuser
export COG_PLATFORM_WL_VIEW_FULLSCREEN=1
export G_MESSAGES_DEBUG=all
export WEBKIT_ENABLE_CONSOLE_LOG=1
export WEBKIT_INSPECTOR_SERVER=0.0.0.0:9222
export WEBKIT_INSPECTOR_HTTP_SERVER=0.0.0.0:9222
cog --platform=wl '$URL' > /home/testuser/cog.log 2>&1 &

COG_PID=\$!
sleep 2
if ps -p \$COG_PID > /dev/null 2>&1; then
    echo 'Cog is running'
else
    echo 'ERROR: Cog failed to start'
    cat /home/testuser/cog.log
    exit 1
fi
"

sleep 2

echo ""
echo "Browser launched!"
echo ""
echo "URL: $URL"
echo "Browser: cog 0.14.1 / WPEWebKit 2.38.2"
echo "Resolution: ${WIDTH}x${HEIGHT}"
echo ""
echo "View via noVNC (no client needed):"
echo "  http://localhost:6080"
echo ""
