import 'package:chat_app/Widgets/Rounded_Button.dart';
import 'package:chat_app/pages/screens/Home_Screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  final String VerificationId;

  const VerifyPhoneNumberScreen({super.key, required this.VerificationId});

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final _codeController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.05,
          vertical: _deviceHeight * 0.1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _codeInputField(),
            SizedBox(height: _deviceHeight * 0.05),
            _verifyButton(),
          ],
        ),
      ),
    );
  }

  Widget _codeInputField() {
    return TextFormField(
      controller: _codeController,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Enter 6-digit code',
        hintStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _verifyButton() {
    return RoundedButton(
      name: 'Verify',
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.9,
      onPressed: () async {
        try {
          final credential = PhoneAuthProvider.credential(
            verificationId: widget.VerificationId,
            smsCode: _codeController.text.trim(),
          );

          // Sign in with credential
          await _auth.signInWithCredential(credential);

          final currentUser = _auth.currentUser;
          if (currentUser == null) throw Exception("User not found");

       

          

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Phone number verified!")),
          );

          // Navigate to ChatScreen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                
              ),
            ),
            (route) => false,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Invalid code. Try again.")),
          );
        }
      },
    );
  }
}
