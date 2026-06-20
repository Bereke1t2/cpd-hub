import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entity/goal_entity.dart';
import '../../../domain/entity/streak_entity.dart';
import '../../models/goal_model.dart';
import '../../models/ladder_model.dart';
import '../../models/streak_model.dart';
import '../consistency_data_source.dart';

// SharedPreferences keys
const _kStreak = 'consistency_streak_v1';
const _kGoal = 'consistency_goal_v1';
const _kLadderPrefix = 'consistency_ladder_v1_';

class MockConsistencyDataSource implements ConsistencyDataSource {
  final SharedPreferences _prefs;
  MockConsistencyDataSource(this._prefs);

  // ── Streak ────────────────────────────────────────────────────────────────

  @override
  Future<StreakModel> getStreak() async {
    final raw = _prefs.getString(_kStreak);
    if (raw == null) return StreakModel.fromEntity(StreakEntity.empty());
    try {
      return StreakModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return StreakModel.fromEntity(StreakEntity.empty());
    }
  }

  @override
  Future<void> saveStreak(StreakModel streak) async {
    await _prefs.setString(_kStreak, jsonEncode(streak.toJson()));
  }

  // ── Goal ──────────────────────────────────────────────────────────────────

  @override
  Future<GoalModel> getGoal() async {
    final raw = _prefs.getString(_kGoal);
    if (raw == null) return GoalModel.fromEntity(_defaultGoal());
    try {
      final saved = GoalModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      // Auto-reset if current period has expired (> 7 days old).
      final now = DateTime.now();
      final age = now.difference(saved.periodStart).inDays;
      if (age >= 7) return _resetGoal(saved);
      return saved;
    } catch (_) {
      return GoalModel.fromEntity(_defaultGoal());
    }
  }

  @override
  Future<void> saveGoal(GoalModel goal) async {
    await _prefs.setString(_kGoal, jsonEncode(goal.toJson()));
  }

  // ── Ladders ───────────────────────────────────────────────────────────────

  @override
  Future<List<LadderModel>> getLadders() async => _defaultLadders;

  @override
  Future<LadderModel?> getSavedLadder(String ladderId) async {
    final raw = _prefs.getString('$_kLadderPrefix$ladderId');
    if (raw == null) return null;
    try {
      return LadderModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLadder(LadderModel ladder) async {
    await _prefs.setString(
        '$_kLadderPrefix${ladder.id}', jsonEncode(ladder.toJson()));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  GoalModel _resetGoal(GoalModel old) {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    return GoalModel(
      id: old.id,
      type: old.type,
      target: old.target,
      progress: 0,
      periodStart: monday,
    );
  }

  GoalModel _defaultGoal() => GoalModel.fromEntity(
        GoalEntity.defaultGoal(),
      );
}

// ---------------------------------------------------------------------------
// Default ladders — rating-ordered problem queues using existing mock ids.
// ---------------------------------------------------------------------------
const _defaultLadders = <LadderModel>[
  LadderModel(
    id: 'beginner',
    title: 'Beginner Climb: 800 → 1200',
    fromRating: 800,
    toRating: 1200,
    rungs: [
      LadderRungModel(
        problemId: 'two-sum',
        rating: 800,
        solved: false,
        topicId: 'basics',
      ),
      LadderRungModel(
        problemId: 'valid-parentheses',
        rating: 900,
        solved: false,
        topicId: 'stacks-queues',
      ),
      LadderRungModel(
        problemId: 'search-rotated',
        rating: 1100,
        solved: false,
        topicId: 'binary-search',
      ),
      LadderRungModel(
        problemId: 'longest-substring',
        rating: 1200,
        solved: false,
        topicId: 'strings-intro',
      ),
    ],
  ),
  LadderModel(
    id: 'intermediate',
    title: 'Intermediate Climb: 1200 → 1600',
    fromRating: 1200,
    toRating: 1600,
    rungs: [
      LadderRungModel(
        problemId: 'median-two-sorted-arrays',
        rating: 1300,
        solved: false,
        topicId: 'binary-search',
      ),
      LadderRungModel(
        problemId: 'merge-k-lists',
        rating: 1500,
        solved: false,
        topicId: 'stacks-queues',
      ),
    ],
  ),
];

