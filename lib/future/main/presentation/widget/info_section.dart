import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/presentation/widget/profil_section.dart';

class InfoSection extends StatelessWidget {
  final int division;
  final String rating;
  final String rank;
  final int solvedProblems;
  const InfoSection({super.key, required this.division, required this.rating, required this.rank, required this.solvedProblems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileSection(title: 'User Rating', subtitle: rating, icon: Icons.trending_up),
              SizedBox(height: 16),
              ProfileSection(title: 'Division', subtitle: 'Div $division', icon: Icons.star),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileSection(title: 'Rank', subtitle: rank, icon: Icons.emoji_events),
              SizedBox(height: 16),
              ProfileSection(title: 'Solved Problems', subtitle: '$solvedProblems', icon: Icons.check_circle),
            ],
          ),
        ],
      ),
    );
  }
}