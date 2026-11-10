# Repository Structure

This repository contains the **public-facing** Docker images and scripts for Garmin device testing.

## Two-Repository Strategy

### 1. **Public Repository** (this one) 🌐
**Purpose**: Users download pre-built Docker images and test scripts  
**Access**: Public on GitHub  
**Content**:
- `docker-compose.yml` — Pull pre-built images from Docker Hub
- `launch-browser.sh` — Easy-to-use browser launcher scripts
- `README.md` — Documentation and usage guides
- No Dockerfile or build dependencies

**Get Started**:
```bash
git clone https://github.com/scheiber-sa/garmin-docker-images.git
cd garmin-docker-images/GPSMAP9000
docker compose up -d
bash launch-browser.sh http://localhost:4200/
```

### 2. **Private Repository** (devices-docker-envs) 🔒
**Purpose**: Maintain Dockerfile, build images, push to Docker Hub  
**Access**: Private (team/organization only)  
**Content**:
- `Dockerfile` — Container build definitions
- `docker-compose.yml` (build version) — Local build configuration
- Build dependencies (archives, config files, etc.)
- Build scripts and CI/CD pipeline

**Purpose**: 
- Source of truth for image compilation
- Maintain build history and dependencies
- Deploy new versions to Docker Hub

---

## Workflow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. DEVELOPMENT (Private Repository)                         │
│    └─ Edit Dockerfile, test locally                         │
│       docker compose build && docker compose up -d          │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. BUILD & PUSH                                             │
│    └─ docker compose build                                  │
│       docker tag IMAGE_ID jkientz/scheiber-garmin-DEVICE   │
│       docker push jkientz/scheiber-garmin-DEVICE:latest    │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. PUBLIC REPOSITORY UPDATED                                │
│    └─ Users pull pre-built images with docker compose      │
│       No compilation needed!                                │
└─────────────────────────────────────────────────────────────┘
```

---

## Docker Hub Images

Published images:
- `jkientz/scheiber-garmin-gpsmap9000:latest` — WPEWebKit 2.38.2 (3840×2160)
- `jkientz/scheiber-garmin-gpsmap8000:latest` — WebKit 2.20.5 (1920×1080)

---

## For Developers

If you're maintaining the Docker images, you need access to the **private** repository:

```bash
git clone https://github.com/scheiber-sa/devices-docker-envs.git
cd devices-docker-envs/Garmin/GPSMAP9000
docker compose build
docker compose up -d
# Make changes, test locally...
docker compose down
docker tag IMAGE_ID jkientz/scheiber-garmin-gpsmap9000:latest
docker push jkientz/scheiber-garmin-gpsmap9000:latest
```

Then update this public repository with any script changes if needed.

---

## FAQ

**Q: Can I modify the scripts?**  
A: Yes! Edit `launch-browser.sh` in your local clone. Make a pull request to share improvements.

**Q: How do I report a bug?**  
A: File an issue in this repository. For build issues, contact maintainers.

**Q: Can I push to Docker Hub myself?**  
A: Only authorized team members have Docker Hub push access. Contact project maintainers.

**Q: How do I update the images?**  
A: Changes go into the private `devices-docker-envs` repository. Once built and tested, they're pushed to Docker Hub automatically (or manually by maintainers).
