import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';

import '../../../../core/ui_constants.dart';

class NormalButtons extends StatelessWidget {
  final String title;
  final double fontSize;
  final VoidCallback onPressed;
  const NormalButtons({super.key, required this.title, required this.onPressed , this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 180 * sc,
        margin: EdgeInsets.only(top: 16.0 * sc),
        padding: EdgeInsets.symmetric(vertical: 8.0 * sc, horizontal: 16.0 * sc),
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
              fontSize: fontSize * sc,
            ),
          ),
        ),
      ),
    );
  }
}
