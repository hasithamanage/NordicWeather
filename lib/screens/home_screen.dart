import 'package:flutter/material.dart';
import '../services/weather_service.dart';

/// The main home screen of the NordicWeather app.
/// Allows users to enter a city name, fetch weather data from the API, and display results.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Instance of WeatherService to handle API calls
  final WeatherService _weatherService = WeatherService();

  /// Holds fetched weather data for the city
  Map<String, dynamic>? weatherData;

  /// Boolean tracking whether an API request is in progress
  bool isLoading = false;

  /// Controller for the text field (city name input)
  TextEditingController cityController = TextEditingController();

  /// Fetch weather data for the city entered in the text field
  void fetchWeather() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Call the API via WeatherService
      final data = await _weatherService.fetchWeather(cityController.text);
      setState(() {
        weatherData = data; // Store the API response
      });
    } catch (e) {
      // Show an error message if API fails or city not found
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("City not found or API error")));
    }

    setState(() {
      isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    // Main UI of the home screen
    return Scaffold(
      appBar: AppBar(title: const Text("Nordic Weather")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input for city name
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "Enter city name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Button to fetch weather
            ElevatedButton(
              onPressed: fetchWeather,
              child: const Text("Get Weather"),
            ),
            const SizedBox(height: 20),
            // Show a loading spinner while API call is in progress
            if (isLoading) const CircularProgressIndicator(),
            // Display weather results if available and not loading
            if (weatherData != null && !isLoading)
              Column(
                children: [
                  // City name
                  Text(
                    weatherData!["name"],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Temperature
                  Text(
                    "${weatherData!["main"]["temp"]}°C",
                    style: const TextStyle(fontSize: 50),
                  ),
                  const SizedBox(height: 10),
                  // Weather description
                  Text(
                    weatherData!["weather"][0]["description"],
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
