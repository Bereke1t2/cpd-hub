import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_card.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/primary_button.dart';

class WelcomeBackBox extends StatelessWidget {
  final String name;

  const WelcomeBackBox({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final firstName = name.split(' ').first;
    return Padding(
      padding: const EdgeInsets.all(AppDimens.md),
      child: AppCard(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.hero(
                        firstName.isEmpty
                            ? 'Welcome Back!'
                            : 'Welcome Back, $firstName!',
                      ),
                      const SizedBox(height: AppDimens.xs),
                      AppText.body(
                        "Ready to solve today's problems?",
                        color: UiConstants.subtitleTextColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.md),
                const Icon(Icons.handyman_rounded,
                    color: UiConstants.primaryButtonColor,
                    size: AppDimens.iconLg + 8),
              ],
            ),
            const SizedBox(height: AppDimens.md),
            PrimaryButton(
              title: 'Problems',
              onPressed: () => Navigator.pushNamed(context, '/problems'),
            ),
          ],
        ),
      ),
    );
  }
}
