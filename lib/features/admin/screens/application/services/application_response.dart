class ApplicationResponse {
  final String status;
  final String message;
  final List<dynamic> data;

  ApplicationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] is List ? json['data'] : [],
    );
  }
}
