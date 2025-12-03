# 🌤️ NordicWeather

![MIT License](https://img.shields.io/badge/license-MIT-green)
![Flutter](https://img.shields.io/badge/flutter-%20-blue)
![OpenWeatherMap API](https://img.shields.io/badge/API-OpenWeatherMap-blue)
[![Project Board](https://img.shields.io/badge/Project_Board-Track_Here-blue)](https://github.com/hasithamanage/NordicWeather/projects)

A modern, visually engaging Flutter app that displays accurate current weather and a precise 5-day forecast with dynamic animations and styling.

---

## 🚀 Status: Core Functionality Complete

Core weather fetching, processing, and primary UI are implemented. Current focus: polish, error handling, and secondary features. Track progress on the [Project Board](https://github.com/hasithamanage/NordicWeather/projects).

---

## 🔥 Highlights

- Dynamic Lottie animations and adaptive background gradients based on weather and time-of-day.
- Accurate 5-day forecast (selects the item closest to 12:00 PM each day for a relevant daily summary).
- Clean separation of concerns: WeatherModel, ForecastModel, and WeatherService.
- Full OpenWeatherMap API integration and robust service-layer logic.
- Modern, responsive UI built with Flutter.

---

## ✅ Implemented

- Dynamic Lottie animations that change with weather conditions.
- Adaptive UI gradients for immersive UX.
- 5-day forecast using the midday-sampling heuristic (closest to 12:00 PM).
- Decoupled data models (WeatherModel, ForecastModel).
- WeatherService handling API calls and forecast filtering.

## 🚧 In Progress

- Location detection and permission handling - see issue [#5](https://github.com/hasithamanage/NordicWeather/issues/5).

---

## 🎬 Demo

<!-- Add your demo GIF or images here once ready -->
![image info](./kuvat/result(1).png)
![image info](./kuvat/result(2).png)
![image info](./kuvat/result(3).png)

_Screenshots and live demo GIFs will be added as the project evolves!_

---

## 🛠️ Tech Stack

- Flutter (Dart)
- OpenWeatherMap REST API
- Lottie for animations
- weather_icons package
- Material Design

---

## 🚀 Quick Start

```sh
# 1. Clone the repository
git clone https://github.com/hasithamanage/NordicWeather.git

# 2. Navigate to the project directory
cd NordicWeather

# 3. Get packages
flutter pub get

# 4. (Required) Create a .env file and add your API key:
# API_KEY=YOUR_OPENWEATHERMAP_API_KEY_HERE

# 5. Run the application
flutter run
```

> ⚠️ **API Key Security:**  
> Keep your API key private. Do not share or commit your `.env` file to a public repository.

---

## 📂 Project Structure

```
lib/
├── main.dart
├── screens/
│   └── home_screen.dart        # Main application UI and logic
├── widgets/
├── services/
│   └── weather_service.dart    # API calls and forecast filtering logic
└── models/
    ├── forecast_model.dart     # Daily forecast data structure
    └── weather_model.dart      # Current weather data structure
```

---

## 💡 How forecasting works (short)
OpenWeatherMap provides 3-hourly forecast entries; the app selects, for each day, the forecast entry whose timestamp is closest to 12:00 PM local time to create a meaningful daily summary.

---

## ❗ Troubleshooting & Known issues

- If the app shows empty forecast data, confirm your API key is valid and not rate-limited.
- Location-based features require platform permissions (AndroidManifest / Info.plist). See issue [#5](https://github.com/hasithamanage/NordicWeather/issues/5) for progress.
- If animations fail to load, ensure Lottie assets are present and referenced correctly.

---

## 🛡️ Security & API keys

- Keep your OpenWeatherMap API key private. Add `.env` to `.gitignore`.
- Consider using a secrets manager or server-side proxy if you plan to publish a production app to avoid exposing API keys.

---

## 🤝 Contributing

Contributions are welcome! Please:
1. Check existing issues before opening a new one.
2. For major changes, open an issue or discussion first.
3. Follow repository conventions (formatting, tests).
4. See `CONTRIBUTING.md` for details.

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.

---

## 📬 Contact / Support

- Open an [issue](https://github.com/hasithamanage/NordicWeather/issues)
- Project board: [NordicWeather Development Roadmap](https://github.com/hasithamanage/NordicWeather/projects)
- GitHub: https://github.com/hasithamanage
