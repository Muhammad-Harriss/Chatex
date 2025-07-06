import 'dart:ui';
import 'package:chat_app/Widgets/custom_list_view_tile.dart';
import 'package:chat_app/Widgets/top_bar.dart';
import 'package:chat_app/models/Chat_message_model.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/chats_user.dart';
import 'package:chat_app/pages/screens/Chat_Screen.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:chat_app/providers/chats_provider.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    if (!_auth.isUserReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF5288FF))),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        final provider = context.watch<ChatsPageProvider>();

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1F1C2C),
                  Color.fromARGB(255, 47, 43, 66),
                  Color(0xFF928DAB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: _deviceWidth,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: _deviceWidth * 0.04,
                        vertical: _deviceHeight * 0.02,
                      ),
                      child: LayoutBuilder(
                         builder: (context, constraints){
                          return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopBar(
                              barTitle: 'Chats',
                              fontSize: 24,
                              primaryAction: IconButton(
                                icon: const Icon(Icons.logout),
                                color: const Color(0xFF5288FF),
                                onPressed: () => _auth.logout(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _tabRow(),
                            const SizedBox(height: 10),
                            _chatsList(provider),
                          ],
                        );
                         }
                        
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tabRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTab('All Chats', true),
        _buildTab('Groups', false),
        _buildTab('Contacts', false),
      ],
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF5288FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _chatsList(ChatsPageProvider provider) {
    final List<Chat>? chats = provider.chats;

    return Expanded(
      child: chats == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF5288FF)))
          : chats.isEmpty
              ? const Center(
                  child: Text("No Chats Found.", style: TextStyle(color: Colors.white70)),
                )
              : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) => _chatTile(chats[index]),
                ),
    );
  }

  Widget _chatTile(Chat chat) {
    List<ChatsUser> recipients = chat.recepients();
    bool isActive = recipients.any((u) => u.wasRecentlyActive());
    String subtitle = chat.messages.isNotEmpty
        ? (chat.messages.first.type != MessageType.TEXT
            ? "Media Attachment"
            : chat.messages.first.content)
        : "";

    return CustomListViewTileWithActivity(
      height: _deviceHeight * 0.10,
      title: chat.title(),
      subtitle: subtitle,
      imagePath: chat.imageURL(),
      isActive: isActive,
      isActivity: chat.activity,
      onTap: () => _navigation.navigateToPage(ChatPage(chat: chat)),
    );
  }
}
