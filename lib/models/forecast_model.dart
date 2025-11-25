class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String mainCondition;
  final int weatherId; // Crucial: ID for specific icon/Lottie mapping
  final String iconCode; // Crucial: Icon code for Day/Night determination

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.mainCondition,
    required this.weatherId,
    required this.iconCode,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        json['dt'] * 1000,
        isUtc: true,
      ).toLocal(),
      // Temperature is already in Celsius because the service uses &units=metric
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      weatherId: json['weather'][0]['id'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}
