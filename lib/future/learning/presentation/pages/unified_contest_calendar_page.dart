import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cpd_hub/core/contest_reminder_service.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/bloc/contest_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';

class _ExternalEvent {
  final String platform;
  final String title;
  final DateTime startUtc;
  final String url;

  const _ExternalEvent(this.platform, this.title, this.startUtc, this.url);
}

/// CLIST-style rows (mock) merged with CPD Hub contests from [ContestCubit].
class UnifiedContestCalendarPage extends StatefulWidget {
  const UnifiedContestCalendarPage({super.key});

  @override
  State<UnifiedContestCalendarPage> createState() => _UnifiedContestCalendarPageState();
}

class _UnifiedContestCalendarPageState extends State<UnifiedContestCalendarPage> {
  final Set<String> _reminderScheduled = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ContestCubit>().loadContests();
    });
  }

  static final List<_ExternalEvent> _clistMock = [
    _ExternalEvent(
      'Codeforces',
      'Div. 2 (mock)',
      DateTime.now().toUtc().add(const Duration(days: 1, hours: 3)),
      'https://codeforces.com/contests',
    ),
    _ExternalEvent(
      'LeetCode',
      'Biweekly (mock)',
      DateTime.now().toUtc().add(const Duration(days: 2, hours: 8)),
      'https://leetcode.com/contest/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;

    return BasePage(
      showBackButton: true,
      selectedIndex: 0,
      title: 'Contest calendar',
      subtitle: 'External + CPD Hub',
      body: BlocBuilder<ContestCubit, ContestState>(
        builder: (context, contestState) {
          final cpdContests = contestState is ContestLoaded ? contestState.contests : <dynamic>[];

          return ListView(
            padding: EdgeInsets.fromLTRB(16 * sc, 8 * sc, 16 * sc, 100 * sc),
            children: [
              Text(
                'CPD Hub contests (live from API)',
                style: TextStyle(
                  color: UiConstants.subtitleTextColor.withValues(alpha: 0.75),
                  fontSize: 11 * sc,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 8 * sc),
              if (cpdContests.isEmpty)
                Text('No contests loaded — open Contests tab once or pull to refresh when wired.', style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc))
              else
                ...cpdContests.take(8).map((c) {
                  final id = 'cpd_${c.id}';
                  final start = DateTime.tryParse(c.startTime) ?? DateTime.now().add(const Duration(hours: 4));
                  return _eventTile(
                    context,
                    sc,
                    id: id,
                    platform: 'CPD Hub',
                    title: c.title,
                    start: start,
                    url: c.contestUrl.isNotEmpty ? c.contestUrl : 'https://example.com',
                  );
                }),
              SizedBox(height: 20 * sc),
              Text(
                'Global platforms (mock CLIST)',
                style: TextStyle(
                  color: UiConstants.subtitleTextColor.withValues(alpha: 0.75),
                  fontSize: 11 * sc,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 8 * sc),
              ..._clistMock.map((e) {
                final id = 'ext_${e.title.hashCode}';
                return _eventTile(
                  context,
                  sc,
                  id: id,
                  platform: e.platform,
                  title: e.title,
                  start: e.startUtc.toLocal(),
                  url: e.url,
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _eventTile(
    BuildContext context,
    double sc, {
    required String id,
    required String platform,
    required String title,
    required DateTime start,
    required String url,
  }) {
    final reminded = _reminderScheduled.contains(id);
    return Container(
      margin: EdgeInsets.only(bottom: 10 * sc),
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
            children: [
              Text(platform, style: TextStyle(color: UiConstants.primaryButtonColor, fontWeight: FontWeight.w800, fontSize: 12 * sc)),
              const Spacer(),
              Text(_fmt(start), style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11 * sc)),
            ],
          ),
          SizedBox(height: 6 * sc),
          Text(title, style: TextStyle(color: UiConstants.mainTextColor, fontSize: 15 * sc, fontWeight: FontWeight.w800)),
          SizedBox(height: 12 * sc),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final u = Uri.parse(url);
                    if (await canLaunchUrl(u)) {
                      await launchUrl(u, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('Direct link'),
                ),
              ),
              SizedBox(width: 8 * sc),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: reminded
                      ? null
                      : () async {
                          final nid = id.hashCode.abs() % 2000000000;
                          final ok = await ContestReminderService.instance.scheduleContestReminder(
                            notificationId: nid,
                            contestStart: start,
                            contestTitle: title,
                            contestUrl: url,
                          );
                          if (!context.mounted) {
                            return;
                          }
                          if (ok) {
                            setState(() => _reminderScheduled.add(id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reminder 15 min before start scheduled')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contest too soon — pick a later event')),
                            );
                          }
                        },
                  child: Text(reminded ? 'Reminded' : 'Remind me'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) {
    final local = d.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
