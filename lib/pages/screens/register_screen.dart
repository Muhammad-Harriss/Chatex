// ignore_for_file: unused_field

import 'dart:ui';
import 'package:chat_app/Widgets/Rounded_Button.dart';
import 'package:chat_app/Widgets/Rounded_Image_Network.dart';
import 'package:chat_app/Widgets/custom_input_fields.dart';
import 'package:chat_app/providers/autantication_provider.dart';
import 'package:chat_app/services/cloud_storage_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;
  late NavigationService _navigation;

  String? _email;
  String? _password;
  String? _name;
  PlatformFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: _deviceWidth,
        height: _deviceHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1C2C),Color.fromARGB(255, 51, 47, 70), Color(0xFF928DAB)],
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
                        "Welcome\n Regster Now",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _profileImageField(),
                      const SizedBox(height: 25),
                      _registerForm(),
                      const SizedBox(height: 25),
                      _registerButton(),
                      const SizedBox(height: 20),
                      _AlreadyHaveAccount(),
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

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () async {
        PlatformFile? selectedFile =
            await GetIt.instance.get<MediaService>().pickImageFromLibrary();
        if (selectedFile != null) {
          setState(() => _profileImage = selectedFile);
        }
      },
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            _profileImage != null
                ? RoundedImageFile(
                    key: UniqueKey(),
                    image: _profileImage!,
                    size: _deviceHeight * 0.15,
                  )
                : RoundedImageNetwork(
                    key: UniqueKey(),
                    imagePath: "https://i.pravatar.cc/150?img=65",
                    size: _deviceHeight * 0.15,
                  ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          CustomInputFields(
            onSaved: (_value) => _name = _value.trim(),
            regEx: r'.{3,}',
            hintText: "Name",
            obsecureText: false,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 15),
          CustomInputFields(
            onSaved: (_value) => _email = _value.trim(),
            regEx: r"^[a-zA-Z0-9.a-zA-Z0-9.!#\\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
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

  Widget _registerButton() {
    return RoundedButton(
      name: "Register",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate()) {
          _registerFormKey.currentState!.save();

          if (_profileImage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a profile image.')),
            );
            return;
          }

          try {
            String? uid = await _auth.registerUserUsingEmailAndPassword(
              _name!,
              _email!,
              _password!,
              _profileImage,
            );

            if (uid != null) {
              _navigation.navigateToRoute('/home');
            } else {
              throw Exception("Failed to register user.");
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: \${e.toString()}")),
            );
          }
        }
      },
    );
  }

  Widget _AlreadyHaveAccount() {
    return GestureDetector(
      onTap: () {
        _navigation.navigateToRoute('/login');
      },
      child: Text(
        "Already have an account? Sign In",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
