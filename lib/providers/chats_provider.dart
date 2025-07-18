import 'dart:async';

// Packages
import 'package:chat_app/models/Chat_message_model.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/chats_user.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Services
import '../services/database_service.dart';

class ChatsPageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;
  late final DatabaseService _db;
  List<Chat>? chats;
  StreamSubscription? _chatsStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    _initialize();
  }

  void _initialize() async {
    // Wait for user to be initialized properly
    while (!_auth.isUserReady) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    getChats();
  }

  @override
  void dispose() {
    _chatsStream?.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatsStream = _db.getChatsForUser(_auth.user.uid).listen((_snapshot) async {
        chats = await Future.wait(
          _snapshot.docs.map((_d) async {
            Map<String, dynamic> _chatData = _d.data() as Map<String, dynamic>;

            // Get Users In Chat
            List<ChatsUser> _members = [];
            for (var _uid in _chatData["members"]) {
              DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
              Map<String, dynamic> _userData =
                  _userSnapshot.data() as Map<String, dynamic>;
              _userData["uid"] = _userSnapshot.id;
              _members.add(ChatsUser.fromJSON(_userData));
            }

            // Get Last Message For Chat
            List<ChatMessage> _messages = [];
            QuerySnapshot _chatMessage = await _db.getLastMessageForChat(_d.id);
            if (_chatMessage.docs.isNotEmpty) {
              Map<String, dynamic> _messageData =
                  _chatMessage.docs.first.data() as Map<String, dynamic>;
              _messages.add(ChatMessage.fromJSON(_messageData));
            }

            return Chat(
              uid: _d.id,
              currentUserUid: _auth.user.uid,
              members: _members,
              messages: _messages,
              activity: _chatData["is_activity"],
              group: _chatData["is_group"],
            );
          }).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print("❌ Error getting chats.");
      print(e);
    }
  }
}
