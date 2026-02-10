class ApplicationResponse<T> {
  final String status;
  final String message;
  final T data;

  ApplicationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApplicationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApplicationResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: fromJsonT(json['data']),
    );
  }
}
