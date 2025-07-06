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
      onSaved: (value) {
        if (value != null) onSaved(value);
      },
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obsecureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return RegExp(regEx).hasMatch(value) ? null : 'Enter a valid value';
      },
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 0.8),
        filled: true,
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.white54),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.onEditingComplete,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.text),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white54) : null,
      ),
    );
  }
}
