import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for fetching weather data from the OpenWeatherMap API
class WeatherService {
  /// OpenWeatherMap API key
  final String apiKey = "77bc33883ff59d28f0f2dc5f4b454c18";

  /// Fetches weather data for the provided [city] from the API.
  /// Returns a Map with weather info if successful, or throws an error if it fails.
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    // Build the API URL with the city name and API key
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    // Make an HTTP GET request to the weather API
    final response = await http.get(Uri.parse(url));

    // If the request was successful, decode and return the JSON data.
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // If the request failed, throw an exception.
      throw Exception("Failed to load weather data");
    }
  }
}
