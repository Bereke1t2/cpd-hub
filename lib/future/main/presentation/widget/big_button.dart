import 'package:flutter/material.dart';

import '../../../../core/ui_constants.dart';

class BigButton extends StatelessWidget {
  final String title;
  final double fontSize;
  final VoidCallback onPressed;
  const BigButton({super.key, required this.title, required this.onPressed , this.fontSize = 20.0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: UiConstants.primaryButtonColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: UiConstants.mainTextColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
