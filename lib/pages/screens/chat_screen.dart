// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:chat_app/Widgets/custom_input_fields.dart';
import 'package:chat_app/Widgets/custom_list_view_tile.dart';
import 'package:chat_app/Widgets/top_bar.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ScrollController _messagesListViewController;
  final GlobalKey<FormState> _messageFormState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);

    if (!_auth.isUserReady) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF0052DA))),
      );
    }

    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider<ChatPageProvider>(
      create: (_) => ChatPageProvider(
        widget.chat.uid,
        _auth,
        _messagesListViewController,
      ),
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (context) {
      final pageProvider = context.watch<ChatPageProvider>();
      return Scaffold(
        backgroundColor: const Color(0xFF1F1C2C), // Matches your home background
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03,
              vertical: _deviceHeight * 0.02,
            ),
            height: _deviceHeight,
            width: _deviceWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopBar(
                  barTitle: 'Chat',
                  fontSize: 22,
                  primaryAction: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFF0052DA)),
                    onPressed: () => pageProvider.deleteChat(),
                  ),
                  secondaryAction: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0052DA)),
                    onPressed: () => pageProvider.goBack(),
                  ),
                ),
                const SizedBox(height: 10),
                _messagesListView(pageProvider),
                _sendMessageForm(pageProvider),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messagesListView(ChatPageProvider provider) {
    final messages = provider.messages;

    if (messages == null) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator(color: Color(0xFF0052DA))),
      );
    }

    if (messages.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            "Be the first to say Hi!",
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        controller: _messagesListViewController,
        itemCount: messages.length,
        itemBuilder: (_, index) {
          final message = messages[index];
          final isOwn = message.senderID == _auth.user.uid;
          final sender = widget.chat.members.firstWhere((m) => m.uid == message.senderID);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: CustomChatListViewTile(
              deviceHeight: _deviceHeight,
              width: _deviceWidth * 0.80,
              message: message,
              isOwnMessage: isOwn,
              sender: sender,
            ),
          );
        },
      ),
    );
  }

  Widget _sendMessageForm(ChatPageProvider provider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: _deviceHeight * 0.07,
          margin: EdgeInsets.only(top: _deviceHeight * 0.02),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Form(
            key: _messageFormState,
            child: Row(
              children: [
                Expanded(child: _messageTextField(provider)),
                _sendMessageButton(provider),
                const SizedBox(width: 6),
                _imageMessageButton(provider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _messageTextField(ChatPageProvider provider) {
    return CustomInputFields(
      onSaved: (value) => provider.message = value,
      regEx: r"^(?!\s*$).+",
      hintText: "Type a message",
      obsecureText: false,
    );
  }

  Widget _sendMessageButton(ChatPageProvider provider) {
    return IconButton(
      icon: const Icon(Icons.send, color: Color(0xFF5288FF)),
      onPressed: () {
        if (_messageFormState.currentState!.validate()) {
          _messageFormState.currentState!.save();
          provider.sendTextMessage();
          _messageFormState.currentState!.reset();
        }
      },
    );
  }

  Widget _imageMessageButton(ChatPageProvider provider) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFF5288FF),
      child: IconButton(
        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
        onPressed: provider.sendImageMessage,
      ),
    );
  }
}
