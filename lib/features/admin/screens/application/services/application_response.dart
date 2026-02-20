import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_pagination_model.dart';

class ApplicationResponse {
  final String status;
  final String message;
  final List<ApplicationModel> data;
  final ApplicationPagination pagination;

  const ApplicationResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: ApplicationPagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
