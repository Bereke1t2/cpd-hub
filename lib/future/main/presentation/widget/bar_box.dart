import 'package:flutter/material.dart';

import '../../../../core/ui_constants.dart';

class BarBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  const BarBox({super.key, required this.text, required this.isSelected });

  @override
  Widget build(BuildContext context) {
    return TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? UiConstants.primaryButtonColor : UiConstants.infoBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.87),
                ),
              ),
            );
  }
}