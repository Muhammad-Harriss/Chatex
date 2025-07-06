import 'dart:ui';

import 'package:chat_app/pages/screens/chats_screen.dart';
import 'package:chat_app/pages/screens/user_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    ChatsScreen(),
    UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      extendBody: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: _pages[_currentPage],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.white70,
                currentIndex: _currentPage,
                onTap: (_index) {
                  setState(() {
                    _currentPage = _index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.supervised_user_circle),
                    label: 'Users',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
