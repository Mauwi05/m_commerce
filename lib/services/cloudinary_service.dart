import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String _cloudName = 'wi5mei7f';
  static const String _uploadPreset = 'm_commerce_uploads';

  Uri get _uploadUri =>
      Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');

  /// Sube una imagen seleccionada desde galería/cámara (Web y Móvil)
  Future<String> uploadXFile(XFile file, {required String category}) async {
    final bytes = await file.readAsBytes();
    return uploadBytes(
      bytes,
      category: category,
      fileName: file.name,
    );
  }

  /// Sube bytes directos (útil también para capturas del Custom Lab)
  Future<String> uploadBytes(
    Uint8List bytes, {
    required String category,
    String fileName = 'product_image.png',
  }) async {
    final request = http.MultipartRequest('POST', _uploadUri)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['folder'] = 'm_commerce/${category.toLowerCase()}'
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['secure_url'] as String;
    } else {
      throw Exception(
        'Error al subir imagen a Cloudinary (${response.statusCode}): ${response.body}',
      );
    }
  }
}
