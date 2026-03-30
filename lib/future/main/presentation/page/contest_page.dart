import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/bloc/contest_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/main/presentation/widget/bar_box.dart';
import 'package:cpd_hub/future/main/presentation/widget/countdown_timer.dart';
import 'contest_leaderboard_page.dart';

class ContestPage extends StatefulWidget {
  const ContestPage({super.key});

  @override
  State<ContestPage> createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Rated', 'Unrated', 'Sponsors'];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ContestCubit>().loadContests();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ContestCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
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
            return _buildContent(context, state, sc);
          }
          if (state is ContestError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ContestLoaded state, double sc) {
    final upcoming = state.contests.where((c) => !c.isPast).toList();
    final past = state.contests.where((c) => c.isPast).toList();

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14 * sc),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16 * sc),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10 * sc),
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
          SizedBox(height: 20 * sc),

          if (upcoming.isNotEmpty) ...[
            _buildSectionLabel('Upcoming Contests', sc),
            ...upcoming.map((c) => _buildContestCard(context, c.id, c.title, c.date, c.isParticipating, c.numberOfProblems, c.duration, c.numberOfContestants, false, sc, startTime: c.startTime)),
            SizedBox(height: 20 * sc),
          ],

          if (past.isNotEmpty) ...[
            _buildSectionLabel('Past Contests', sc),
            ...past.map((c) => _buildContestCard(context, c.id, c.title, c.date, c.isParticipating, c.numberOfProblems, c.duration, c.numberOfContestants, true, sc)),
          ],

          if (state.isLoadingMore)
            Padding(
              padding: EdgeInsets.all(16 * sc),
              child: const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor, strokeWidth: 2)),
            ),
          if (!state.hasMore && state.contests.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16 * sc),
              child: Center(
                child: Text(
                  'All contests loaded',
                  style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 12 * sc),
                ),
              ),
            ),

          SizedBox(height: 80 * sc),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title, double sc) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16 * sc, 0, 16 * sc, 12 * sc),
      child: Row(
        children: [
          Icon(Icons.emoji_events_rounded, color: UiConstants.primaryButtonColor, size: 18 * sc),
          SizedBox(width: 8 * sc),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: UiConstants.subtitleTextColor.withValues(alpha: 0.7),
              fontSize: 12 * sc,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestCard(BuildContext context, String id, String title, String date, bool participated, int problems, String time, int contestants, bool isPast, double sc, {String? startTime}) {
    final DateTime? target = DateTime.tryParse(startTime ?? '');
    final showCountdown = !isPast && target != null;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContestLeaderboardPage(
            contestId: id,
            contestTitle: title,
            isPast: isPast,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(16 * sc, 0, 16 * sc, 10 * sc),
        padding: EdgeInsets.all(14 * sc),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.12)),
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
                    style: TextStyle(
                      color: UiConstants.mainTextColor,
                      fontSize: 15 * sc,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                if (participated)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 14 * sc, color: UiConstants.primaryButtonColor),
                      SizedBox(width: 4 * sc),
                      Text(
                        'Joined',
                        style: TextStyle(
                          color: UiConstants.primaryButtonColor,
                          fontSize: 11 * sc,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (showCountdown) ...[
              SizedBox(height: 10 * sc),
              CountdownTimer(targetTime: target),
            ],
            SizedBox(height: 12 * sc),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildContestMeta(Icons.calendar_today_rounded, date, sc),
                  SizedBox(width: 16 * sc),
                  _buildContestMeta(Icons.timer_rounded, time, sc),
                  SizedBox(width: 16 * sc),
                  _buildContestMeta(Icons.code_rounded, '$problems problems', sc),
                  SizedBox(width: 16 * sc),
                  _buildContestMeta(Icons.people_rounded, '$contestants users', sc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContestMeta(IconData icon, String text, double sc) {
    return Row(
      children: [
        Icon(icon, size: 14 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.5)),
        SizedBox(width: 5 * sc),
        Text(text, style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.6), fontSize: 12 * sc, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
