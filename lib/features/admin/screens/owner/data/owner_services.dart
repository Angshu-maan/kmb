import 'package:kmb_app/config/api_config.dart';
import 'package:kmb_app/core/network/api_client.dart';
// import 'package:kmb_app/core/network/test_client.dart';

import 'owner_response.dart';

class OwnerService {
  Future<OwnerResponse> fetchOwners({String? token}) async {
    final response = await ApiService.get(
      ApiConfig.ownerList,

      token: token,
    );

    return OwnerResponse.fromJson(response);
  }
}