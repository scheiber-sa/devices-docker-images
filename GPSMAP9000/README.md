# GPSMAP 9000 Docker Image

Pre-built Docker image for testing web applications on Garmin GPSMAP 9000 browser.

## Specifications

| Property | Value |
|----------|-------|
| **Browser** | cog 0.14.1 |
| **WebKit Engine** | WPEWebKit 2.38.2 |
| **Display** | Weston (Wayland) + x11vnc + noVNC |
| **Default Resolution** | 3840×2160 |
| **Accuracy** | ~99% (exact match) |
| **noVNC Port** | 6080 |
| **WebKit Inspector Port** | 9222 |

## Installation

### Option 1: Quick Start with Docker Hub (Recommended)

```bash
# Clone or download this repository
git clone https://github.com/scheiber-sa/garmin-docker-images.git
cd garmin-docker-images/GPSMAP9000

# Start the container (image is pulled automatically from Docker Hub)
docker compose up -d

# Launch a URL in the browser
bash launch-browser.sh http://localhost:4200/
```

The `docker-compose.yml` automatically pulls the pre-built image from Docker Hub.

### Option 2: Manual Pull and Run

```bash
# Pull the image
docker pull jkientz/scheiber-garmin-gpsmap9000:latest

# Run the container
docker run -d \
  --name gpsmap9000 \
  -p 6080:6080 \
  -p 9222:9222 \
  jkientz/scheiber-garmin-gpsmap9000:latest

# Launch a URL
bash launch-browser.sh http://localhost:4200/
```

### Option 3: Build Locally

If you want to build the image yourself:

```bash
git clone https://github.com/scheiber-sa/devices-docker-envs.git
cd devices-docker-envs/Garmin/GPSMAP9000

# Build the image (first time: ~30 min due to WPEWebKit compilation)
docker compose build

# Start the container
docker compose up -d

# Launch a URL
bash launch-browser.sh http://localhost:4200/
```

## Usage

### Launch a URL in the browser

```bash
# Default (3840×2160)
bash launch-browser.sh http://localhost:4200/

# Custom resolution (10" display)
bash launch-browser.sh http://localhost:4200/ --width=1920 --height=1200

# Custom resolution (arbitrary)
bash launch-browser.sh http://localhost:4200/ --width=1920 --height=1080
```

### Device Presets

| Screen Size | Resolution | Command |
|-------------|------------|---------|
| 10" (small) | 1920×1200 | `bash launch-browser.sh <URL> --width=1920 --height=1200` |
| 13"–27" (default) | 3840×2160 | `bash launch-browser.sh <URL>` |

### Open the noVNC Viewer

```bash
# On macOS/Linux
open http://localhost:6080

# On Windows
start http://localhost:6080
```

### View Browser Logs

If running from the source repository:

```bash
bash view-logs.sh
```

### Connect WebKit Remote Inspector

The container exposes the WebKit Inspector on **port 9222**:

```bash
# macOS (in Safari)
Safari → Develop → host.docker.internal:9222 → <page title>

# Chrome/Firefox
http://localhost:9222
```

## Container Management

```bash
# Start
docker compose up -d

# Stop
docker compose down

# View logs
docker logs gpsmap9000

# Shell access
docker exec -it gpsmap9000 /bin/bash
```

## Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│ noVNC (localhost:6080)                          │
│ ├─ x11vnc                                       │
│ └─ Xvfb (:1)                                    │
│    └─ Weston (Wayland compositor)               │
│       └─ cog (WPEWebKit 2.38.2 browser)         │
│          └─ Test URL                            │
└─────────────────────────────────────────────────┘
```

## Troubleshooting

### Container won't start

```bash
# Check image exists
docker images | grep gpsmap9000

# Check container status
docker ps -a | grep gpsmap9000

# View detailed logs
docker logs gpsmap9000
```

### noVNC not responding

- Ensure port 6080 is not in use: `lsof -i :6080`
- Try accessing via `http://localhost:6080/vnc.html`
- Restart container: `docker compose restart`

### Browser not launching URLs

```bash
# Verify URL format (must be accessible from container)
bash launch-browser.sh http://host.docker.internal:4200/

# Check container network
docker exec gpsmap9000 curl http://host.docker.internal:4200/
```

## Support

For issues with the image build or Docker setup, visit the [source repository](https://github.com/scheiber-sa/devices-docker-envs).
