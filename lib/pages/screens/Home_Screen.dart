
import 'package:chat_app/pages/screens/chats_screen.dart';
import 'package:chat_app/pages/screens/user_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currenPage = 0;
  final List<Widget> _pages = [
    ChatsScreen(),
    UserScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currenPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currenPage,
        onTap: (_index) {
          setState(() {
            _currenPage = _index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(Icons.bubble_chart_sharp),
          ),
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(Icons.supervised_user_circle_sharp),
          ),
        ],
      ),
    );
  }
}
