// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:chat_app/pages/screens/Home_Screen.dart';
import 'package:chat_app/pages/screens/login_screen.dart';

import 'package:chat_app/services/cloud_storage_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _initializeApp();
  }

  void _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.repeat(reverse: true);
  }

  Future<void> _initializeApp() async {
    _registerServices();

    await Future.delayed(const Duration(seconds: 10));

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (!mounted) return;

      if (user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
       

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(
            
            ),
          ),
        );
      }
    });
  }

  void _registerServices() {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<NavigationService>()) {
      getIt.registerSingleton(NavigationService());
    }
    if (!getIt.isRegistered<MediaService>()) {
      getIt.registerSingleton(MediaService());
    }
    if (!getIt.isRegistered<CloudStorageService>()) {
      getIt.registerSingleton(CloudStorageService());
    }
    if (!getIt.isRegistered<DatabaseService>()) {
      getIt.registerSingleton(DatabaseService());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 180,
                          width: 180,
                          child: Image.asset(
                            'assets/images/logo1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            Text(
                              "Chatex",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Chit. Chat. Chill",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
