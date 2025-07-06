import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ImageUploadService {
  static Future<String?> uploadToImgBB(PlatformFile imageFile, String apiKey) async {
    try {
      Uint8List? bytes = imageFile.bytes;

      if (bytes == null) return null;

      String base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey"),
        body: {
          "image": base64Image,
          "name": imageFile.name,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"]["url"]; // Direct link to the image
      } else {
        print("ImgBB Upload Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("ImgBB Upload Error: $e");
      return null;
    }
  }
}
