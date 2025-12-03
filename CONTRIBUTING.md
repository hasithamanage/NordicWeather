# Contributing

Thank you for your interest in contributing to NordicWeather! We appreciate any help - bug reports, feature requests, documentation improvements, tests or code.

This file explains how to report issues, propose changes, set up a development environment and prepare pull requests so contributions can be reviewed and merged quickly.

## Quick links
- Project board: https://github.com/hasithamanage/NordicWeather/projects
- Issues: https://github.com/hasithamanage/NordicWeather/issues
- Code: https://github.com/hasithamanage/NordicWeather

## Code of conduct
Please follow the project's Code of Conduct. If a CODE_OF_CONDUCT.md file does not exist yet, be respectful and professional in all interactions.

## Getting started (developer setup)
1. Fork the repo and clone your fork:
   ```sh
   git clone https://github.com/hasithamanage/NordicWeather.git
   cd NordicWeather
   ```
2. Create a branch for your work:
   ```sh
   git checkout -b feature/your-short-description
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Create a `.env` file in the project root with your OpenWeatherMap API key (do not commit this file):
   ```env
   API_KEY=YOUR_OPENWEATHERMAP_API_KEY_HERE
   ```
5. Run the app locally:
   ```sh
   flutter run
   ```

Notes:
- Do not commit your `.env` with API keys. Add `.env` to `.gitignore` if it isn't already.
- If you need platform-level permissions (location), update AndroidManifest.xml (Android) or Info.plist (iOS) as appropriate.

## Reporting bugs
When opening an issue for a bug, please include:
- A clear, descriptive title.
- Steps to reproduce the problem (minimal reproducible example where possible).
- Expected vs actual behavior.
- App version / commit SHA and platform (Android/iOS/emulator), and relevant logs or stack traces.
- Screenshots or screen recordings if helpful.

Example bug report body:
```
Title: Forecast list empty after app start on Android emulator
Steps:
1. Launch app
2. Enter city name X
3. Observe forecast list is empty
Expected: Forecast list displays 5 daily entries
Actual: Forecast list is empty, no errors in UI
Environment: Android emulator API 33, commit abc123
Logs: <paste relevant logs>
```

## Requesting features
For feature requests, include:
- A short summary of the feature and the problem it solves.
- Proposed UX or API changes (screens, sketches or APIs if applicable).
- Backwards compatibility considerations.

## How to contribute code
- Keep changes small and focused (one feature or bugfix per PR).
- Follow the existing code style and formatting rules. Run the formatter & analyzer:
  ```sh
  flutter format .
  flutter analyze
  ```
- Add tests for bug fixes and new features where applicable.
- Update or add documentation (README, code comments, assets list) when behavior changes.

### Branching and pull requests
- Branch from main (or the branch specified in the project board).
- Name branches like: `feature/`, `fix/`, or `chore/` followed by a short description, e.g. `feature/location-permissions`.
- Push to your fork and open a Pull Request against `main` in this repository.
- In your PR description, explain what you changed and why. Link related issues (e.g. `Closes #5`).

### Commit messages
We recommend using Conventional Commits for clear history:
```
feat(ui): add animated sunrise background
fix(service): handle null response from API
docs(readme): update setup instructions
```
Include a short description and if relevant, a longer body explaining the rationale.

### PR checklist
Before requesting review, make sure:
- [ ] Tests are added/updated and passing (where applicable)
- [ ] Linting and formatting have been applied
- [ ] The PR has a clear title and description
- [ ] Related issue is referenced (if any)
- [ ] CHANGELOG entry added (if relevant)

## Running tests & CI
- Unit/widget tests: `flutter test`
- Static analysis: `flutter analyze`
- Format: `flutter format .`

## Assets and Lottie files
- Ensure Lottie animation files are added under the assets directory and listed in `pubspec.yaml`.
- When adding large media, prefer using optimized formats and keep file sizes reasonable.

## Localization
If adding user-facing text, please consider adding localization keys and provide translations where possible.

## Security and API keys
- Never commit secrets or API keys. Use `.env` or a secure secret store for production.
- If you discover a security vulnerability, open an issue and mark it as sensitive or contact the repository owner directly.

## Attribution and license
By contributing, you agree that your contributions will be licensed under the project's MIT License.

## Getting help
- If you have questions or need guidance, open an issue or start a discussion on the project board.

---

Thanks for helping improve NordicWeather - your contributions make the app better for everyone!