// Opens the PDF in an external browser (url_launcher).
// Tapping "Mark complete" marks the lesson done.
import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfView extends StatelessWidget {
  final String url;
  final VoidCallback? onComplete;

  const PdfView({super.key, required this.url, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.picture_as_pdf_outlined,
                size: 40, color: UiConstants.primaryButtonColor),
          ),
          const SizedBox(height: AppDimens.lg),
          const Text(
            'PDF Document',
            style: TextStyle(
                color: UiConstants.mainTextColor,
                fontSize: AppDimens.fH2,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppDimens.sm),
          const Text(
            'Opens in your browser',
            style: TextStyle(
                color: UiConstants.subtitleTextColor,
                fontSize: AppDimens.fBody),
          ),
          const SizedBox(height: AppDimens.xl),
          PrimaryButton(
            title: 'Open PDF',
            icon: Icons.open_in_new,
            onPressed: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: AppDimens.md),
          PrimaryButton(
            title: 'Mark as complete',
            icon: Icons.check_circle_outline,
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.25),
            onPressed: onComplete,
          ),
        ],
      ),
    );
  }
}
