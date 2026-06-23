import '../../model/contest_model.dart';

abstract class MockContestsDataSource {
  Future<List<ContestModel>> getContests();
}

class MockContestsDataSourceImpl implements MockContestsDataSource {
  @override
  Future<List<ContestModel>> getContests() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Times are generated relative to "now" so the page always has a live
    // contest, a few upcoming ones (one imminent → red countdown), and a
    // finished one — no matter when the app is run.
    final now = DateTime.now().toUtc();
    String at(Duration offset) =>
        now.add(offset).toIso8601String();

    return [
      // ── Live now: started 25 min ago, 2h long → ~95 min left ───────────
      ContestModel(
        id: 'cpd-live-1',
        title: 'Weekly Coding Challenge — Live Round',
        contestUrl: 'https://example.com/contests/live',
        startTime: at(const Duration(minutes: -25)),
        duration: '02:00:00',
        platform: 'CPD Hub',
        numberOfProblems: 6,
        isPast: false,
        isParticipating: true,
      ),
      // ── Imminent: starts in ~6 min → countdown goes red + pulses ───────
      ContestModel(
        id: 'cf-round-1',
        title: 'Codeforces Round (Div. 2)',
        contestUrl: 'https://example.com/contests/cf',
        startTime: at(const Duration(minutes: 6, seconds: 40)),
        duration: '02:15:00',
        platform: 'Codeforces',
        numberOfProblems: 6,
        isPast: false,
        isParticipating: true,
      ),
      // ── Soon: starts in ~3h 20m → amber countdown ──────────────────────
      ContestModel(
        id: 'lc-weekly-1',
        title: 'LeetCode Weekly Contest 420',
        contestUrl: 'https://example.com/contests/lc',
        startTime: at(const Duration(hours: 3, minutes: 20)),
        duration: '01:30:00',
        platform: 'LeetCode',
        numberOfProblems: 4,
        isPast: false,
        isParticipating: false,
      ),
      // ── Far: starts in ~2 days → green countdown with a DAYS segment ────
      ContestModel(
        id: 'ac-beginner-1',
        title: 'AtCoder Beginner Contest',
        contestUrl: 'https://example.com/contests/ac',
        startTime: at(const Duration(days: 2, hours: 4)),
        duration: '01:40:00',
        platform: 'AtCoder',
        numberOfProblems: 7,
        isPast: false,
        isParticipating: false,
      ),
      // ── Finished: started 3 days ago ───────────────────────────────────
      ContestModel(
        id: 'cpd-weekly-prev',
        title: 'Weekly Coding Challenge — Previous',
        contestUrl: 'https://example.com/contests/prev',
        startTime: at(const Duration(days: -3)),
        duration: '02:00:00',
        platform: 'CPD Hub',
        numberOfProblems: 5,
        isPast: true,
        isParticipating: true,
      ),
    ];
  }
}
