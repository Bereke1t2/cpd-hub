import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/learning/roadmap_models.dart';

part 'roadmap_state.dart';

/// Loads curriculum paths and tracks module completion (replace [seedRoadmaps] with API later).
class RoadmapCubit extends Cubit<RoadmapState> {
  RoadmapCubit() : super(const RoadmapState());

  void loadMockCurriculum() {
    emit(state.copyWith(roadmaps: seedRoadmaps));
  }

  void selectRoadmap(String roadmapId) {
    emit(state.copyWith(selectedRoadmapId: roadmapId));
  }

  void toggleModuleComplete(String moduleId) {
    final next = Set<String>.from(state.completedModuleIds);
    if (next.contains(moduleId)) {
      next.remove(moduleId);
    } else {
      next.add(moduleId);
    }
    emit(state.copyWith(completedModuleIds: next));
  }

  void markModuleComplete(String moduleId) {
    if (state.completedModuleIds.contains(moduleId)) {
      return;
    }
    final next = Set<String>.from(state.completedModuleIds)..add(moduleId);
    emit(state.copyWith(completedModuleIds: next));
  }

  void toggleProblemSolved(String problemId) {
    final next = Set<String>.from(state.completedProblemIds);
    if (next.contains(problemId)) {
      next.remove(problemId);
    } else {
      next.add(problemId);
    }
    emit(state.copyWith(completedProblemIds: next));
  }

  static final List<RoadmapPath> seedRoadmaps = [
    RoadmapPath(
      roadmapId: 'beginner_specialist',
      title: 'Beginner → Specialist',
      difficultyLevel: 'Mixed',
      description: 'Classic CPD path: number theory, two pointers, graphs, then trees.',
      modules: [
        RoadmapModule(
          moduleId: 'mod_sieve',
          title: 'Sieve of Eratosthenes',
          summaryLine: 'Primes, divisibility, multiplicative functions',
          markdownContent: '''
## Sieve of Eratosthenes

Generate primes up to **n** in **O(n log log n)** time.

1. Mark multiples of each prime starting from p².
2. Use a boolean array `isPrime[i]`.

### When to use
- Counting primes in a range
- Factoring small numbers in bulk

> **Tip:** For very large n, consider segmented sieve.
''',
          videoUrl: 'https://www.youtube.com/watch?v=lSZQeZbIGMs',
          linkedProblems: const [
            PracticeProblemRef(problemId: 'p_sieve_1', title: 'Count Primes', difficulty: 'Easy', tags: ['Math', 'Sieve']),
            PracticeProblemRef(problemId: 'p_sieve_2', title: 'Closest Prime Pair', difficulty: 'Medium', tags: ['Math']),
            PracticeProblemRef(problemId: 'p_sieve_3', title: 'Euler Totient Warmup', difficulty: 'Medium', tags: ['Math']),
          ],
        ),
        RoadmapModule(
          moduleId: 'mod_segtree',
          title: 'Segment Trees',
          summaryLine: 'Range queries and lazy propagation',
          markdownContent: '''
## Segment tree basics

A **binary tree** over an array supporting:

- Point update **O(log n)**
- Range query (sum / min / max) **O(log n)**

### Lazy propagation
Defer updates to children until their segments are needed — essential for **range add + range sum**.

Practice implementing **push** and **pull** on paper before coding.
''',
          videoUrl: 'https://www.youtube.com/watch?v=ZBHKZF6w4TI',
          linkedProblems: const [
            PracticeProblemRef(problemId: 'p_seg_1', title: 'Range Sum Query — Mutable', difficulty: 'Medium', tags: ['DS', 'Segtree']),
            PracticeProblemRef(problemId: 'p_seg_2', title: 'Falling Squares', difficulty: 'Hard', tags: ['Segtree']),
          ],
        ),
        RoadmapModule(
          moduleId: 'mod_dijkstra',
          title: 'Dijkstra Shortest Path',
          summaryLine: 'Non-negative edges, priority queue',
          markdownContent: '''
## Dijkstra

- Greedy relaxation using a **min-priority queue** (by distance).
- Only valid when edge weights **≥ 0**.

### Complexity
**O((V + E) log V)** with a binary heap.

Pair with **parent array** to reconstruct paths.
''',
          videoUrl: 'https://www.youtube.com/watch?v=pSqmQmiR8xk',
          linkedProblems: const [
            PracticeProblemRef(problemId: 'p_dij_1', title: 'Network Delay Time', difficulty: 'Medium', tags: ['Graphs']),
            PracticeProblemRef(problemId: 'p_dij_2', title: 'Path With Minimum Effort', difficulty: 'Medium', tags: ['Graphs']),
          ],
        ),
      ],
    ),
    RoadmapPath(
      roadmapId: 'dp_masterclass',
      title: 'Dynamic Programming Masterclass',
      difficultyLevel: 'Intermediate+',
      description: 'Knapsack, grids, intervals, digit DP foundations.',
      modules: [
        RoadmapModule(
          moduleId: 'mod_knapsack',
          title: '0/1 Knapsack & variants',
          summaryLine: 'Classic DP on capacity',
          markdownContent: '''
## 0/1 Knapsack

State: `dp[i][w]` = max value using first `i` items with weight ≤ `w`.

Space-optimized: **1D DP** iterating capacity **backwards**.

### Variants
- Count subsets with sum W
- Minimize number of items for target sum
''',
          videoUrl: 'https://www.youtube.com/watch?v=8LusJS5-AGo',
          linkedProblems: const [
            PracticeProblemRef(problemId: 'p_dp_1', title: 'Partition Equal Subset Sum', difficulty: 'Medium', tags: ['DP']),
            PracticeProblemRef(problemId: 'p_dp_2', title: 'Target Sum', difficulty: 'Medium', tags: ['DP']),
          ],
        ),
      ],
    ),
  ];
}
