
// ignore_for_file: deprecated_member_use

import 'package:chat_app/pages/screens/Home_Screen.dart';
import 'package:chat_app/pages/screens/login_screen.dart';
import 'package:chat_app/pages/screens/register_screen.dart';
import 'package:chat_app/pages/screens/splash_screen.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:chat_app/services/navigation_service.dart';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCZFREduCRjuakaHkWoYW4ckkOgO_OQfDM",
        authDomain: "chatapp-4fef7.firebaseapp.com",
        projectId: "chatapp-4fef7",
        storageBucket: "chatapp-4fef7.firebasestorage.app",
        messagingSenderId: "920359609590",
        appId: "1:920359609590:web:32593145585835f1c2b8d7",
        measurementId: "G-HT8DJM9G71",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

 

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        title: 'Chatex',
        theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
          scaffoldBackgroundColor: const Color.fromRGBO(35, 36, 49, 1.0),
        ),
        navigatorKey: NavigationService.navigatorkey,
        home: const SplashScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => RegisterPage(),
         '/home': (_) => HomeScreen(),
        },
      ),
    );
  }
}
