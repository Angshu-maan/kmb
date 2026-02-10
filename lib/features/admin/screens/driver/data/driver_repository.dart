import '../model/driver_model.dart';
import 'driver_services.dart';
import 'package:kmb_app/core/auth/auth_session_helper.dart';

class DriverRepository {
  final DriverServices _service = DriverServices();

  Future<List<DriverModel>> getDrivers() async {
    try {
      final token = await AuthSessionHelper.getAuthToken();
        // print('JWT Driver TOKEN => $token');
      final response = await _service.fetchDrivers(token: token);


      // print('driver.........${response.data}');
    
      return response.data
          .map<DriverModel>((e) => DriverModel.fromJson(e))
          .toList();
    } catch (e) {
      print('DriverRepository error: $e');
      return [];
    }
  }
}


