import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

/// Service class for fetching weather data from the OpenWeatherMap API.
class WeatherService {
  final String apiKey = dotenv.env['API_KEY']!;

  // Base URLs for current weather and 5-day forecast endpoints
  static const String _weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _forecastBaseUrl =
      'https://api.openweathermap.org/data/2.5/forecast';

  // --- Current Weather Fetching ---

  /// Fetches current weather data for a given [city] name.
  /// Returns a Future WeatherModel containing the current conditions.
  Future<WeatherModel> fetchWeather(String city) async {
    // Construct the URI with city, API key, and metric units
    final uri = Uri.parse(
      '$_weatherBaseUrl?q=$city&appid=$apiKey&units=metric',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('City not found. Status code: 404');
    } else {
      throw Exception(
        'Failed to load weather data. Status code: ${response.statusCode}',
      );
    }
  }

  // --- 5-Day Forecast Fetching ---

  /// Fetches the 5-day / 3-hour forecast for a given [city] and processes it.
  /// The OpenWeatherMap forecast endpoint returns 40 data points (every 3 hours).
  /// This method filters those down to one data point per day (closest to noon).
  Future<List<ForecastModel>> fetchForecast(String city) async {
    final uri = Uri.parse(
      '$_forecastBaseUrl?q=$city&appid=$apiKey&units=metric',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      final forecastList = json['list'] as List<dynamic>;

      // Map to store the best forecast for each day (key is dayOfYear)
      final Map<int, ForecastModel> dailyForecasts = {};
      final nowDayOfYear = DateTime.now().dayOfYear;

      for (var itemJson in forecastList) {
        final forecast = ForecastModel.fromJson(
          itemJson as Map<String, dynamic>,
        );

        final dayOfYear = forecast.dateTime.dayOfYear;

        // Skip the current day, as its weather is handled by fetchWeather()
        if (dayOfYear == nowDayOfYear) {
          continue;
        }

        // We look for the data point closest to 12:00 PM for a stable daily temperature
        final targetHour = 12;
        final currentHourDifference = (forecast.dateTime.hour - targetHour)
            .abs();

        // If no entry exists for this day, or the current entry is closer to noon, update the map.
        if (!dailyForecasts.containsKey(dayOfYear) ||
            (dailyForecasts.containsKey(dayOfYear) &&
                (dailyForecasts[dayOfYear]!.dateTime.hour - targetHour).abs() >
                    currentHourDifference)) {
          dailyForecasts[dayOfYear] = forecast;
        }
      }

      // Return the values from the map (which contain the next 5 days of forecast)
      return dailyForecasts.values.toList();
    } else if (response.statusCode == 404) {
      throw Exception('Forecast city not found. Status code: 404');
    } else {
      throw Exception(
        'Failed to load forecast data. Status code: ${response.statusCode}',
      );
    }
  }
}

/// Extension on DateTime to calculate the day of the year (1-366).
/// This is used to correctly group forecast entries by calendar day.
extension on DateTime {
  int get dayOfYear {
    // Calculates the day number since the beginning of the year
    return difference(DateTime(year, 1, 1)).inDays + 1;
  }
}
