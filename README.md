# 🌤️ NordicWeather

![MIT License](https://img.shields.io/badge/license-MIT-green)
![Flutter](https://img.shields.io/badge/flutter-%20-blue)
![OpenWeatherMap API](https://img.shields.io/badge/API-OpenWeatherMap-blue)
[![Project Board](https://img.shields.io/badge/Project_Board-Track_Here-blue)](https://github.com/hasithamanage/NordicWeather/projects)

A modern, visually engaging Flutter application that provides accurate current weather data and a precise 5-day forecast with dynamic animations and styling.

---

## 🚀 Status: Core Functionality Complete

The core weather fetching, processing, and primary UI features are fully implemented. Development is currently focused on polish, error handling, and secondary features. Track the progress via the [Project Board](https://github.com/hasithamanage/NordicWeather/projects).

---

## 🔥 Features

### ✅ Completed & Implemented

- **Dynamic Lottie Animations:** Main screen features animated Lottie icons that change based on the weather condition (e.g., thunder, rain, sun) and time of day.
- **Dynamic UI Styling:** Background gradients adapt instantly to weather conditions for immersive UX.
- **Accurate 5-Day Forecast:** Shows the forecast closest to 12:00 PM for each day—more relevant daily overviews.
- **Decoupled Architecture:** WeatherModel and ForecastModel are separated for clean, robust data management.
- **Full API Connection:** Real-time weather and forecast data via OpenWeatherMap API.
- **Service Structure:** Robust WeatherService handles all data fetching and logic.
- **Clean UI:** Modern, intuitive main weather screen.

### 🚧 In Progress

- Implement location detection ([#5](https://github.com/hasithamanage/NordicWeather/issues/5))

---

## 📋 Project Board

Track tasks, progress, and development milestones on the dedicated  
**[NordicWeather Project Board](https://github.com/hasithamanage/NordicWeather/projects)**.

---

## 🎬 Demo

<!-- Add your demo GIF or images here once ready -->
![image info](./kuvat/result(1).png)
![Screenshot Coming Soon](https://via.placeholder.com/400x300?text=Demo+Coming+Soon)

_Screenshots and live demo GIFs will be added as the project evolves!_

---

## 🛠️ Tech Stack

- **Flutter (Dart)**
- REST API (OpenWeatherMap)
- Material Design UI
- VS Code (recommended editor)
- lottie (dynamic weather animations)
- weather_icons (consistent icons for forecast)

---

## 🚀 Getting Started

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
> Keep your API key private—do NOT share or commit your `.env` file to a public repository.

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

## 🤝 Contributing

This project is under active development.  
**Contributions and suggestions are welcome once the core functionality is stable!**

- Please check for existing [issues](https://github.com/hasithamanage/NordicWeather/issues) before submitting a new one.
- For major changes, open a discussion or proposal before your PR.
- See `CONTRIBUTING.md` (coming soon) for detailed guidelines.

---

## 📄 License

Distributed under the MIT License.  
See [LICENSE](LICENSE) for more information.

---

## 📬 Contact / Support

Questions or suggestions?  
- Open an [issue](https://github.com/hasithamanage/NordicWeather/issues)
- Discussions: (coming soon)
- Or reach out via [GitHub profile](https://github.com/hasithamanage)