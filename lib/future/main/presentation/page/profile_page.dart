import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/presentation/bloc/profile_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/main/domain/entitiy/attendance_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/heatmap_entry_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/rating_point_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/social_link_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/submission_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/user_entity.dart';
import '../../../../core/ui_constants.dart';
import '../widget/info_section.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final String? username;
  const ProfilePage({super.key, this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

  bool get isOwner => (widget.username == null || widget.username == 'me');
  String get currentUsername => widget.username ?? 'me';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: isOwner ? 4 : 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    context.read<ProfileCubit>().loadProfile(currentUsername);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: UiConstants.primaryButtonColor,
              onPrimary: Colors.black,
              surface: UiConstants.infoBackgroundColor,
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: UiConstants.primaryButtonColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      final oldMonth = _selectedDate.month;
      final oldYear = _selectedDate.year;
      
      setState(() {
        _selectedDate = picked;
      });

      if (picked.month != oldMonth || picked.year != oldYear) {
        context.read<ProfileCubit>().loadAttendanceForMonth(currentUsername, picked.month, picked.year);
        context.read<ProfileCubit>().loadHeatmapForMonth(currentUsername, picked.month, picked.year);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: isOwner ? "Profile" : "User Profile",
      subtitle: isOwner ? "Your personal information" : "Member statistics & activity",
      selectedIndex: isOwner ? 4 : 3,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor));
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          if (state is ProfileLoaded) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildProfileHeader(context, state.user),
                  const SizedBox(height: 16),
                  _buildTabBar(),
                  const SizedBox(height: 24),
                  _buildTabContent(state),
                  const SizedBox(height: 100), // Extra space for scrolling
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserEntity user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Cover Gradient
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      UiConstants.primaryButtonColor,
                      UiConstants.secondaryButtonColor,
                    ],
                  ),
                ),
              ),
              // Avatar
              Transform.translate(
                offset: const Offset(0, 40),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: UiConstants.infoBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: UiConstants.primaryButtonColor.withOpacity(0.1),
                    backgroundImage: user.avatarUrl.isNotEmpty 
                      ? NetworkImage(user.avatarUrl) 
                      : const NetworkImage('https://www.gravatar.com/avatar/placeholder?s=200&d=robohash&r=x'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: UiConstants.mainTextColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.3)),
                      ),
                      child: const Text(
                        "Active Now",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: UiConstants.primaryButtonColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "•",
                      style: TextStyle(color: UiConstants.subtitleTextColor),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.rank,
                      style: const TextStyle(
                        fontSize: 12,
                        color: UiConstants.subtitleTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating < 1200) return Colors.grey;
    if (rating < 1400) return Colors.green;
    if (rating < 1600) return Colors.cyan;
    if (rating < 1900) return Colors.blue;
    if (rating < 2100) return Colors.purple;
    if (rating < 2400) return Colors.orange;
    return Colors.red;
  }

  Widget _buildStatsSection(UserEntity user) {
    final rating = user.rating;
    final ratingColor = _getRatingColor(rating);
    return InfoSection(
      division: user.division == 'Div 1' ? 1 : 2,
      rating: rating.toString(),
      rank: user.rank,
      solvedProblems: user.solvedProblems,
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [UiConstants.primaryButtonColor, Color(0xFF32D74B)],
          ),
          boxShadow: [
            BoxShadow(
              color: UiConstants.primaryButtonColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.black,
        unselectedLabelColor: UiConstants.subtitleTextColor.withOpacity(0.6),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        tabs: [
          const Tab(
            icon: Icon(Icons.person_rounded, size: 20),
            text: "Profile",
          ),
          const Tab(
            icon: Icon(Icons.calendar_today_rounded, size: 18),
            text: "Attendance",
          ),
          const Tab(
            icon: Icon(Icons.history_rounded, size: 20),
            text: "Submissions",
          ),
          if (isOwner)
            const Tab(
              icon: Icon(Icons.settings_rounded, size: 20),
              text: "Settings",
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProfileLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: [
        _buildOverviewTab(state),
        _buildAttendanceTab(state),
        _buildSubmissionsTab(state.submissionData),
        if (isOwner)
          const Center(child: Text("Settings coming soon", style: TextStyle(color: UiConstants.subtitleTextColor))),
      ][_tabController.index],
    );
  }

  Widget _buildOverviewTab(ProfileLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsSection(state.user),
        const SizedBox(height: 24),
        _buildSectionTitle("Coding Consistency"),
        const SizedBox(height: 12),
        _buildActivityHeatmap(state.heatmapData),
        const SizedBox(height: 24),
        _buildSectionTitle("Rating History"),
        const SizedBox(height: 12),
        _buildRatingGraph(state.ratingHistory),
        const SizedBox(height: 24),
        _buildCPMetricsGrid(state.user),
        const SizedBox(height: 24),
        _buildSectionTitle("Coding Profiles"),
        const SizedBox(height: 12),
        _buildSocialLinksGrid(state.user.socialLinks),
        const SizedBox(height: 24),
        _buildSectionTitle("General Info"),
        const SizedBox(height: 12),
        _buildInfoCard(
          "Biography",
          state.user.bio.isNotEmpty ? state.user.bio : "No bio provided",
          Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          "Experience",
          "3+ years in Flutter development, 500+ problems solved on various platforms.",
          Icons.workspace_premium_outlined,
        ),
      ],
    );
  }

  Widget _buildRatingGraph(List<RatingPointEntity> ratingHistory) {
    // Convert RatingPointEntity list to FlSpots
    final List<FlSpot> spots = [];
    for (int i = 0; i < ratingHistory.length; i++) {
      spots.add(FlSpot(i.toDouble(), ratingHistory[i].rating.toDouble()));
    }

    // Default if empty
    if (spots.isEmpty) {
      spots.add(const FlSpot(0, 1000));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 24, right: 24, left: 16, bottom: 12),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.3)),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 500,
            getDrawingHorizontalLine: (value) => FlLine(
              color: UiConstants.borderColor.withOpacity(0.1),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < ratingHistory.length) {
                    final date = DateTime.tryParse(ratingHistory[index].date);
                    if (date != null) {
                      return Text(
                        _getMonthName(date.month).substring(0, 3),
                        style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 10),
                      );
                    }
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 500,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (spots.length - 1).toDouble().clamp(1, 100),
          minY: (spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 200).clamp(0, 4000),
          maxY: (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 200).clamp(1000, 4000),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: UiConstants.primaryButtonColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 5,
                  color: _getRatingColor(spot.y.toInt()),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    UiConstants.primaryButtonColor.withOpacity(0.15),
                    UiConstants.primaryButtonColor.withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => UiConstants.infoBackgroundColor,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final spots = barSpot.bar.spots;
                  final index = barSpot.spotIndex;
                  final rating = barSpot.y.toInt();
                  final delta = index > 0 ? (rating - spots[index - 1].y).toInt() : 0;
                  final ratingColor = _getRatingColor(rating);
                  final deltaColor = delta >= 0 ? Colors.green : Colors.red;
                  final sign = delta >= 0 ? "+" : "";
                  
                  return LineTooltipItem(
                    'Rating: ',
                    const TextStyle(color: Colors.white70, fontSize: 10),
                    children: [
                      TextSpan(
                        text: '$rating\n',
                        style: TextStyle(color: ratingColor, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      TextSpan(
                        text: '$sign$delta',
                        style: TextStyle(color: deltaColor, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityHeatmap(List<HeatmapEntryEntity> heatmapData) {
    final monthName = _getMonthName(_selectedDate.month);
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1).weekday;
    // Align with Sunday start (weekday is 1-7, Mon-Sun)
    final paddingDays = firstDayOfMonth == 7 ? 0 : firstDayOfMonth;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Coding Heatmap: $monthName ${_selectedDate.year}", 
                      style: const TextStyle(color: UiConstants.mainTextColor, fontSize: 13, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("Monthly activity frequency", 
                      style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.6), fontSize: 9),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_month_rounded, size: 14),
                label: const Text("Select Month", style: TextStyle(fontSize: 11)),
                style: TextButton.styleFrom(
                  foregroundColor: UiConstants.primaryButtonColor,
                  backgroundColor: UiConstants.primaryButtonColor.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Day Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => Expanded(
              child: Center(child: Text(day, style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w600))),
            )).toList(),
          ),
          const SizedBox(height: 12),
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: daysInMonth + paddingDays,
            itemBuilder: (context, index) {
              if (index < paddingDays) return const SizedBox.shrink();
              
              final dayIndex = index - paddingDays;
              final dayNumber = dayIndex + 1;
              
              // Find matching entry in heatmapData
              int problemCount = 0;
              for (var entry in heatmapData) {
                final date = DateTime.tryParse(entry.date);
                if (date?.day == dayNumber) {
                  problemCount = entry.solveCount;
                  break;
                }
              }
              Color boxColor;
              if (problemCount == 0) {
                boxColor = UiConstants.borderColor.withOpacity(0.1);
              } else if (problemCount < 4) {
                boxColor = UiConstants.primaryButtonColor.withOpacity(0.2);
              } else if (problemCount < 8) {
                boxColor = UiConstants.primaryButtonColor.withOpacity(0.5);
              } else if (problemCount < 12) {
                boxColor = UiConstants.primaryButtonColor.withOpacity(0.8);
              } else {
                boxColor = UiConstants.primaryButtonColor;
              }

              return Tooltip(
                message: "$monthName ${dayIndex + 1}: $problemCount Solved",
                child: Container(
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: problemCount > 8 ? [
                      BoxShadow(color: UiConstants.primaryButtonColor.withOpacity(0.2), blurRadius: 4, spreadRadius: 1)
                    ] : null,
                  ),
                  child: Center(
                    child: Text(
                      "${dayIndex + 1}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: problemCount > 8 ? Colors.white : UiConstants.mainTextColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Less", style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 10)),
              const SizedBox(width: 8),
              ...List.generate(5, (index) {
                Color boxColor;
                switch (index) {
                  case 0: boxColor = UiConstants.borderColor.withOpacity(0.1); break;
                  case 1: boxColor = UiConstants.primaryButtonColor.withOpacity(0.2); break;
                  case 2: boxColor = UiConstants.primaryButtonColor.withOpacity(0.5); break;
                  case 3: boxColor = UiConstants.primaryButtonColor.withOpacity(0.8); break;
                  default: boxColor = UiConstants.primaryButtonColor;
                }
                return Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(3)),
                );
              }),
              const SizedBox(width: 8),
              Text("More", style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCPMetricsGrid(UserEntity user) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            "Contests",
            user.attendedContestsCount.toString(),
            Icons.emoji_events_outlined,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricTile(
            "Global Rank",
            "#${user.globalRank.toString()}",
            Icons.public_outlined,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: UiConstants.mainTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: UiConstants.subtitleTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinksGrid(List<SocialLinkEntity> links) {
    if (links.isEmpty) {
      return Center(
        child: Text(
          "No social links added",
          style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 12),
        ),
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < links.length; i += 2) {
      final rowItems = <Widget>[];
      rowItems.add(Expanded(child: _buildSocialCard(links[i])));
      
      if (i + 1 < links.length) {
        rowItems.add(const SizedBox(width: 12));
        rowItems.add(Expanded(child: _buildSocialCard(links[i+1])));
      } else {
        rowItems.add(const SizedBox(width: 12));
        rowItems.add(const Expanded(child: SizedBox.shrink()));
      }
      
      rows.add(Row(children: rowItems));
      if (i + 2 < links.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(children: rows);
  }

  Widget _buildSocialCard(SocialLinkEntity link) {
    IconData icon = Icons.link_rounded;
    Color color = UiConstants.primaryButtonColor;

    if (link.platform.toLowerCase().contains('leetcode')) {
      icon = Icons.code_rounded;
      color = Colors.orange;
    } else if (link.platform.toLowerCase().contains('codeforces')) {
      icon = Icons.terminal_rounded;
      color = Colors.redAccent;
    } else if (link.platform.toLowerCase().contains('linkedin')) {
      icon = Icons.link_rounded;
      color = Colors.blueAccent;
    } else if (link.platform.toLowerCase().contains('telegram')) {
      icon = Icons.send_rounded;
      color = Colors.lightBlue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.platform,
                  style: TextStyle(fontSize: 11, color: UiConstants.subtitleTextColor.withOpacity(0.7), fontWeight: FontWeight.w600),
                ),
                Text(
                  link.handle,
                  style: const TextStyle(fontSize: 13, color: UiConstants.mainTextColor, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.open_in_new_rounded, size: 14, color: UiConstants.subtitleTextColor.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab(ProfileLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Attendance Insights"),
        const SizedBox(height: 12),
        _buildAttendanceSummary(state.attendanceData),
        const SizedBox(height: 24),
        _buildSectionTitle("Activity Grid"),
        const SizedBox(height: 12),
        _buildEnhancedAttendanceGrid(state.attendanceData),
      ],
    );
  }

  Widget _buildAttendanceSummary(List<AttendanceEntity> data) {
    final present = data.where((e) => e.status == 'Present').length;
    final missed = data.where((e) => e.status == 'Absent').length;
    
    // Simple streak calculation for mock
    int streak = 0;
    for (var i = data.length - 1; i >= 0; i--) {
      if (data[i].status == 'Present') {
        streak++;
      } else {
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("Current Streak", "$streak Days", Icons.local_fire_department_rounded, Colors.orangeAccent.withOpacity(0.8)),
          _buildSummaryVerticalDivider(),
          _buildSummaryItem("Total Present", "$present Days", Icons.event_available_rounded, UiConstants.primaryButtonColor.withOpacity(0.8)),
          _buildSummaryVerticalDivider(),
          _buildSummaryItem("Missed", "$missed Days", Icons.event_busy_rounded, Colors.redAccent.withOpacity(0.8)),
        ],
      ),
    );
  }

  Widget _buildSummaryVerticalDivider() {
    return Container(height: 40, width: 1, color: UiConstants.borderColor.withOpacity(0.3));
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: UiConstants.mainTextColor)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: UiConstants.subtitleTextColor.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8, 
          height: 8, 
          decoration: BoxDecoration(
            color: color.withOpacity(0.7), 
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color.withOpacity(0.2), width: 0.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11, color: UiConstants.subtitleTextColor.withOpacity(0.7), fontWeight: FontWeight.w500)),
      ],
    );
  }
  Widget _buildEnhancedAttendanceGrid(List<AttendanceEntity> attendanceData) {
    final monthName = _getMonthName(_selectedDate.month);
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1).weekday;
    // Align with Sunday start (weekday is 1-7, Mon-Sun)
    final paddingDays = firstDayOfMonth == 7 ? 0 : firstDayOfMonth;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$monthName ${_selectedDate.year}", 
                      style: const TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("Spring Semester", 
                      style: TextStyle(fontSize: 10, color: UiConstants.subtitleTextColor.withOpacity(0.6)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_month_rounded, size: 16),
                label: const Text("Select Date"),
                style: TextButton.styleFrom(
                  foregroundColor: UiConstants.primaryButtonColor,
                  backgroundColor: UiConstants.primaryButtonColor.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildLegendDot(UiConstants.primaryButtonColor, "Present"),
              _buildLegendDot(Colors.redAccent, "Absent"),
              _buildLegendDot(Colors.amberAccent, "Excused"),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: daysInMonth + paddingDays,
            itemBuilder: (context, index) {
              if (index < paddingDays) return const SizedBox.shrink();
              
              final dayIndex = index - paddingDays;
              final dayNumber = dayIndex + 1;

              // Find matching entry in attendanceData
              String status = 'None';
              for (var entry in attendanceData) {
                final date = DateTime.tryParse(entry.date);
                if (date?.day == dayNumber) {
                  status = entry.status;
                  break;
                }
              }

              Color boxColor;
              Color contentColor;
              BoxBorder? border;

              switch (status) {
                case 'Present': 
                  boxColor = UiConstants.primaryButtonColor.withOpacity(0.15);
                  contentColor = UiConstants.primaryButtonColor;
                  border = Border.all(color: UiConstants.primaryButtonColor.withOpacity(0.3), width: 1);
                  break;
                case 'Absent': 
                  boxColor = Colors.redAccent.withOpacity(0.15);
                  contentColor = Colors.redAccent;
                  border = Border.all(color: Colors.redAccent.withOpacity(0.3), width: 1);
                  break;
                case 'Excused': 
                  boxColor = Colors.amberAccent.withOpacity(0.15);
                  contentColor = Colors.amberAccent;
                  border = Border.all(color: Colors.amberAccent.withOpacity(0.3), width: 1);
                  break;
                default: 
                  boxColor = Colors.transparent;
                  contentColor = UiConstants.mainTextColor.withOpacity(0.15);
                  border = Border.all(color: UiConstants.borderColor.withOpacity(0.1), width: 1);
              }

              return Container(
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(10),
                  border: border,
                ),
                child: Center(
                  child: Text(
                    "$dayNumber",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: contentColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }



  Widget _buildSubmissionsTab(List<SubmissionEntity> submissions) {
    if (submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: UiConstants.subtitleTextColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text("No recent submissions", style: TextStyle(color: UiConstants.subtitleTextColor)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Recent Submissions"),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: submissions.length,
          itemBuilder: (context, index) {
            final submission = submissions[index];
            final isAccepted = submission.status.toLowerCase() == 'accepted';
            final statusColor = isAccepted ? Colors.greenAccent : Colors.redAccent;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: UiConstants.infoBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isAccepted ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          submission.problemTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: UiConstants.mainTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              submission.language,
                              style: TextStyle(
                                fontSize: 12,
                                color: UiConstants.subtitleTextColor.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              "•",
                              style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.3)),
                            ),
                            Text(
                              submission.timestamp,
                              style: TextStyle(
                                fontSize: 12,
                                color: UiConstants.subtitleTextColor.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        submission.status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        submission.executionTime,
                        style: TextStyle(
                          fontSize: 11,
                          color: UiConstants.subtitleTextColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return Column(
      children: [
        _buildSettingsTile(Icons.manage_accounts_outlined, "Edit Profile"),
        _buildSettingsTile(Icons.notifications_active_outlined, "Notifications"),
        _buildSettingsTile(Icons.security_outlined, "Security & Password"),
        _buildSettingsTile(Icons.help_outline_rounded, "Help & Support"),
        _buildSettingsTile(Icons.logout_rounded, "Logout", isDestructive: true),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.redAccent : UiConstants.mainTextColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color.withOpacity(0.8)),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right_rounded, color: UiConstants.subtitleTextColor.withOpacity(0.5)),
        onTap: () {},
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: UiConstants.mainTextColor,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: UiConstants.primaryButtonColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: UiConstants.mainTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: UiConstants.subtitleTextColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
