# GPSMAP 8000 Docker Image

Pre-built Docker image for testing web applications on Garmin GPSMAP 8000 browser.

## Specifications

| Property | Value |
|----------|-------|
| **Browser** | Epiphany 3.16.0 |
| **WebKit Engine** | WebKit 2.20.5 |
| **Display** | LXDE (X11) + noVNC |
| **Default Resolution** | 1920×1080 |
| **Accuracy** | ~85% (WebKit 2.20.5 is closest to real device WebKit 601.1) |
| **noVNC Port** | 6081 |

## Installation

### Option 1: Quick Start with Docker Hub (Recommended)

```bash
# Clone or download this repository
git clone https://github.com/scheiber-sa/garmin-docker-images.git
cd garmin-docker-images/GPSMAP8000

# Start the container (image is pulled automatically from Docker Hub)
docker compose up -d

# Launch a URL in the browser
bash launch-browser.sh http://localhost:4200/
```

The `docker-compose.yml` automatically pulls the pre-built image from Docker Hub.

### Option 2: Manual Pull and Run

```bash
# Pull the image
docker pull jkientz/scheiber-garmin-gpsmap8000:latest

# Run the container
docker run -d \
  --name gpsmap8000 \
  -p 6081:6081 \
  jkientz/scheiber-garmin-gpsmap8000:latest

# Launch a URL
bash launch-browser.sh http://localhost:4200/
```

### Option 3: Build Locally

If you want to build the image yourself:

```bash
git clone https://github.com/scheiber-sa/devices-docker-envs.git
cd devices-docker-envs/Garmin/GPSMAP8000

# Build the image (first time: ~15 min due to Epiphany compilation)
docker compose build

# Start the container
docker compose up -d

# Launch a URL
bash launch-browser.sh http://localhost:4200/
```

## Usage

### Launch a URL in the browser

```bash
# Default (1920×1080)
bash launch-browser.sh http://localhost:4200/

# Custom resolution (if needed)
bash launch-browser.sh http://localhost:4200/ --width=1920 --height=1080
```

### Open the noVNC Viewer

```bash
# On macOS/Linux
open http://localhost:6081

# On Windows
start http://localhost:6081
```

### Browser Info

The GPSMAP 8000 runs **Epiphany** (GNOME's default browser) in a full LXDE desktop environment. This gives you access to:

- Desktop environment UI (taskbar, system tray, etc.)
- Native file browser
- System settings
- Multiple applications

## Container Management

```bash
# Start
docker compose up -d

# Stop
docker compose down

# View logs
docker logs gpsmap8000

# Shell access
docker exec -it gpsmap8000 /bin/bash

# Access desktop VNC directly
vncviewer localhost:6081
```

## Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│ noVNC (localhost:6081)                          │
│ ├─ VNC                                          │
│ └─ LXDE Desktop (Xvfb)                          │
│    └─ Epiphany (WebKit 2.20.5 browser)          │
│       └─ Test URL                               │
└─────────────────────────────────────────────────┘
```

## WebKit Accuracy Note

The real GPSMAP 8000 device uses WebKit 601.1 (circa 2017). **WebKit 2.20.5 (2018)** is the closest available version recommended by Garmin. Expect ~85% accuracy for web application testing.

## Troubleshooting

### Container won't start

```bash
# Check image exists
docker images | grep gpsmap8000

# Check container status
docker ps -a | grep gpsmap8000

# View detailed logs
docker logs gpsmap8000
```

### noVNC not responding

- Ensure port 6081 is not in use: `lsof -i :6081`
- Try accessing via `http://localhost:6081/vnc.html`
- Restart container: `docker compose restart`

### Browser not launching URLs

```bash
# Verify URL is accessible from container
bash launch-browser.sh http://host.docker.internal:4200/

# Check container network
docker exec gpsmap8000 curl http://host.docker.internal:4200/
```

## Support

For issues with the image build or Docker setup, visit the [source repository](https://github.com/scheiber-sa/devices-docker-envs).
