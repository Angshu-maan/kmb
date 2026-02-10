class DriverResponse {
  final String status;
  final String message;
  final List<dynamic> data;

  DriverResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DriverResponse.fromJson(Map<String, dynamic> json) {
    return DriverResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] is List ? json['data'] : [],
    );
  }
}
