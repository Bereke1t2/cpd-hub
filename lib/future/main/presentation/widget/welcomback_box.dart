import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';

import '../../../../core/ui_constants.dart';

class WelcomeBackBox extends StatelessWidget {
  final String name;

  const WelcomeBackBox({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16 * sc, 10 * sc, 16 * sc, 16 * sc),
      padding: EdgeInsets.all(16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${name.split(' ').first}!',
                      style: TextStyle(
                        color: UiConstants.mainTextColor,
                        fontSize: 20 * sc,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 5 * sc),
                    Text(
                      "Ready to crush some code today?",
                      style: TextStyle(
                        color: UiConstants.subtitleTextColor.withValues(alpha: 0.6),
                        fontSize: 13 * sc,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10 * sc),
                decoration: BoxDecoration(
                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.rocket_launch_rounded, color: UiConstants.primaryButtonColor, size: 22 * sc),
              ),
            ],
          ),
          SizedBox(height: 14 * sc),
          SizedBox(
            width: double.infinity,
            height: 42 * sc,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/problems'),
              style: ElevatedButton.styleFrom(
                backgroundColor: UiConstants.primaryButtonColor,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 12 * sc, letterSpacing: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("START SOLVING"),
                  SizedBox(width: 8 * sc),
                  Icon(Icons.arrow_forward_rounded, size: 14 * sc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
