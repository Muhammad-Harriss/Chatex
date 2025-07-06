import 'dart:ui';

import 'package:chat_app/Widgets/Rounded_Button.dart';
import 'package:chat_app/Widgets/custom_input_fields.dart';
import 'package:chat_app/Widgets/custom_list_view_tile.dart';
import 'package:chat_app/Widgets/top_bar.dart';
import 'package:chat_app/models/chats_user.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _pageProvider = context.watch<UsersPageProvider>();

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
                padding: const EdgeInsets.all(16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopBar(
                            barTitle: 'Users',
                            fontSize: 24,
                            primaryAction: IconButton(
                              icon: const Icon(Icons.logout),
                              color: const Color(0xFF5288FF),
                              onPressed: () => _auth.logout(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _searchController,
                            hintText: "Search users...",
                            obscureText: false,
                            icon: Icons.search,
                            onEditingComplete: (value) {
                              _pageProvider.getUsers(name: value);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 10),
                          _usersList(),
                          const SizedBox(height: 10),
                          _createChatButton(),
                        ],
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

  Widget _usersList() {
    List<ChatsUser>? users = _pageProvider.users;

    return Expanded(
      child: users == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5288FF)),
            )
          : users.isEmpty
              ? const Center(
                  child: Text("No Users Found.", style: TextStyle(color: Colors.white70)),
                )
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: CustomListViewTile(
                        height: _deviceHeight * 0.10,
                        title: user.name,
                        subtitle: "Last Active: ${user.lastDayActive()}",
                        imagePath: user.imageUrl,
                        isActive: user.wasRecentlyActive(),
                        isSelected: _pageProvider.selectedUsers.contains(user),
                        onTap: () => _pageProvider.updateSelectedUsers(user),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _pageProvider.selectedUsers.length == 1
            ? "Chat with ${_pageProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.8,
        onPressed: () => _pageProvider.createChat(),
      ),
    );
  }
}
