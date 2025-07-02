import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:chat_app/Widgets/Rounded_Button.dart';
import 'package:chat_app/Widgets/custom_input_fields.dart';
import 'package:chat_app/pages/screens/loginWithPhoneNum_screen.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:chat_app/services/navigation_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthenticationProvider _auth;
  late NavigationService _navigation;

  final _loginFormKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return Scaffold(
      body: Container(
        width: _deviceWidth,
        height: _deviceHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1C2C),Color.fromARGB(255, 47, 43, 66), Color(0xFF928DAB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.06),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset(
                            'assets/images/logo1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      
                      Text(
                        "Welcome Back\n Login Now",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _loginForm(),
                      const SizedBox(height: 25),
                      _loginButton(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: _googleSignInButton()),
                          const SizedBox(width: 12),
                          Expanded(child: _loginWithPhoneNumber()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _registerAccountLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          CustomInputFields(
            onSaved: (_value) => _email = _value,
            regEx:  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
            hintText: "Email",
            obsecureText: false,
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 15),
          CustomInputFields(
            onSaved: (_value) => _password = _value,
            regEx: r".{8,}",
            hintText: "Password",
            obsecureText: true,
            icon: Icons.lock_outline,
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
  return RoundedButton(
    name: 'Login',
    height: _deviceHeight * 0.06,
    width: _deviceWidth * 0.8,
    onPressed: () async {
      if (_loginFormKey.currentState!.validate()) {
        _loginFormKey.currentState!.save();

        final error = await _auth.loginUsingEmailAndPassword(_email!, _password!);

        if (error == null) {
          // Login success; navigation will be handled automatically by authStateChanges
          // You may choose to show a loading indicator or do nothing here.
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      }
    },
  );
}


  Widget _googleSignInButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.g_mobiledata, color: Colors.white),
      label: const Text('Google', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(_deviceWidth * 0.38, _deviceHeight * 0.06),
      ),
      onPressed: () async {
        try {
          final GoogleSignIn googleSignIn = GoogleSignIn();
          final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
          if (googleUser == null) return;

          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await FirebaseAuth.instance.signInWithCredential(credential);

          if (mounted) {
            _navigation.navigateToRoute('/home');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Google Sign-In failed: \$e')),
          );
        }
      },
    );
  }

  Widget _loginWithPhoneNumber() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.phone_android, color: Colors.white),
      label: const Text('Phone', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(_deviceWidth * 0.38, _deviceHeight * 0.06),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginwithphonenumScreen()),
        );
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => _navigation.navigateToRoute('/register'),
      child: Text(
        "Don't have an account?\n Register Now",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16 , fontWeight: FontWeight.w500),
      ),
    );
  }
}
