import 'package:flutter/material.dart';

import '../../../../core/ui_constants.dart';
import 'big_button.dart';

class WelcomeBackBox extends StatelessWidget {
  final String name;

  const WelcomeBackBox({super.key , required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 12,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome Back, ${name.split(' ').first}!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: UiConstants.mainTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Ready to solve today's problems?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: UiConstants.subtitleTextColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.handyman_rounded, color: Colors.green , size: 45,),
            ],
          ),
          BigButton(title: "Problems" , onPressed: () {
            Navigator.pushNamed(context, '/problems');
          }),
        ],
      ),
    );
  }
}