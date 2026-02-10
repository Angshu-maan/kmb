class OwnerResponse {
  final String status;
  final String message;
  final List<dynamic> data;

  OwnerResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OwnerResponse.fromJson(Map<String, dynamic> json) {
    return OwnerResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] is List ? json['data'] : [],
    );
  }
}
