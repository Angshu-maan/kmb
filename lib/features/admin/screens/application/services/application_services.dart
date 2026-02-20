import 'package:kmb_app/config/api_config.dart';
import 'package:kmb_app/core/network/api_client.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_response.dart';

class ApplicationService {
  Future<ApplicationResponse> fetchApplications({
    required String token,
    required int page,
    required int limit,
  }) async {
    final response = await ApiService.get(
      ApiConfig.applicationList,
      token: token,
      queryParameters: {"page": page, "length": limit},
    );

    final parsed = ApplicationResponse.fromJson(response);

    // DEBUG PRINTS
    print(parsed);
    print("------ PAGINATION DEBUG ------");
    print("Requested Page: $page");
    print("Response Page: ${parsed.pagination.page}");
    print("Limit: ${parsed.pagination.limit}");
    print("Total Records: ${parsed.pagination.total}");
    print("Total Pages: ${parsed.pagination.totalPages}");
    print("Returned Records Count: ${parsed.data.length}");
    print("------------------------------");
    // for (var app in parsed.data) {
    //   print(
    //     "ID: ${app.id}, "
    //     "App No: ${app.applicationNo}, "
    //     "Owner: ${app.ownerName}",
    //   );
    // }

    print("====================================");

    return parsed;
  }

  // Future<ApplicationResponse> fetchApplications({
  //   required String token,
  //   required int page,
  //   required int limit,
  // }) async {
  //   final response = await ApiService.post(ApiConfig.applicationList, {
  //     "page": page,
  //     "length": limit, // MUST match PHP
  //   }, token: token);

  //   return ApplicationResponse.fromJson(response);
  // }
}
