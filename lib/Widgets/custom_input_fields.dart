import 'package:flutter/material.dart';

class CustomInputFields extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obsecureText;
  final IconData? icon;

  const CustomInputFields({
    super.key,
    required this.onSaved,
    required this.regEx,
    required this.hintText,
    required this.obsecureText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (_value) => onSaved(_value!),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obsecureText,
      validator: (_value) {
        return RegExp(regEx).hasMatch(_value!)
            ? null
            : 'Enter a valid value';
      },
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 0.8),
        filled: true,
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.white70)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.white54),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }
}
