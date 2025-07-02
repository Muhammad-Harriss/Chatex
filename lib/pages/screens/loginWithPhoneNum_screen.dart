import 'package:chat_app/pages/screens/verify_PhoneNumber_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:chat_app/Widgets/Rounded_Button.dart';

class LoginwithphonenumScreen extends StatefulWidget {
  const LoginwithphonenumScreen({super.key});

  @override
  State<LoginwithphonenumScreen> createState() =>
      _LoginwithphonenumScreenState();
}

class _LoginwithphonenumScreenState extends State<LoginwithphonenumScreen> {
  final _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? _number;

  Country _selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Pakistan',
    example: '0301 2345678',
    displayName: 'Pakistan',
    displayNameNoCountryCode: 'Pakistan',
    e164Key: '',
  );

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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.05,
            vertical: _deviceHeight * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _phoneInputField(),
              SizedBox(height: _deviceHeight * 0.05),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _phoneInputField() {
    return TextFormField(
      controller: _phoneController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: '1234 5678901',
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: InkWell(
          onTap: _showCountryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_selectedCountry.flagEmoji} +${_selectedCountry.phoneCode}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        
      ),
      onSaved: (value) {
        _number = '+${_selectedCountry.phoneCode}${value?.trim()}';
      },
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 7) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() => _selectedCountry = country);
      },
    );
  }

  Widget _loginButton() {
    return RoundedButton(
      name: 'Login',
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.9,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          print("📱 Full Number: $_number");

          _auth.verifyPhoneNumber(
            phoneNumber: _number!,
            verificationCompleted: (_) {},
            verificationFailed: (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${e.message}")),
              );
            },
            codeSent: (String verificationID, int? token) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VerifyPhoneNumberScreen(VerificationId: verificationID),
                ),
              );
            },
            codeAutoRetrievalTimeout: (e) {},
          );
        }
      },
    );
  }
}
