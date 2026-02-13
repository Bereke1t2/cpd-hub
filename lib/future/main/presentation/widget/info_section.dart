import 'package:flutter/material.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/widget/profil_section.dart';

class InfoSection extends StatelessWidget {
  final int division;
  final String rating;
  final String rank;
  final int solvedProblems;
  
  const InfoSection({
    super.key, 
    required this.division, 
    required this.rating, 
    required this.rank, 
    required this.solvedProblems
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileSection(
                title: 'User Rating',
                subtitle: rating,
                icon: Icons.trending_up_rounded,
                color: UiConstants.ratingTextColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileSection(
                title: 'Global Rank',
                subtitle: '#$rank',
                icon: Icons.emoji_events_rounded,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ProfileSection(
                title: 'Division',
                subtitle: 'Div $division',
                icon: Icons.workspace_premium_rounded,
                color: UiConstants.primaryButtonColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileSection(
                title: 'Solved',
                subtitle: '$solvedProblems',
                icon: Icons.task_alt_rounded,
                color: UiConstants.problemTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}