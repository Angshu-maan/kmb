import 'package:kmb_app/config/api_config.dart';
import 'package:kmb_app/core/network/api_client.dart';
// import 'package:kmb_app/core/network/test_client.dart';
import 'package:kmb_app/features/admin/screens/vehicle/data/vehicle_response.dart';

class VehicleServices {
  Future<VehicleResponse> fetchVehicle({String? token}) async {
    final response = await ApiService.get(
      ApiConfig.vehicleList,
      token: token,
      queryParameters: {},
    );
    // final response = await ApiTestService.post(   "drivers/list", token: token);

    return VehicleResponse.fromJson(response);
  }
}
