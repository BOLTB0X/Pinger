import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final String inputString;
  final String hintText;
  final String errorText;
  final bool isInputEmpty;
  final ValueChanged<String> onChanged;

  const InputTextField({
    super.key,
    required this.controller,
    required this.inputString,
    required this.hintText,
    required this.errorText,
    required this.isInputEmpty,
    required this.onChanged,
  }); // PromptTextField

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: inputString,
          hintText: hintText,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 1,
              color: isInputEmpty ? Colors.redAccent : Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 1,
              color: isInputEmpty ? Colors.redAccent : Colors.grey,
            ),
          ),
          errorText: isInputEmpty ? errorText : null,
        ),
        onChanged: onChanged,
      ),
    );
  } // build

  @override
  Size get preferredSize => const Size.fromHeight(80);
} // PromptTextField
