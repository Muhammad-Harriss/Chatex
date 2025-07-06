// Packages
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/chats_user.dart';
import 'package:chat_app/pages/screens/chat_screen.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class UsersPageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;

  late DatabaseService _database;
  late NavigationService _navigation;

  List<ChatsUser>? users;
  late List<ChatsUser> _selectedUsers;

  List<ChatsUser> get selectedUsers => _selectedUsers;

  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _database.getUsers(name: name).then((_snapshot) {
        users = _snapshot.docs.map((_doc) {
          Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
          _data["uid"] = _doc.id;
          return ChatsUser.fromJSON(_data);
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      print("Error getting users.");
      print(e);
    }
  }

  void updateSelectedUsers(ChatsUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> _membersIds =
          _selectedUsers.map((_user) => _user.uid).toList();
      _membersIds.add(_auth.user.uid);
      bool _isGroup = _selectedUsers.length > 1;

      DocumentReference? _doc = await _database.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _membersIds,
      });

      List<ChatsUser> _members = [];
      for (var uid in _membersIds) {
        DocumentSnapshot userSnapshot = await _database.getUser(uid);
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        userData["uid"] = userSnapshot.id;
        _members.add(ChatsUser.fromJSON(userData));
      }

      ChatPage chatPage = ChatPage(
        chat: Chat(
          uid: _doc!.id,
          currentUserUid: _auth.user.uid,
          members: _members,
          messages: [],
          activity: false,
          group: _isGroup,
        ),
      );

      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(chatPage);
    } catch (e) {
      print("Error creating chat.");
      print(e);
    }
  }
}
