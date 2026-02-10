import '../model/owner_model.dart';
import '../data/owner_services.dart';
import 'package:kmb_app/core/auth/auth_session_helper.dart';

class OwnerRepository {
  final OwnerService _service = OwnerService();

  Future<List<OwnerModel>> getOwners() async {
    try {
      final token = await AuthSessionHelper.getAuthToken();
      // print('JWT Owner TOKEN => $token');
      final response = await _service.fetchOwners(token: token);
      print('${response.data}');

      return response.data
          .map<OwnerModel>((e) => OwnerModel.fromJson(e))
          .toList();
    } catch (e) {
      print('OwnerRepository error: $e');
      return [];
    }
  }
}
