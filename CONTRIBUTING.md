# Contributing

We welcome contributions and improvements to the Garmin Docker images and scripts!

## For Script Improvements

If you want to improve the `launch-browser.sh` scripts or documentation:

1. Fork this repository
2. Create a feature branch: `git checkout -b feature/your-improvement`
3. Make your changes and test thoroughly
4. Commit with a clear message: `git commit -m "Improve: brief description"`
5. Push to your fork: `git push origin feature/your-improvement`
6. Open a Pull Request

## For Image Issues

If you find a bug in the Docker images:

1. **Check existing issues** to avoid duplicates
2. **Provide details**:
   - GPSMAP device (9000 or 8000)
   - URL you're testing
   - Screenshot/logs of the issue
   - Your environment (OS, Docker version)
3. Create an issue with the label `bug`

## For Feature Requests

Have an idea for a new feature?

1. Check existing issues and discussions first
2. Create a new issue with the label `enhancement`
3. Describe:
   - What problem it solves
   - How it should work
   - Example usage

## Guidelines

- Keep scripts POSIX-compliant (portable across Linux/macOS/WSL)
- Test changes with both GPSMAP 9000 and 8000 if possible
- Update README if you change behavior
- Document workarounds for known issues
- Include examples in comments

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others with questions
- Report inappropriate behavior to maintainers

## Questions?

Open a discussion or issue with `question` label.
