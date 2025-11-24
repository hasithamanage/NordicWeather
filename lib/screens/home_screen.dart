import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  /// Returns the appropriate Material Icon based on condition string.
  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return Icons.umbrella;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return Icons.filter_drama;
      default:
        return Icons.cloud_queue;
    }
  }

  // --- Data Fetching Logic ---

  /// Initiates the fetching of both current weather and the 5-day forecast.
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

    // Reset state and show loading indicator
    setState(() {
      isLoading = true;
      weatherData = null;
      forecastData = [];
      errorMessage = null;
    });

    try {
      // 1. Fetch Current Weather (required for main display)
      final currentWeather = await _weatherService.fetchWeather(cityName);

      // 2. Fetch 5-Day Forecast (required for forecast section)
      final fiveDayForecast = await _weatherService.fetchForecast(cityName);

      setState(() {
        weatherData = currentWeather;
        forecastData = fiveDayForecast; // Update state with forecast
      });
    } catch (e) {
      // Handle and display any exceptions during API calls
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
      // Hide loading indicator
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

              // Current Weather Icon
              Icon(
                _getWeatherIcon(weatherData!.mainCondition),
                size: 150,
                color: Colors.white,
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
          _buildStatRow(Icons.opacity, "Humidity", "${data.humidity}%"),
          _buildStatRow(
            Icons.air,
            "Wind Speed",
            "${data.windSpeed.toStringAsFixed(1)} m/s",
          ),
          _buildStatRow(
            Icons.wb_sunny_outlined,
            "Sunrise",
            // Format time: HH:MM
            '${data.sunrise.hour.toString().padLeft(2, '0')}:${data.sunrise.minute.toString().padLeft(2, '0')}',
          ),
          _buildStatRow(
            Icons.nightlight_round,
            "Sunset",
            // Format time: HH:MM
            '${data.sunset.hour.toString().padLeft(2, '0')}:${data.sunset.minute.toString().padLeft(2, '0')}',
          ),
        ],
      ),
    );
  }

  /// Helper to create a single row for a detailed stat (e.g., 'Humidity: 80%').
  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 20),
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

          // Weather Icon
          Icon(
            _getWeatherIcon(forecast.mainCondition),
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
