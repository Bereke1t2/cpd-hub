import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class SearchBox extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  const SearchBox({super.key, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: UiConstants.mainTextColor),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}