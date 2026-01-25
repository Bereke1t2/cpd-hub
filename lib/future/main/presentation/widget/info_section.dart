import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/presentation/widget/profil_section.dart';

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
    required this.solvedProblems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 520;
          final itemWidth =
              isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

          Widget item(ProfileSection section) {
            return SizedBox(width: itemWidth, child: section);
          }

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              item(ProfileSection(
                title: 'User Rating',
                subtitle: rating,
                icon: Icons.trending_up,
              )),
              item(ProfileSection(
                title: 'Division',
                subtitle: 'Div $division',
                icon: Icons.star,
              )),
              item(ProfileSection(
                title: 'Rank',
                subtitle: rank,
                icon: Icons.emoji_events,
              )),
              item(ProfileSection(
                title: 'Solved Problems',
                subtitle: '$solvedProblems',
                icon: Icons.check_circle,
              )),
            ],
          );
        },
      ),
    );
  }
}