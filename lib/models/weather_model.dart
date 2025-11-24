import 'package:intl/intl.dart';

/// Data model representing the CURRENT weather conditions fetched from
/// the OpenWeatherMap '/weather' endpoint.
class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition; // e.g., 'Clouds', 'Clear', 'Rain'
  final String description; // e.g., 'scattered clouds'
  final int humidity; // percentage
  final double windSpeed; // meters/sec
  final DateTime sunrise; // Local time of sunrise
  final DateTime sunset; // Local time of sunset

  /// Constructor for the current weather model.
  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
  });

  /// Factory constructor to create a WeatherModel instance from a JSON map
  /// (the API response body).
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // OpenWeatherMap provides temperature as 'temp' under the 'main' object.
    final double temp = (json['main']['temp'] as num).toDouble();

    // OpenWeatherMap provides wind speed as 'speed' under the 'wind' object.
    final double wind = (json['wind']['speed'] as num).toDouble();

    // Weather condition details are in a list under the 'weather' key.
    // We take the first element in that list.
    final Map<String, dynamic> weatherInfo = json['weather'][0];

    // Unix timestamps (seconds since epoch) for sun times.
    final int sunriseTimestamp = json['sys']['sunrise'] as int;
    final int sunsetTimestamp = json['sys']['sunset'] as int;

    // The API includes a timezone offset (in seconds) that must be applied
    // to timestamps to get the correct local time (DateTime).
    final int timezoneOffsetSeconds = json['timezone'] as int;

    /// This local function converts Unix seconds + timezone offset to local DateTime.
    DateTime convertTimestampLocal(int timestamp) {
      // Create a DateTime object in UTC from the timestamp
      final utcTime = DateTime.fromMillisecondsSinceEpoch(
        timestamp * 1000,
        isUtc: true,
      );

      // Apply the local timezone offset to get the correct local time
      return utcTime.add(Duration(seconds: timezoneOffsetSeconds));
    }

    return WeatherModel(
      cityName: json['name'] as String,
      temperature: temp,
      mainCondition: weatherInfo['main'] as String,
      description: weatherInfo['description'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: wind,
      sunrise: convertTimestampLocal(sunriseTimestamp),
      sunset: convertTimestampLocal(sunsetTimestamp),
    );
  }

  // --- Utility methods (optional, but good practice for debugging) ---

  @override
  String toString() {
    return 'WeatherModel{cityName: $cityName, temperature: ${temperature.toStringAsFixed(1)}°C, '
        'condition: $mainCondition, humidity: $humidity%, wind: ${windSpeed.toStringAsFixed(1)} m/s, '
        'sunrise: ${DateFormat('HH:mm').format(sunrise)}, sunset: ${DateFormat('HH:mm').format(sunset)}}';
  }
}
