import 'dart:io' show File;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();

  // Upload user profile image (PlatformFile)
  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      final ref = _storage.ref().child('images/users/$uid/profile.${file.extension ?? 'jpg'}');
      final mimeType = _getMimeType(file.extension ?? 'jpg');

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(file.bytes!, SettableMetadata(contentType: mimeType));
      } else {
        uploadTask = ref.putFile(File(file.path!));
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("❌ Error uploading user image: $e");
      return null;
    }
  }

  // Upload chat image (PlatformFile)
  Future<String?> saveChatImageToStorage(String chatID, String userID, PlatformFile file) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = file.extension ?? 'jpg';
      final mimeType = _getMimeType(ext);

      final ref = _storage.ref().child(
        'images/chats/$chatID/${userID}_$timestamp.$ext',
      );

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(file.bytes!, SettableMetadata(contentType: mimeType));
      } else {
        uploadTask = ref.putFile(File(file.path!));
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("❌ Error uploading chat image: $e");
      return null;
    }
  }

  // Upload chat image using Uint8List (for memory-based upload)
  Future<String?> saveChatImageBytesToStorage(
    String chatID,
    String userID,
    Uint8List fileBytes,
    String fileName,
  ) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = fileName.split('.').last;
      final mimeType = _getMimeType(ext);

      final ref = _storage.ref().child(
        'images/chats/$chatID/${userID}_$timestamp.$ext',
      );

      final uploadTask = ref.putData(fileBytes, SettableMetadata(contentType: mimeType));
      final snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("❌ Error uploading chat image (bytes): $e");
      return null;
    }
  }

  /// MIME type helper based on extension
  String _getMimeType(String ext) {
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
