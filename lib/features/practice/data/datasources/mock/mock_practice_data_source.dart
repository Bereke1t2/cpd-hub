import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/review_item_model.dart';
import '../../models/upsolve_item_model.dart';
import '../practice_data_source.dart';

const _kReviewQueue = 'practice_review_queue_v1';
const _kUpsolves = 'practice_upsolves_v1';

class MockPracticeDataSource implements PracticeDataSource {
  final SharedPreferences _prefs;
  MockPracticeDataSource(this._prefs);

  // ── Review queue ─────────────────────────────────────────────────────────

  @override
  Future<List<ReviewItemModel>> getReviewQueue() async {
    final raw = _prefs.getString(_kReviewQueue);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => ReviewItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveReviewItem(ReviewItemModel item) async {
    final queue = await getReviewQueue();
    final idx = queue.indexWhere((i) => i.problemId == item.problemId);
    if (idx >= 0) {
      queue[idx] = item;
    } else {
      queue.add(item);
    }
    await _persist(queue);
  }

  @override
  Future<void> addToReview(ReviewItemModel item) => saveReviewItem(item);

  @override
  Future<void> removeFromReview(String problemId) async {
    final queue = await getReviewQueue();
    queue.removeWhere((i) => i.problemId == problemId);
    await _persist(queue);
  }

  Future<void> _persist(List<ReviewItemModel> queue) async {
    await _prefs.setString(
      _kReviewQueue,
      jsonEncode(queue.map((i) => i.toJson()).toList()),
    );
  }

  // ── Upsolves ─────────────────────────────────────────────────────────────

  @override
  Future<List<UpsolveItemModel>> getUpsolves() async {
    final raw = _prefs.getString(_kUpsolves);
    if (raw == null) return _defaultUpsolves;
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => UpsolveItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _defaultUpsolves;
    }
  }

  @override
  Future<void> saveUpsolve(UpsolveItemModel item) async {
    final upsolves = await getUpsolves();
    final idx = upsolves.indexWhere(
        (u) => u.contestId == item.contestId && u.problemId == item.problemId);
    if (idx >= 0) {
      upsolves[idx] = item;
    } else {
      upsolves.add(item);
    }
    await _persistUpsolves(upsolves);
  }

  @override
  Future<void> addUpsolve(UpsolveItemModel item) => saveUpsolve(item);

  Future<void> _persistUpsolves(List<UpsolveItemModel> items) async {
    await _prefs.setString(
      _kUpsolves,
      jsonEncode(items.map((i) => i.toJson()).toList()),
    );
  }
}

// Default seed: two unsolved problems from a past contest.
// Replace with real contest+leaderboard data once the backend is live.
const _defaultUpsolves = <UpsolveItemModel>[
  UpsolveItemModel(
    contestId: 'weekly-1',
    contestTitle: 'Weekly Challenge #1',
    problemId: 'merge-k-lists',
    problemTitle: 'Merge k Sorted Lists',
    resolved: false,
  ),
  UpsolveItemModel(
    contestId: 'weekly-1',
    contestTitle: 'Weekly Challenge #1',
    problemId: 'median-two-sorted-arrays',
    problemTitle: 'Median of Two Sorted Arrays',
    resolved: false,
  ),
];
