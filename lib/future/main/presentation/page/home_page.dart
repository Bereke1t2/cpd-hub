import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            return _buildContent(state);
          }
          if (state is HomeError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(HomeLoaded state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const WelcomeBackBox(name: 'Bereket'),

          _buildSectionHeader(Icons.emoji_events_rounded, "Upcoming Contests"),
          _buildContestCarousel(state),
          const SizedBox(height: 24),

          _buildSectionHeader(Icons.notifications_active_rounded, "Latest Updates"),
          ...state.infoList.map((info) => InfoBox(title: info.title, description: info.description)),
          const SizedBox(height: 12),

          if (state.dailyProblem != null) ...[
            _buildSectionHeader(Icons.auto_awesome_rounded, "Daily Challenge"),
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
            const SizedBox(height: 24),
          ],

          _buildSectionHeader(Icons.analytics_rounded, "Live Activity"),
          _buildActivityFeed(state),
          const SizedBox(height: 24),

          _buildSectionHeader(Icons.trending_up_rounded, "Trending Problems"),
          _buildProblemsSection(state),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildContestCarousel(HomeLoaded state) {
    final contests = state.upcomingContests;
    if (contests.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text("No upcoming contests", style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5))),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: contests.length,
        itemBuilder: (context, index) {
          final c = contests[index];
          final isStarted = c.startTime == "Started" || c.duration.isEmpty;

          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isStarted
                  ? Colors.redAccent.withOpacity(0.1)
                  : UiConstants.infoBackgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isStarted ? Colors.redAccent.withOpacity(0.3) : UiConstants.borderColor.withOpacity(0.15),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isStarted ? Colors.redAccent : UiConstants.primaryButtonColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isStarted ? "LIVE" : "Rated",
                        style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (!isStarted)
                      Row(
                        children: [
                          Icon(Icons.timer_rounded, size: 12, color: UiConstants.subtitleTextColor.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(c.duration, style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                  ],
                ),
                Text(
                  c.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: UiConstants.mainTextColor, fontSize: 16, fontWeight: FontWeight.w900, height: 1.2),
                ),
                Text(
                  isStarted ? "Contest is running now" : "Registration Open",
                  style: TextStyle(color: isStarted ? Colors.redAccent : Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityFeed(HomeLoaded state) {
    final activities = state.activityFeed;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.1)),
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
              _buildActivityItem(icon, color, '${activity.username} ${activity.action}', activity.timestamp),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(color: Colors.white10, height: 1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, Color color, String text, String time) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: UiConstants.mainTextColor, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          time,
          style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          Icon(icon, color: UiConstants.primaryButtonColor, size: 18),
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

  Widget _buildProblemsSection(HomeLoaded state) {
    final problems = state.trendingProblems;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.grid_view_rounded, color: UiConstants.primaryButtonColor, size: 20),
                    SizedBox(width: 12.0),
                    Text(
                      "Trending Problems",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: UiConstants.mainTextColor),
                    ),
                  ],
                ),
                Icon(Icons.tune_rounded, color: UiConstants.subtitleTextColor.withOpacity(0.5), size: 20),
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
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/problems'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                decoration: BoxDecoration(
                  color: UiConstants.primaryButtonColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'EXPLORE ALL PROBLEMS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: UiConstants.primaryButtonColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios_rounded, size: 10, color: UiConstants.primaryButtonColor),
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