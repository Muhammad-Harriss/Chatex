import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();

  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      final ref = _storage
          .ref()
          .child('images/users/$uid/profile.${file.extension ?? 'jpg'}');

      final uploadTask = ref.putFile(File(file.path!));
      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("❌ Error uploading user image: $e");
      return null;
    }
  }

  Future<String?> saveChatImageToStorage(
      String chatID, String userID, PlatformFile file) async {
    try {
      final timestamp = Timestamp.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child(
          'images/chats/$chatID/${userID}_$timestamp.${file.extension ?? 'jpg'}');

      final uploadTask = ref.putFile(File(file.path!));
      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("❌ Error uploading chat image: $e");
      return null;
    }
  }
}
