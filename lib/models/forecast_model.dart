/// Data model representing a single 3-hour forecast entry, or in our case,
/// the selected "noon" entry for a future day.
/// This model is derived from the list provided by the OpenWeatherMap
/// '/forecast' endpoint.
class ForecastModel {
  final DateTime dateTime; // Time of the predicted forecast entry
  final double temperature; // Predicted temperature (°C)
  final String mainCondition; // e.g., 'Clouds', 'Clear', 'Rain'

  /// Constructor for the forecast model.
  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.mainCondition,
  });

  /// Factory constructor to create a ForecastModel instance from a JSON map.
  /// This map is typically one element from the 'list' array in the /forecast API response.
  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    // Unix timestamp (seconds since epoch) for the forecast time.
    final int timestamp = json['dt'] as int;

    // Convert Unix timestamp to a DateTime object (assuming the API returns UTC time that includes the timezone offset)
    final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );

    // OpenWeatherMap provides temperature as 'temp' under the 'main' object.
    final double temp = (json['main']['temp'] as num).toDouble();

    // Weather condition details are in a list under the 'weather' key.
    // We extract the high-level description ('main').
    final Map<String, dynamic> weatherInfo = json['weather'][0];

    return ForecastModel(
      dateTime: forecastTime,
      temperature: temp,
      mainCondition: weatherInfo['main'] as String,
    );
  }

  // --- Utility methods (optional) ---

  @override
  String toString() {
    return 'ForecastModel{dateTime: $dateTime, temperature: ${temperature.toStringAsFixed(1)}°C, condition: $mainCondition}';
  }
}
