# Garmin Docker Images

Pre-built Docker images for testing web applications on Garmin device browsers without physical hardware.

All images are available on [Docker Hub](https://hub.docker.com/u/jkientz/) and ready to use — no compilation needed.

## Images Available

| Device | Browser | WebKit | Resolution | Accuracy | noVNC Port | Docker Hub |
|--------|---------|--------|------------|----------|------------|-----------|
| [GPSMAP 9000](#gpsmap-9000) | cog 0.14.1 | WPEWebKit 2.38.2 | 3840×2160 | ~99% | 6080 | `jkientz/scheiber-garmin-gpsmap9000` |
| [GPSMAP 8000](#gpsmap-8000) | Epiphany 3.16.0 | WebKit 2.20.5 | 1920×1080 | ~85% | 6081 | `jkientz/scheiber-garmin-gpsmap8000` |

## Quick Start

Each device has a `launch-browser.sh` script for easy URL testing:

```bash
# GPSMAP 9000
cd GPSMAP9000
bash launch-browser.sh http://localhost:4200/

# GPSMAP 8000
cd GPSMAP8000
bash launch-browser.sh http://localhost:4200/
```

All environments expose a **browser-accessible noVNC interface** — no VNC client required.

## Documentation

- [GPSMAP 9000 Setup Guide](./GPSMAP9000/README.md)
- [GPSMAP 8000 Setup Guide](./GPSMAP8000/README.md)

## License

MIT License — see LICENSE file for details.
