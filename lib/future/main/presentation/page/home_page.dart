import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/future/main/presentation/bloc/home_cubit.dart';
import 'package:cpd_hub/future/main/presentation/widget/problem_box.dart';
import 'problem_details_page.dart';

import '../../../../core/ui_constants.dart';
import '../widget/info_box.dart';
import '../widget/todays_problem_box.dart';
import '../widget/welcomback_box.dart';
import 'base_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return BasePage(
      selectedIndex: 0,
      title: 'Home',
      subtitle: 'Ready to solve today?',
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor));
          }
          if (state is HomeLoaded) {
            return _buildContent(context, state, sc);
          }
          if (state is HomeError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state, double sc) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const WelcomeBackBox(name: 'Bereket'),

          _buildSectionHeader(Icons.emoji_events_rounded, "Upcoming Contests", sc),
          _buildContestCarousel(state, sc),
          SizedBox(height: 20 * sc),

          _buildSectionHeader(Icons.notifications_active_rounded, "Latest Updates", sc),
          ...state.infoList.map((info) => InfoBox(title: info.title, description: info.description)),
          SizedBox(height: 10 * sc),

          if (state.dailyProblem != null) ...[
            _buildSectionHeader(Icons.auto_awesome_rounded, "Daily Challenge", sc),
            TodaysProblemBox(
              problemTitle: state.dailyProblem!.title,
              solved: state.dailyProblem!.numberOfSolvedPeople.toDouble(),
              tags: state.dailyProblem!.tags,
              liked: state.dailyProblem!.numberOfLikes.toDouble(),
              disliked: state.dailyProblem!.numberOfDislikes.toDouble(),
              difficulty: state.dailyProblem!.difficulty,
              isLiked: state.dailyProblem!.isLiked,
              isDisliked: state.dailyProblem!.isDisliked,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProblemDetailsPage(
                    problemData: {
                      'title': state.dailyProblem!.title,
                      'difficulty': state.dailyProblem!.difficulty,
                      'likedCount': '${state.dailyProblem!.numberOfLikes}',
                      'dislikedCount': '${state.dailyProblem!.numberOfDislikes}',
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20 * sc),
          ],

          _buildSectionHeader(Icons.analytics_rounded, "Live Activity", sc),
          _buildActivityFeed(state, sc),
          SizedBox(height: 20 * sc),

          _buildSectionHeader(Icons.trending_up_rounded, "Trending Problems", sc),
          _buildProblemsSection(context, state, sc),
          SizedBox(height: 80 * sc),
        ],
      ),
    );
  }

  Widget _buildContestCarousel(HomeLoaded state, double sc) {
    final contests = state.upcomingContests;
    if (contests.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 * sc),
        child: Text("No upcoming contests", style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5))),
      );
    }

    return SizedBox(
      height: 120 * sc,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16 * sc),
        itemCount: contests.length,
        itemBuilder: (context, index) {
          final c = contests[index];
          final isStarted = c.startTime == "Started" || c.duration.isEmpty;

          return Container(
            width: 200 * sc,
            margin: EdgeInsets.only(right: 10 * sc),
            padding: EdgeInsets.all(14 * sc),
            decoration: BoxDecoration(
              color: isStarted
                  ? Colors.redAccent.withValues(alpha: 0.08)
                  : UiConstants.infoBackgroundColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isStarted ? Colors.redAccent.withValues(alpha: 0.25) : UiConstants.borderColor.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 4 * sc),
                      decoration: BoxDecoration(
                        color: isStarted ? Colors.redAccent : UiConstants.primaryButtonColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isStarted ? "LIVE" : "Rated",
                        style: TextStyle(color: Colors.black, fontSize: 10 * sc, fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (!isStarted)
                      Row(
                        children: [
                          Icon(Icons.timer_rounded, size: 13 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.6)),
                          SizedBox(width: 4 * sc),
                          Text(c.duration, style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.6), fontSize: 11 * sc, fontWeight: FontWeight.w600)),
                        ],
                      ),
                  ],
                ),
                Text(
                  c.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: UiConstants.mainTextColor, fontSize: 14 * sc, fontWeight: FontWeight.w800, height: 1.2),
                ),
                Text(
                  isStarted ? "Contest is running now" : "Registration Open",
                  style: TextStyle(color: isStarted ? Colors.redAccent : Colors.greenAccent, fontSize: 11 * sc, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityFeed(HomeLoaded state, double sc) {
    final activities = state.activityFeed;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * sc),
      padding: EdgeInsets.all(14 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: activities.asMap().entries.map((entry) {
          final activity = entry.value;
          final isLast = entry.key == activities.length - 1;
          IconData icon;
          Color color;
          switch (activity.type) {
            case 'Solve':
              icon = Icons.check_circle_rounded;
              color = Colors.greenAccent;
              break;
            case 'Rating':
              icon = Icons.trending_up_rounded;
              color = UiConstants.primaryButtonColor;
              break;
            case 'Badge':
              icon = Icons.workspace_premium_rounded;
              color = Colors.amberAccent;
              break;
            default:
              icon = Icons.info_rounded;
              color = Colors.blueAccent;
          }
          return Column(
            children: [
              _buildActivityItem(icon, color, '${activity.username} ${activity.action}', activity.timestamp, sc),
              if (!isLast)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0 * sc),
                  child: const Divider(color: Colors.white10, height: 1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, Color color, String text, String time, double sc) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6 * sc),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 14 * sc),
        ),
        SizedBox(width: 12 * sc),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: UiConstants.mainTextColor, fontSize: 13 * sc, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          time,
          style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 11 * sc, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, double sc) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16 * sc, 6 * sc, 16 * sc, 12 * sc),
      child: Row(
        children: [
          Icon(icon, color: UiConstants.primaryButtonColor, size: 18 * sc),
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

  Widget _buildProblemsSection(BuildContext context, HomeLoaded state, double sc) {
    final problems = state.trendingProblems;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.0 * sc, 16.0 * sc, 16.0 * sc, 10.0 * sc),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.grid_view_rounded, color: UiConstants.primaryButtonColor, size: 18 * sc),
                    SizedBox(width: 10.0 * sc),
                    Text(
                      "Trending Problems",
                      style: TextStyle(fontSize: 15 * sc, fontWeight: FontWeight.w700, color: UiConstants.mainTextColor),
                    ),
                  ],
                ),
                Icon(Icons.tune_rounded, color: UiConstants.subtitleTextColor.withValues(alpha: 0.4), size: 20 * sc),
              ],
            ),
          ),
          ...problems.take(5).map((problem) {
            return ProblemBox(
              title: problem.title,
              difficulty: problem.difficulty,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProblemDetailsPage(problemData: {
                    'title': problem.title,
                    'difficulty': problem.difficulty,
                    'likedCount': '${problem.numberOfLikes}',
                    'dislikedCount': '${problem.numberOfDislikes}',
                  }),
                ),
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.all(14.0 * sc),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/problems'),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.0 * sc),
                decoration: BoxDecoration(
                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'EXPLORE ALL PROBLEMS',
                      style: TextStyle(
                        fontSize: 12 * sc,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: UiConstants.primaryButtonColor,
                      ),
                    ),
                    SizedBox(width: 8 * sc),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12 * sc, color: UiConstants.primaryButtonColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
