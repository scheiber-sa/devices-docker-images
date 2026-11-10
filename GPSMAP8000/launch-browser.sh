#!/bin/bash

# Launch Epiphany browser (WebKit 2.20.5) in the GPSMAP 8000 container.
# Usage: bash launch-browser.sh <URL> [--width=WIDTH] [--height=HEIGHT]
#
# Device preset:
#   GPSMAP 8000 (all sizes): bash launch-browser.sh <URL>  (default: 1920x1080)

CONTAINER_NAME="gpsmap8000"
WIDTH="1920"
HEIGHT="1080"

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
            echo "  --width=WIDTH     Screen width in pixels  (default: 1920)"
            echo "  --height=HEIGHT   Screen height in pixels (default: 1080)"
            echo ""
            echo "GPSMAP 8000 Device Preset:"
            echo "  All sizes:        $0 <URL>  (default: 1920x1080)"
            echo ""
            echo "Examples:"
            echo "  $0 http://localhost:4200/"
            echo "  $0 http://localhost:9000/?env=dev"
            echo "  $0 http://192.168.1.100:4200/ --width=1920 --height=1080"
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

echo "Launching Epiphany browser in container..."
echo "URL: $URL"

# Kill existing browser and resize display (synchronously)
docker exec ${CONTAINER_NAME} bash -c "
pkill -9 epiphany 2>/dev/null || true
sleep 1
DISPLAY=:1 xrandr -s ${WIDTH}x${HEIGHT} 2>/dev/null || true
sleep 1
"

# Launch Epiphany in background
docker exec -d ${CONTAINER_NAME} bash -c "
DISPLAY=:1 epiphany '$URL' > /tmp/epiphany.log 2>&1 &
"

sleep 2

echo ""
echo "Browser launched!"
echo ""
echo "URL: $URL"
echo "Browser: Epiphany 3.16.0 / WebKit 2.20.5"
echo "Resolution: ${WIDTH}x${HEIGHT}"
echo ""
echo "View via noVNC (no client needed):"
echo "  http://localhost:6081"
echo ""
