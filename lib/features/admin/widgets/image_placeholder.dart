import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kmb_app/core/utils/document_helper.dart';

class DocumentImage extends StatefulWidget {
  final DocCategory category;
  final DocType type;
  final int id;
  final String? token;

  const DocumentImage({
    super.key,
    required this.category,
    required this.type,
    required this.id,
    this.token,
  });

  @override
  State<DocumentImage> createState() => _DocumentImageState();
}

class _DocumentImageState extends State<DocumentImage> {
  Uint8List? _bytes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final bytes = await DocumentHelper.fetchBytes(
        category: widget.category,
        type: widget.type,
        id: widget.id,
        token: widget.token,
      );

      // debugPrint('STATUS: ${res.statusCode}');
      // debugPrint('CONTENT-TYPE: ${res.headers['content-type']}');
      // debugPrint('BODY LENGTH: ${res.bodyBytes.length}');
      // debugPrint(res.body);

      // final bytes = DocumentDecoder.decode(res.body);

      if (mounted) {
        setState(() {
          _bytes = bytes;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("IMAGE ERROR: $e");
      if (mounted) {
        setState(() {
          _loading = false;
          _bytes = null;
        });
      }
    }
  }

  Widget _noPhoto() {
    return const SizedBox(
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 40),
          SizedBox(height: 8),
          Text('No available'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 100,
        width: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_bytes == null) {
      return _noPhoto();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(_bytes!, height: 100, width: 100, fit: BoxFit.cover),
    );
  }
}
