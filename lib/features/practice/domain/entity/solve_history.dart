/// Snapshot of a user's solve activity. Pure value class — no Equatable needed.
/// Passed into StrengthAnalyzer and Recommender. Extend with tryCount and
/// timestamps once the backend tracks them.
class SolveHistory {
  /// All problem ids the user has successfully solved.
  final Set<String> solvedProblemIds;

  const SolveHistory({required this.solvedProblemIds});

  factory SolveHistory.empty() => const SolveHistory(solvedProblemIds: {});

  bool hasSolved(String problemId) => solvedProblemIds.contains(problemId);
  int get totalSolved => solvedProblemIds.length;
}
