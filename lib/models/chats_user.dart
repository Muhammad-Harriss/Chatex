import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsUser {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final DateTime lastActive;

  ChatsUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastActive,
  });

  factory ChatsUser.fromJSON(Map<String, dynamic> json) {
    return ChatsUser(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      lastActive: (json['lastActive'] != null && json['lastActive'] is Timestamp)
          ? (json['lastActive'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'lastActive': lastActive,
      'imageUrl': imageUrl,
    };
  }

  String lastDayActive() {
    return '${lastActive.month}/${lastActive.day}/${lastActive.year}';
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
