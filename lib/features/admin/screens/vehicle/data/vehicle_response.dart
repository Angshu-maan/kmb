class VehicleResponse {
  final String status;
  final String message;
  final List<dynamic> data;

  VehicleResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] is List ? json['data'] : [],
    );
  }
}
