import 'package:kmb_app/features/admin/screens/vehicle/data/vehicle_services.dart';

import 'package:kmb_app/core/auth/auth_session_helper.dart';
import 'package:kmb_app/features/admin/screens/vehicle/model/vehicle_model.dart';

class VehicleRepository {
  final VehicleServices _service = VehicleServices();

  Future<List<VehicleModel>> getVehicle() async {
    try {
      final token = await AuthSessionHelper.getAuthToken();
        // print('JWT Driver TOKEN => $token');
      final response = await _service.fetchVehicle(token: token);
      print('Status => ${response.data}');
    
      return response.data
          .map<VehicleModel>((e) => VehicleModel.fromJson(e))
          .toList();
    } catch (e) {
      print('DriverRepository error: $e');
      return [];
    }
  }
}


