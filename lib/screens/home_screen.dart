import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:lottie/lottie.dart'; // Required for Lottie animations

import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

/// The main screen of the application, responsible for fetching and displaying
/// current weather and the 5-day forecast.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();

  // State variables for current weather, forecast, and UI management
  WeatherModel? weatherData;
  List<ForecastModel> forecastData = [];
  String? errorMessage;

  bool isLoading = false;
  TextEditingController cityController = TextEditingController();

  // --- UI Utility Functions ---

  /// Determines the background gradient colors based on the main weather condition.
  List<Color> _getBackgroundGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [
          const Color(0xFF4FC3F7), // Light Blue
          const Color(0xFF0277BD), // Dark Blue
        ];
      case 'clouds':
        return [
          const Color(0xFFB0BEC5), // Light Gray
          const Color(0xFF546E7A), // Slate Gray
        ];
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return [
          const Color(0xFF78909C), // Medium Gray
          const Color(0xFF455A64), // Dark Slate Gray
        ];
      case 'snow':
        return [
          const Color(0xFFE3F2FD), // Very Light Blue
          const Color(0xFF90CAF9), // Light Blue
        ];
      case 'mist':
      case 'fog':
      case 'haze':
        return [
          const Color(0xFFCFD8DC), // Cloud Gray
          const Color(0xFF90A4AE), // Misty Gray
        ];
      default:
        return [const Color(0xFF4FC3F7), const Color(0xFF0277BD)];
    }
  }

  /// Returns the asset path for the Lottie animation based on the OWM ID and icon code (Day/Night).
  String _getLottieAsset(int id, String iconCode) {
    final isNight = iconCode.endsWith('n');
    final mainId =
        id ~/ 100; // Get the main weather group (2xx, 3xx, 8xx, etc.)

    // --- 7xx Atmosphere: Mist, Smoke, Haze, Fog ---
    if (mainId == 7) {
      if (id == 701 || id == 741) {
        // Mist, Fog
        return 'assets/lottie/foggy.json';
      }
      return 'assets/lottie/mist.json'; // Haze, Smoke, Dust, etc.
    }

    // --- 2xx Thunderstorm ---
    if (mainId == 2) {
      if (id >= 211 && id <= 221) {
        // Heavy/Ragged Thunderstorms
        return 'assets/lottie/shower_strom_day.json';
      }
      return 'assets/lottie/thunder.json'; // General thunderstorm
    }

    // --- 6xx Snow ---
    if (mainId == 6) {
      if (isNight) {
        return 'assets/lottie/snow_night.json';
      }
      // Light snow in the day
      if (id == 600 || id == 620) {
        return 'assets/lottie/snow_sunny.json';
      }
      return 'assets/lottie/snow.json'; // General snow, sleet, or heavy
    }

    // --- 5xx Rain & 3xx Drizzle ---
    if (mainId == 3 || mainId == 5) {
      if (isNight) {
        return 'assets/lottie/rainy_night.json';
      }
      return 'assets/lottie/partly_shower.json'; // General daytime rain/drizzle
    }

    // --- 8xx Clear & Clouds ---
    if (mainId == 8) {
      if (id == 800) {
        // Clear
        return isNight
            ? 'assets/lottie/clear_night.json'
            : 'assets/lottie/sunny.json';
      }

      // All other clouds (801 - 804, including the specific 804 overcast case)
      return isNight
          ? 'assets/lottie/cloudy_night.json'
          : 'assets/lottie/partly_cloudy.json';
    }

    // Fallback: This could be used for 781 Tornado or other unsupported IDs
    return 'assets/lottie/partly_cloudy.json';
  }

  /// Returns the appropriate Weather Icon based on the OWM ID.
  dynamic _getWeatherIcon(int id) {
    final mainId = id ~/ 100;

    // --- 2xx Thunderstorm ---
    if (mainId == 2) return WeatherIcons.thunderstorm;
    // --- 3xx Drizzle ---
    if (mainId == 3) return WeatherIcons.sprinkle;
    // --- 5xx Rain ---
    if (mainId == 5) return WeatherIcons.rain;
    // --- 6xx Snow ---
    if (mainId == 6) return WeatherIcons.snow;
    // --- 7xx Atmosphere ---
    if (mainId == 7) {
      if (id == 781) return WeatherIcons.tornado;
      return WeatherIcons.fog;
    }
    // --- 8xx Clear & Clouds ---
    if (mainId == 8) {
      if (id == 800) return WeatherIcons.day_sunny; // Clear
      if (id == 801) return WeatherIcons.day_cloudy_gusts; // Few clouds
      if (id == 804) return WeatherIcons.cloud; // Overcast (804)
      return WeatherIcons.cloudy; // 802, 803
    }

    return WeatherIcons.cloudy_gusts; // Default fallback icon
  }

  // --- Data Fetching Logic ---

  void fetchWeather() async {
    final cityName = cityController.text.trim();
    if (cityName.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a city name.")),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
      weatherData = null;
      forecastData = [];
      errorMessage = null;
    });

    try {
      final currentWeather = await _weatherService.fetchWeather(cityName);
      final fiveDayForecast = await _weatherService.fetchForecast(cityName);

      setState(() {
        weatherData = currentWeather;
        forecastData = fiveDayForecast;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            "Could not fetch weather. ${e.toString().split(':').last.trim()}";
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage!)));
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  // --- Widget Building Methods ---

  @override
  Widget build(BuildContext context) {
    final mainCondition = weatherData?.mainCondition ?? 'Clear';
    final gradientColors = _getBackgroundGradient(mainCondition);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nordic Weather",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: gradientColors.last.withAlpha(204),
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // City Input Field
              TextField(
                controller: cityController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Enter city name",
                  labelStyle: const TextStyle(color: Colors.white70),
                  fillColor: Colors.white.withAlpha(25),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                onSubmitted: (_) => fetchWeather(),
              ),

              const SizedBox(height: 20),

              // Get Weather Button
              ElevatedButton(
                onPressed: isLoading ? null : fetchWeather,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: gradientColors.last,
                  elevation: 5,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "Get Weather",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: 40),

              // Main Content (Weather Data, Error, or Prompt)
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the main content area based on current state (Loading, Error, Data)
  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (errorMessage != null) {
      // Error State
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              "Error: Failed to Load",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (weatherData != null) {
      // Data Display State
      return AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Column(
            children: [
              // City Name
              Text(
                weatherData!.cityName,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black26)],
                ),
              ),
              const SizedBox(height: 30),

              // LOTTIE ANIMATION
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  _getLottieAsset(
                    weatherData!.weatherId,
                    weatherData!.iconCode,
                  ),
                  repeat: true,
                  animate: true,
                ),
              ),

              const SizedBox(height: 20),

              // Current Temperature
              Text(
                "${weatherData!.temperature.toStringAsFixed(1)}°C",
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black26)],
                ),
              ),

              const SizedBox(height: 10),

              // Weather Description
              Text(
                weatherData!.description,
                style: const TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 3, color: Colors.black26)],
                ),
              ),

              const SizedBox(height: 30),

              // Detailed Stats Section
              _buildDetailedStats(weatherData!),

              // 5-Day Forecast Section (Conditionally rendered)
              if (forecastData.isNotEmpty) ...[
                const SizedBox(height: 40),
                _buildForecastSection(),
              ],
            ],
          ),
        ),
      );
    }

    // Initial State (Default message)
    return Center(
      child: Column(
        children: const [
          Icon(Icons.location_on_outlined, size: 80, color: Colors.white54),
          SizedBox(height: 16),
          Text(
            "Search for a Nordic City",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// Builds a widget showing detailed weather statistics (Humidity, Wind, Sun times).
  Widget _buildDetailedStats(WeatherModel data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Stat 1: Humidity
          _buildStatRow(WeatherIcons.humidity, "Humidity", "${data.humidity}%"),
          // Stat 2: Wind Speed
          _buildStatRow(
            WeatherIcons.strong_wind,
            "Wind Speed",
            "${data.windSpeed.toStringAsFixed(1)} m/s",
          ),
          // Stat 3: Sunrise
          _buildStatRow(
            WeatherIcons.sunrise,
            "Sunrise",
            // Format time: HH:MM
            '${data.sunrise.hour.toString().padLeft(2, '0')}:${data.sunrise.minute.toString().padLeft(2, '0')}',
          ),
          // Stat 4: Sunset
          _buildStatRow(
            WeatherIcons.sunset,
            "Sunset",
            // Format time: HH:MM
            '${data.sunset.hour.toString().padLeft(2, '0')}:${data.sunset.minute.toString().padLeft(2, '0')}',
          ),
        ],
      ),
    );
  }

  /// Helper to create a single row for a detailed stat (e.g., 'Humidity: 80%').
  Widget _buildStatRow(dynamic icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon as IconData, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- Forecast Building Widgets ---

  /// Builds the header and horizontal list view for the 5-day forecast.
  Widget _buildForecastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "5-Day Forecast (Noon)",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),

        // Horizontal list view for the forecast items
        SizedBox(
          height: 120, // Height to fit the forecast cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecastData.length,
            itemBuilder: (context, index) {
              final forecast = forecastData[index];
              return _buildForecastCard(forecast);
            },
          ),
        ),
      ],
    );
  }

  /// Builds a single forecast card for one day.
  Widget _buildForecastCard(ForecastModel forecast) {
    // Format the date to show the day of the week (e.g., 'Mon')
    final dayOfWeek = DateFormat('EEE').format(forecast.dateTime);
    final weatherId = forecast.weatherId;

    return Container(
      width: 100, // Fixed width for each card
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40), // Semi-transparent white background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(80), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Day of the Week
          Text(
            dayOfWeek,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          // Weather Icon (using WeatherIcons)
          Icon(
            _getWeatherIcon(weatherId) as IconData, // Uses the same ID logic
            size: 30,
            color: Colors.white,
          ),

          // Temperature
          Text(
            "${forecast.temperature.toStringAsFixed(0)}°C",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
