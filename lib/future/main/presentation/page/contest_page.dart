import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/bloc/contest_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/main/presentation/widget/bar_box.dart';
import '../widget/contest_box.dart';
import 'contest_leaderboard_page.dart';

class ContestPage extends StatefulWidget {
  const ContestPage({super.key});

  @override
  State<ContestPage> createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Rated', 'Unrated', 'Sponsors'];

  @override
  void initState() {
    super.initState();
    context.read<ContestCubit>().loadContests();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 2,
      title: 'Contests',
      subtitle: 'Compete and climb the ranks',
      body: BlocBuilder<ContestCubit, ContestState>(
        builder: (context, state) {
          if (state is ContestLoading) {
            return const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor));
          }
          if (state is ContestLoaded) {
            return _buildContent(state);
          }
          if (state is ContestError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(ContestLoaded state) {
    final upcoming = state.contests.where((c) => !c.isPast).toList();
    final past = state.contests.where((c) => c.isPast).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilterIndex = i),
                      child: BarBox(
                        text: _filters[i],
                        isActive: _selectedFilterIndex == i,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Upcoming
          if (upcoming.isNotEmpty) ...[
            _buildSectionLabel('Upcoming Contests'),
            ...upcoming.map((c) => _buildContestCard(c.id, c.title, c.date, c.isParticipating, c.numberOfProblems, c.duration, c.numberOfContestants, false)),
            const SizedBox(height: 24),
          ],

          // Past
          if (past.isNotEmpty) ...[
            _buildSectionLabel('Past Contests'),
            ...past.map((c) => _buildContestCard(c.id, c.title, c.date, c.isParticipating, c.numberOfProblems, c.duration, c.numberOfContestants, true)),
          ],

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Icon(Icons.emoji_events_rounded, color: UiConstants.primaryButtonColor, size: 18),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: UiConstants.mainTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestCard(String id, String title, String date, bool participated, int problems, String time, int contestants, bool isPast) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContestLeaderboardPage(
            contestId: id,
            contestTitle: title,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: UiConstants.borderColor.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: UiConstants.mainTextColor, 
                      fontSize: 18, 
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (participated)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: UiConstants.primaryButtonColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.2)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 14, color: UiConstants.primaryButtonColor),
                        SizedBox(width: 4),
                        Text(
                          'Participated', 
                          style: TextStyle(
                            color: UiConstants.primaryButtonColor, 
                            fontSize: 10, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildContestMeta(Icons.calendar_today_rounded, date),
                  const SizedBox(width: 20),
                  _buildContestMeta(Icons.timer_rounded, time),
                  const SizedBox(width: 20),
                  _buildContestMeta(Icons.code_rounded, '$problems problems'),
                  const SizedBox(width: 20),
                  _buildContestMeta(Icons.people_rounded, '$contestants contestants'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContestMeta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: UiConstants.subtitleTextColor.withOpacity(0.5)),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}