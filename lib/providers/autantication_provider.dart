import 'package:chat_app/models/chats_user.dart';
import 'package:chat_app/services/cloud_storage_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;
  late final CloudStorageService _cloudStorageService;

  late ChatsUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();

    _auth.authStateChanges().listen((_user) async {
      if (_user != null) {
        final userSnapshot = await _databaseService.getUser(_user.uid);

        if (!userSnapshot.exists) {
          // First time registration fallback
          await _databaseService.createUser(
            _user.uid,
            _user.email ?? '',
            _user.displayName ?? '',
            _user.photoURL ?? '',
          );
        }

        await _databaseService.updateUserLastSeenTime(_user.uid);

        final updatedSnapshot = await _databaseService.getUser(_user.uid);
        // ignore: unnecessary_cast
        final userData = updatedSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          user = ChatsUser.fromJSON({
            'uid': _user.uid,
            'name': userData['name'],
            'email': userData['email'],
            'lastActive': userData['last_active'],
            'imageUrl': userData['image'],
          });

          print("✅ User loaded: ${user.email}");
          _navigationService.removeAndNavigateToRoute('/home');
        } else {
          print("⚠️ User data is null even after creation.");
          _navigationService.removeAndNavigateToRoute('/login');
        }
      } else {
        print('🚪 User not authenticated, navigating to /login');
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<String?> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException during login: ${e.message}");
      return e.message;
    } catch (e) {
      print("❌ Unknown error during login: $e");
      return "An unknown error occurred.";
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
    String name,
    String email,
    String password,
    PlatformFile? profileImage,
  ) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email.toString(),
        password: password.toString(),
      );

      final user = credentials.user;
      if (user != null) {
        String imageUrl = '';
        if (profileImage != null) {
          imageUrl = await _cloudStorageService
                  .saveUserImageToStorage(user.uid, profileImage) ??
              '';
        }

        await user.updateDisplayName(name);

        await _databaseService.createUser(user.uid, email, name, imageUrl);

        return user.uid;
      } else {
        return "User registration failed.";
      }
    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException during registration: ${e.message}");
      return e.message;
    } catch (e) {
      print("❌ Unknown error during registration: $e");
      return "An unknown error occurred.";
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      print("👋 User signed out successfully.");
    } catch (e) {
      print("❌ Logout error: $e");
    }
  }
}
