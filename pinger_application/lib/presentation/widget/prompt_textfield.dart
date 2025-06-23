import 'package:flutter/material.dart';

class PromptTextField extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final String prompt;
  final bool isPromptEmpty;
  final ValueChanged<String> onChanged;

  const PromptTextField({
    super.key,
    required this.controller,
    required this.prompt,
    required this.isPromptEmpty,
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
          labelText: prompt,
          hintText: "Enter your prompt",
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 1,
              color: isPromptEmpty ? Colors.redAccent : Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 1,
              color: isPromptEmpty ? Colors.redAccent : Colors.grey,
            ),
          ),
          errorText: isPromptEmpty ? 'prompt is empty' : null,
        ),
        onChanged: onChanged,
      ),
    );
  } // build

  @override
  Size get preferredSize => const Size.fromHeight(80);
} // PromptTextField
