import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/injection.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/theme/theme_cubit.dart';
import 'package:cpd_hub/core/theme/app_theme.dart';
import 'package:cpd_hub/future/main/presentation/bloc/profile_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/main/domain/entitiy/attendance_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/heatmap_entry_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/rating_point_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/social_link_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/user_entity.dart';
import '../../../../core/ui_constants.dart';
import '../widget/info_section.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfilePage extends StatefulWidget {
  final String? username;
  const ProfilePage({super.key, this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

  bool get isOwner => (widget.username == null || widget.username == _loggedInUsername);
  String get _loggedInUsername => Injection().authService.currentUsername ?? '';
  String get currentUsername => widget.username ?? _loggedInUsername;

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
    final sc = context.sc;
    return BasePage(
      title: isOwner ? "Profile" : "User Profile",
      subtitle: isOwner ? "Your personal information" : "Member statistics & activity",
      selectedIndex: isOwner ? 4 : 3,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.error != null && state.user == null) {
            return Center(child: Text(state.error!, style: TextStyle(color: Colors.redAccent, fontSize: 14 * sc)));
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                if (state.isUserLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 40 * sc),
                    child: const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor)),
                  )
                else if (state.user != null)
                  _buildProfileHeader(context, state.user!, sc),
                if (state.user != null) ...[
                  SizedBox(height: 16 * sc),
                  _buildTabBar(sc),
                  SizedBox(height: 24 * sc),
                  _buildTabContent(state, sc),
                ],
                SizedBox(height: 100 * sc),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserEntity user, double sc) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 100 * sc,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      UiConstants.primaryButtonColor,
                      UiConstants.secondaryButtonColor,
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 36),
                child: Container(
                  padding: EdgeInsets.all(3 * sc),
                  decoration: BoxDecoration(
                    color: UiConstants.infoBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 40 * sc,
                    backgroundColor: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
                    backgroundImage: user.avatarUrl.isNotEmpty
                        ? NetworkImage(user.avatarUrl)
                        : const NetworkImage('https://www.gravatar.com/avatar/placeholder?s=200&d=robohash&r=x'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 44 * sc),
          Padding(
            padding: EdgeInsets.fromLTRB(16 * sc, 0, 16 * sc, 16 * sc),
            child: Column(
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: 20 * sc,
                    fontWeight: FontWeight.bold,
                    color: UiConstants.mainTextColor,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8 * sc),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 3 * sc),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        "Active Now",
                        style: TextStyle(
                          fontSize: 11 * sc,
                          fontWeight: FontWeight.w600,
                          color: UiConstants.primaryButtonColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * sc),
                    Text(
                      "•",
                      style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11 * sc),
                    ),
                    SizedBox(width: 8 * sc),
                    Text(
                      user.rank,
                      style: TextStyle(
                        fontSize: 11 * sc,
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
    return InfoSection(
      division: user.division == 'Div 1' ? 1 : 2,
      rating: user.rating.toString(),
      rank: user.rank,
      solvedProblems: user.solvedProblems,
    );
  }

  Widget _buildTabBar(double sc) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * sc),
      padding: EdgeInsets.all(6 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
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
              color: UiConstants.primaryButtonColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.black,
        unselectedLabelColor: UiConstants.subtitleTextColor.withValues(alpha: 0.6),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12 * sc),
        tabs: [
          Tab(
            icon: Icon(Icons.person_rounded, size: 18 * sc),
            text: "Profile",
          ),
          Tab(
            icon: Icon(Icons.calendar_today_rounded, size: 18 * sc),
            text: "Attendance",
          ),
          Tab(
            icon: Icon(Icons.history_rounded, size: 18 * sc),
            text: "Submissions",
          ),
          if (isOwner)
            Tab(
              icon: Icon(Icons.settings_rounded, size: 18 * sc),
              text: "Settings",
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProfileState state, double sc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 * sc),
      child: [
        _buildOverviewTab(state, sc),
        _buildAttendanceTab(context, state, sc),
        _buildSubmissionsTab(state, sc),
        if (isOwner)
          _buildSettingsTab(sc),
      ][_tabController.index],
    );
  }

  Widget _buildOverviewTab(ProfileState state, double sc) {
    final user = state.user!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsSection(user),
        SizedBox(height: 24 * sc),

        _buildSectionTitle("Coding Consistency", sc),
        SizedBox(height: 12 * sc),
        if (state.isHeatmapLoading)
          _buildLoadingPlaceholder(sc)
        else
          _buildActivityHeatmap(context, state.heatmapData, sc),
        SizedBox(height: 24 * sc),

        _buildSectionTitle("Rating History", sc),
        SizedBox(height: 12 * sc),
        if (state.isRatingLoading)
          _buildLoadingPlaceholder(sc)
        else
          _buildRatingGraph(state.ratingHistory, sc),
        SizedBox(height: 24 * sc),

        _buildCPMetricsGrid(user, sc),
        SizedBox(height: 24 * sc),
        _buildSectionTitle("Coding Profiles", sc),
        SizedBox(height: 12 * sc),
        _buildSocialLinksGrid(user.socialLinks, sc),
        SizedBox(height: 24 * sc),
        _buildSectionTitle("General Info", sc),
        SizedBox(height: 12 * sc),
        _buildInfoCard(
          "Biography",
          user.bio.isNotEmpty ? user.bio : "No bio provided",
          Icons.person_outline,
          sc,
        ),
        SizedBox(height: 16 * sc),
        _buildInfoCard(
          "Experience",
          "3+ years in Flutter development, 500+ problems solved on various platforms.",
          Icons.workspace_premium_outlined,
          sc,
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder(double sc) {
    return Container(
      height: 100 * sc,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor, strokeWidth: 2)),
    );
  }

  Widget _buildRatingGraph(List<RatingPointEntity> ratingHistory, double sc) {
    final List<FlSpot> spots = [];
    for (int i = 0; i < ratingHistory.length; i++) {
      spots.add(FlSpot(i.toDouble(), ratingHistory[i].rating.toDouble()));
    }

    if (spots.isEmpty) {
      spots.add(const FlSpot(0, 1000));
    }

    return Container(
      height: 180 * sc,
      padding: EdgeInsets.only(top: 16 * sc, right: 16 * sc, left: 12 * sc, bottom: 8 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.3)),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 500,
            getDrawingHorizontalLine: (value) => FlLine(
              color: UiConstants.borderColor.withValues(alpha: 0.1),
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
                reservedSize: 22 * sc,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < ratingHistory.length) {
                    final date = DateTime.tryParse(ratingHistory[index].date);
                    if (date != null) {
                      return Text(
                        _getMonthName(date.month).substring(0, 3),
                        style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 10 * sc),
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
                reservedSize: 35 * sc,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 10 * sc),
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
              barWidth: 2.5 * sc,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4 * sc,
                  color: _getRatingColor(spot.y.toInt()),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    UiConstants.primaryButtonColor.withValues(alpha: 0.15),
                    UiConstants.primaryButtonColor.withValues(alpha: 0),
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
                    TextStyle(color: Colors.white70, fontSize: 10 * sc),
                    children: [
                      TextSpan(
                        text: '$rating\n',
                        style: TextStyle(color: ratingColor, fontWeight: FontWeight.bold, fontSize: 14 * sc),
                      ),
                      TextSpan(
                        text: '$sign$delta',
                        style: TextStyle(color: deltaColor, fontWeight: FontWeight.bold, fontSize: 11 * sc),
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

  Widget _buildActivityHeatmap(BuildContext context, List<HeatmapEntryEntity> heatmapData, double sc) {
    final monthName = _getMonthName(_selectedDate.month);
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1).weekday;
    final paddingDays = firstDayOfMonth == 7 ? 0 : firstDayOfMonth;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.3)),
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
                    Text(
                      "Coding Heatmap: $monthName ${_selectedDate.year}",
                      style: TextStyle(color: UiConstants.mainTextColor, fontSize: 12 * sc, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Monthly activity frequency",
                      style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.6), fontSize: 9 * sc),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8 * sc),
              TextButton.icon(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_month_rounded, size: 12 * sc),
                label: Text("Select Month", style: TextStyle(fontSize: 10 * sc)),
                style: TextButton.styleFrom(
                  foregroundColor: UiConstants.primaryButtonColor,
                  backgroundColor: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
                  padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 6 * sc),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          SizedBox(height: 24 * sc),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
                      child: Center(
                          child: Text(day, style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 10 * sc, fontWeight: FontWeight.w600))),
                    ))
                .toList(),
          ),
          SizedBox(height: 12 * sc),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8 * sc,
              crossAxisSpacing: 8 * sc,
            ),
            itemCount: daysInMonth + paddingDays,
            itemBuilder: (context, index) {
              if (index < paddingDays) return const SizedBox.shrink();

              final dayIndex = index - paddingDays;
              final dayNumber = dayIndex + 1;

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
                boxColor = UiConstants.borderColor.withValues(alpha: 0.1);
              } else if (problemCount < 4) {
                boxColor = UiConstants.primaryButtonColor.withValues(alpha: 0.2);
              } else if (problemCount < 8) {
                boxColor = UiConstants.primaryButtonColor.withValues(alpha: 0.5);
              } else if (problemCount < 12) {
                boxColor = UiConstants.primaryButtonColor.withValues(alpha: 0.8);
              } else {
                boxColor = UiConstants.primaryButtonColor;
              }

              return Tooltip(
                message: "$monthName ${dayIndex + 1}: $problemCount Solved",
                child: Container(
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: problemCount > 8
                        ? [
                            BoxShadow(
                                color: UiConstants.primaryButtonColor.withValues(alpha: 0.2),
                                blurRadius: 4,
                                spreadRadius: 1)
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      "${dayIndex + 1}",
                      style: TextStyle(
                        fontSize: 10 * sc,
                        fontWeight: FontWeight.bold,
                        color: problemCount > 8 ? Colors.white : UiConstants.mainTextColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20 * sc),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Less", style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 10 * sc)),
              SizedBox(width: 8 * sc),
              ...List.generate(5, (index) {
                Color boxColor;
                switch (index) {
                  case 0:
                    boxColor = UiConstants.borderColor.withValues(alpha: 0.1);
                    break;
                  case 1:
                    boxColor = UiConstants.primaryButtonColor.withValues(alpha: 0.2);
                    break;
                  case 2:
                    boxColor = UiConstants.primaryButtonColor.withValues(alpha: 0.5);
                    break;
                  case 3:
                    boxColor = UiConstants.primaryButtonColor.withValues(alpha: 0.8);
                    break;
                  default:
                    boxColor = UiConstants.primaryButtonColor;
                }
                return Container(
                  width: 14 * sc,
                  height: 14 * sc,
                  margin: EdgeInsets.only(left: 4 * sc),
                  decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(3)),
                );
              }),
              SizedBox(width: 8 * sc),
              Text("More", style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 10 * sc)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCPMetricsGrid(UserEntity user, double sc) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            "Contests",
            user.attendedContestsCount.toString(),
            Icons.emoji_events_outlined,
            Colors.orange,
            sc,
          ),
        ),
        SizedBox(width: 12 * sc),
        Expanded(
          child: _buildMetricTile(
            "Global Rank",
            "#${user.globalRank.toString()}",
            Icons.public_outlined,
            Colors.blue,
            sc,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, IconData icon, Color color, double sc) {
    return Container(
      padding: EdgeInsets.all(14 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20 * sc),
          SizedBox(height: 8 * sc),
          Text(
            value,
            style: TextStyle(
              fontSize: 18 * sc,
              fontWeight: FontWeight.bold,
              color: UiConstants.mainTextColor,
            ),
          ),
          SizedBox(height: 4 * sc),
          Text(
            title,
            style: TextStyle(
              fontSize: 11 * sc,
              color: UiConstants.subtitleTextColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinksGrid(List<SocialLinkEntity> links, double sc) {
    if (links.isEmpty) {
      return Center(
        child: Text(
          "No social links added",
          style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 12 * sc),
        ),
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < links.length; i += 2) {
      final rowItems = <Widget>[];
      rowItems.add(Expanded(child: _buildSocialCard(links[i], sc)));

      if (i + 1 < links.length) {
        rowItems.add(SizedBox(width: 12 * sc));
        rowItems.add(Expanded(child: _buildSocialCard(links[i + 1], sc)));
      } else {
        rowItems.add(SizedBox(width: 12 * sc));
        rowItems.add(const Expanded(child: SizedBox.shrink()));
      }

      rows.add(Row(children: rowItems));
      if (i + 2 < links.length) {
        rows.add(SizedBox(height: 12 * sc));
      }
    }

    return Column(children: rows);
  }

  Widget _buildSocialCard(SocialLinkEntity link, double sc) {
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
      padding: EdgeInsets.symmetric(horizontal: 14 * sc, vertical: 12 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18 * sc),
          SizedBox(width: 12 * sc),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.platform,
                  style: TextStyle(fontSize: 10 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.7), fontWeight: FontWeight.w600),
                ),
                Text(
                  link.handle,
                  style: TextStyle(fontSize: 12 * sc, color: UiConstants.mainTextColor, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.open_in_new_rounded, size: 12 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.3)),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab(BuildContext context, ProfileState state, double sc) {
    if (state.isAttendanceLoading) {
      return _buildLoadingPlaceholder(sc);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Attendance Insights", sc),
        SizedBox(height: 12 * sc),
        _buildAttendanceSummary(state.attendanceData, sc),
        SizedBox(height: 24 * sc),
        _buildSectionTitle("Activity Grid", sc),
        SizedBox(height: 12 * sc),
        _buildEnhancedAttendanceGrid(context, state.attendanceData, sc),
      ],
    );
  }

  Widget _buildAttendanceSummary(List<AttendanceEntity> data, double sc) {
    final present = data.where((e) => e.status == 'Present').length;
    final missed = data.where((e) => e.status == 'Absent').length;

    int streak = 0;
    for (var i = data.length - 1; i >= 0; i--) {
      if (data[i].status == 'Present') {
        streak++;
      } else {
        break;
      }
    }

    return Container(
      padding: EdgeInsets.all(16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("Current Streak", "$streak Days", Icons.local_fire_department_rounded, Colors.orangeAccent.withValues(alpha: 0.8), sc),
          _buildSummaryVerticalDivider(sc),
          _buildSummaryItem("Total Present", "$present Days", Icons.event_available_rounded, UiConstants.primaryButtonColor.withValues(alpha: 0.8), sc),
          _buildSummaryVerticalDivider(sc),
          _buildSummaryItem("Missed", "$missed Days", Icons.event_busy_rounded, Colors.redAccent.withValues(alpha: 0.8), sc),
        ],
      ),
    );
  }

  Widget _buildSummaryVerticalDivider(double sc) {
    return Container(height: 32 * sc, width: 1, color: UiConstants.borderColor.withValues(alpha: 0.3));
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color, double sc) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20 * sc),
        SizedBox(height: 8 * sc),
        Text(value, style: TextStyle(fontSize: 14 * sc, fontWeight: FontWeight.bold, color: UiConstants.mainTextColor)),
        SizedBox(height: 2 * sc),
        Text(label, style: TextStyle(fontSize: 9 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.6))),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label, double sc) {
    return Row(
      children: [
        Container(
          width: 8 * sc,
          height: 8 * sc,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5),
          ),
        ),
        SizedBox(width: 6 * sc),
        Text(label, style: TextStyle(fontSize: 11 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.7), fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEnhancedAttendanceGrid(BuildContext context, List<AttendanceEntity> attendanceData, double sc) {
    final monthName = _getMonthName(_selectedDate.month);
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1).weekday;
    final paddingDays = firstDayOfMonth == 7 ? 0 : firstDayOfMonth;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.3)),
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
                    Text(
                      "$monthName ${_selectedDate.year}",
                      style: TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.bold, fontSize: 14 * sc),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Spring Semester",
                      style: TextStyle(fontSize: 9 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.6)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8 * sc),
              TextButton.icon(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_month_rounded, size: 14 * sc),
                label: Text("Select Date", style: TextStyle(fontSize: 12 * sc)),
                style: TextButton.styleFrom(
                  foregroundColor: UiConstants.primaryButtonColor,
                  backgroundColor: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
                  padding: EdgeInsets.symmetric(horizontal: 12 * sc, vertical: 8 * sc),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20 * sc),
          Wrap(
            spacing: 12 * sc,
            runSpacing: 8 * sc,
            children: [
              _buildLegendDot(UiConstants.primaryButtonColor, "Present", sc),
              _buildLegendDot(Colors.redAccent, "Absent", sc),
              _buildLegendDot(Colors.amberAccent, "Excused", sc),
            ],
          ),
          SizedBox(height: 24 * sc),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10 * sc,
              crossAxisSpacing: 10 * sc,
            ),
            itemCount: daysInMonth + paddingDays,
            itemBuilder: (context, index) {
              if (index < paddingDays) return const SizedBox.shrink();

              final dayIndex = index - paddingDays;
              final dayNumber = dayIndex + 1;

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
                  boxColor = UiConstants.primaryButtonColor.withValues(alpha: 0.15);
                  contentColor = UiConstants.primaryButtonColor;
                  border = Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3), width: 1);
                  break;
                case 'Absent':
                  boxColor = Colors.redAccent.withValues(alpha: 0.15);
                  contentColor = Colors.redAccent;
                  border = Border.all(color: Colors.redAccent.withValues(alpha: 0.3), width: 1);
                  break;
                case 'Excused':
                  boxColor = Colors.amberAccent.withValues(alpha: 0.15);
                  contentColor = Colors.amberAccent;
                  border = Border.all(color: Colors.amberAccent.withValues(alpha: 0.3), width: 1);
                  break;
                default:
                  boxColor = Colors.transparent;
                  contentColor = UiConstants.mainTextColor.withValues(alpha: 0.15);
                  border = Border.all(color: UiConstants.borderColor.withValues(alpha: 0.1), width: 1);
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
                      fontSize: 11 * sc,
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

  Widget _buildSubmissionsTab(ProfileState state, double sc) {
    if (state.isSubmissionsLoading) {
      return _buildLoadingPlaceholder(sc);
    }
    final submissions = state.submissionData;
    if (submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 48 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.3)),
            SizedBox(height: 16 * sc),
            Text("No recent submissions", style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 13 * sc)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Recent Submissions", sc),
        SizedBox(height: 16 * sc),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: submissions.length,
          itemBuilder: (context, index) {
            final submission = submissions[index];
            final isAccepted = submission.status.toLowerCase() == 'accepted';
            final statusColor = isAccepted ? Colors.greenAccent : Colors.redAccent;

            return Container(
              margin: EdgeInsets.only(bottom: 12 * sc),
              padding: EdgeInsets.all(14 * sc),
              decoration: BoxDecoration(
                color: UiConstants.infoBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8 * sc),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isAccepted ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                      color: statusColor,
                      size: 20 * sc,
                    ),
                  ),
                  SizedBox(width: 16 * sc),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          submission.problemTitle,
                          style: TextStyle(
                            fontSize: 14 * sc,
                            fontWeight: FontWeight.bold,
                            color: UiConstants.mainTextColor,
                          ),
                        ),
                        SizedBox(height: 4 * sc),
                        Wrap(
                          spacing: 8 * sc,
                          runSpacing: 4 * sc,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              submission.language,
                              style: TextStyle(
                                fontSize: 12 * sc,
                                color: UiConstants.subtitleTextColor.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              "•",
                              style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.3), fontSize: 12 * sc),
                            ),
                            Text(
                              submission.timestamp,
                              style: TextStyle(
                                fontSize: 12 * sc,
                                color: UiConstants.subtitleTextColor.withValues(alpha: 0.6),
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
                          fontSize: 13 * sc,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      SizedBox(height: 4 * sc),
                      Text(
                        submission.executionTime,
                        style: TextStyle(
                          fontSize: 10 * sc,
                          color: UiConstants.subtitleTextColor.withValues(alpha: 0.5),
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

  Widget _buildSettingsTab(double sc) {
    final currentSize = context.read<ThemeCubit>().state.size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Display Size", sc),
        SizedBox(height: 12 * sc),
        _buildSizeSelector(currentSize, sc),
        SizedBox(height: 24 * sc),
        _buildSettingsTile(Icons.manage_accounts_outlined, "Edit Profile", sc),
        _buildSettingsTile(Icons.notifications_active_outlined, "Notifications", sc),
        _buildSettingsTile(Icons.security_outlined, "Security & Password", sc),
        _buildSettingsTile(Icons.help_outline_rounded, "Help & Support", sc),
        _buildSettingsTile(Icons.logout_rounded, "Logout", sc, isDestructive: true),
      ],
    );
  }

  Widget _buildSizeSelector(AppThemeSize currentSize, double sc) {
    return Container(
      padding: EdgeInsets.all(16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields_rounded, color: UiConstants.primaryButtonColor, size: 18 * sc),
              SizedBox(width: 10 * sc),
              Text(
                "Choose your preferred display size",
                style: TextStyle(
                  color: UiConstants.subtitleTextColor.withValues(alpha: 0.7),
                  fontSize: 11 * sc,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16 * sc),
          Row(
            children: [
              _buildSizeOption("Small", AppThemeSize.small, currentSize, sc),
              SizedBox(width: 10 * sc),
              _buildSizeOption("Normal", AppThemeSize.normal, currentSize, sc),
              SizedBox(width: 10 * sc),
              _buildSizeOption("Large", AppThemeSize.large, currentSize, sc),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String label, AppThemeSize size, AppThemeSize currentSize, double sc) {
    final isSelected = currentSize == size;
    final sampleFontSize = size == AppThemeSize.small ? 11.0 : size == AppThemeSize.normal ? 13.0 : 15.0;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ThemeCubit>().setThemeSize(size);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(vertical: 14 * sc, horizontal: 8 * sc),
          decoration: BoxDecoration(
            color: isSelected
                ? UiConstants.primaryButtonColor.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? UiConstants.primaryButtonColor.withValues(alpha: 0.5)
                  : UiConstants.borderColor.withValues(alpha: 0.15),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                "Aa",
                style: TextStyle(
                  fontSize: sampleFontSize * sc,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? UiConstants.primaryButtonColor : UiConstants.mainTextColor,
                ),
              ),
              SizedBox(height: 6 * sc),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11 * sc,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  color: isSelected
                      ? UiConstants.primaryButtonColor
                      : UiConstants.subtitleTextColor.withValues(alpha: 0.7),
                ),
              ),
              if (isSelected)
                Container(
                  margin: EdgeInsets.only(top: 6 * sc),
                  width: 20 * sc,
                  height: 3 * sc,
                  decoration: BoxDecoration(
                    color: UiConstants.primaryButtonColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, double sc, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.redAccent : UiConstants.mainTextColor;
    return Container(
      margin: EdgeInsets.only(bottom: 12 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color.withValues(alpha: 0.8), size: 20 * sc),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 14 * sc)),
        trailing: Icon(Icons.chevron_right_rounded, color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), size: 20 * sc),
        onTap: () {},
      ),
    );
  }

  Widget _buildSectionTitle(String title, double sc) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16 * sc,
        fontWeight: FontWeight.bold,
        color: UiConstants.mainTextColor,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, double sc) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: UiConstants.primaryButtonColor, size: 18 * sc),
              SizedBox(width: 8 * sc),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14 * sc,
                  fontWeight: FontWeight.bold,
                  color: UiConstants.mainTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10 * sc),
          Text(
            content,
            style: TextStyle(
              fontSize: 13 * sc,
              color: UiConstants.subtitleTextColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
