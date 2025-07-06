import 'dart:async';

//Packages
import 'package:chat_app/models/Chat_message_model.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

class ChatPageProvider extends ChangeNotifier {
  late final DatabaseService _db;
  late final CloudStorageService _storage;
  late final MediaService _media;
  late final NavigationService _navigation;

  final AuthenticationProvider _auth;
  final ScrollController _messagesListViewController;
  final String _chatId;

  List<ChatMessage>? messages;

  late final StreamSubscription _messagesStream;
  late final StreamSubscription _keyboardVisibilityStream;
  late final KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String? get message => _message;

  set message(String? value) {
    _message = value;
    notifyListeners();
  }

  ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    _keyboardVisibilityStream.cancel(); // ✅ Fixes the warning
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(_chatId).listen((snapshot) {
        final loadedMessages = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ChatMessage.fromJSON(data);
        }).toList();

        messages = loadedMessages;
        notifyListeners();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messagesListViewController.hasClients) {
            _messagesListViewController.jumpTo(
              _messagesListViewController.position.maxScrollExtent,
            );
          }
        });
      });
    } catch (e) {
      print("❌ Error getting messages: $e");
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen((visible) {
      _db.updateChatData(_chatId, {"is_activity": visible});
    });
  }

  void sendTextMessage() {
    if (_message != null && _message!.trim().isNotEmpty) {
      final messageToSend = ChatMessage(
        content: _message!.trim(),
        type: MessageType.TEXT,
        senderID: _auth.user.uid,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatId, messageToSend);
      _message = null;
      notifyListeners();
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await _media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL = await _storage.saveChatImageToStorage(
          _chatId,
          _auth.user.uid,
          file,
        );
        if (downloadURL != null) {
          final messageToSend = ChatMessage(
            content: downloadURL,
            type: MessageType.IMAGE,
            senderID: _auth.user.uid,
            sentTime: DateTime.now(),
          );
          _db.addMessageToChat(_chatId, messageToSend);
        }
      }
    } catch (e) {
      print("❌ Error sending image message: $e");
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
