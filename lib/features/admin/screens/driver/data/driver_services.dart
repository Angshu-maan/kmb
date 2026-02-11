import 'package:kmb_app/config/api_config.dart';
import 'package:kmb_app/core/network/api_client.dart';
// import 'package:kmb_app/core/network/test_client.dart';
import 'package:kmb_app/features/admin/screens/driver/data/driver_response.dart';

class DriverServices {
  Future<DriverResponse> fetchDrivers({String? token}) async {
    final response = await ApiService.get(ApiConfig.driverList, token: token);

    print('driver.........$response');
    // final response = await ApiTestService.post(   "drivers/list", token: token);

    return DriverResponse.fromJson(response);
  }
}
