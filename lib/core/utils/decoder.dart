import 'dart:convert';
import 'dart:typed_data';

class DocumentDecoder {
  static Uint8List? decode(String responseBody) {
    final Map<String, dynamic> json = jsonDecode(responseBody);

    if (json['status'] != 'success') {
      return null;
    }

    final dynamic data = json['data'];

    String? base64String;

    if (data is String && data.isNotEmpty) {
      base64String = data;
    } else if (data is Map && data['content'] is String) {
      base64String = data['content'];
    }

    if (base64String == null || base64String.isEmpty) {
      return null;
    }

    return base64Decode(base64String);
  }
}
