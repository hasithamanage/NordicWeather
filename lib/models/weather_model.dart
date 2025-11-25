class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String description;
  final int humidity;
  final double windSpeed;
  final DateTime sunrise;
  final DateTime sunset;
  final int weatherId; // ID for specific mapping (e.g., 804)
  final String
  iconCode; // Icon code for Day/Night determination (e.g., '01d', '01n')

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.weatherId,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      // Temperature is already in Celsius because the service uses &units=metric
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      // Convert Unix timestamps to DateTime
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        json['sys']['sunrise'] * 1000,
        isUtc: true,
      ).toLocal(),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        json['sys']['sunset'] * 1000,
        isUtc: true,
      ).toLocal(),
      weatherId: json['weather'][0]['id'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}
