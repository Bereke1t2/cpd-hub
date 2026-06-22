import '../../models/course_model.dart';
import '../courses_data_source.dart';

class MockCoursesDataSource implements CoursesDataSource {
  // In-memory progress. Persists for the app session.
  final Set<String> _completed = {};

  // ── Raw course catalogue ──────────────────────────────────────────────────
  static const _catalogue = [_graphCourse, _dpCourse];

  @override
  Future<List<CourseModel>> getCourses() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _catalogue
        .map((c) => CourseModel.fromJson(c, _completed))
        .toList();
  }

  @override
  Future<CourseModel> getCourseDetail(String courseId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final raw = _catalogue.firstWhere((c) => c['id'] == courseId,
        orElse: () => throw Exception('Course not found: $courseId'));
    return CourseModel.fromJson(raw, _completed);
  }

  @override
  Future<void> markLessonComplete(String courseId, String lessonId) async {
    _completed.add(lessonId);
  }
}

// ── Sample course data ────────────────────────────────────────────────────────

const _graphCourse = {
  'id': 'graphs-101',
  'title': 'Graph Algorithms',
  'summary': 'Master BFS, DFS, shortest paths and spanning trees.',
  'level': 'Intermediate',
  'modules': [
    {
      'id': 'm1',
      'title': 'Graph Traversal',
      'lessons': [
        {
          'id': 'l1',
          'title': 'Breadth-First Search',
          'kind': 'video',
          'contentUrl':
              'https://www.youtube.com/watch?v=pcKY4hjDrxk',
          'durationSec': 540,
        },
        {
          'id': 'l2',
          'title': 'Depth-First Search',
          'kind': 'article',
          'contentUrl': '',
          'inlineText': '''# Depth-First Search

DFS explores as far as possible along each branch before backtracking.

## Key Properties
- Time complexity: **O(V + E)**
- Space complexity: **O(V)** for the call stack
- Finds connected components, topological order, cycle detection

## Implementation

```dart
void dfs(int node, List<List<int>> adj, List<bool> visited) {
  visited[node] = true;
  for (final neighbor in adj[node]) {
    if (!visited[neighbor]) dfs(neighbor, adj, visited);
  }
}
```

## Common Applications
1. Topological sort (DAG scheduling)
2. Strongly connected components (Tarjan / Kosaraju)
3. Maze solving
4. Finding articulation points and bridges
''',
        },
        {
          'id': 'l3',
          'title': 'Graph Cheat Sheet (PDF)',
          'kind': 'pdf',
          'contentUrl':
              'https://web.stanford.edu/class/cs97si/06-basic-graph-algorithms.pdf',
        },
      ],
    },
    {
      'id': 'm2',
      'title': 'Shortest Paths',
      'lessons': [
        {
          'id': 'l4',
          'title': "Dijkstra's Algorithm",
          'kind': 'video',
          'contentUrl':
              'https://www.youtube.com/watch?v=pcKY4hjDrxk',
          'durationSec': 720,
        },
        {
          'id': 'l5',
          'title': 'Bellman-Ford & SPFA',
          'kind': 'article',
          'contentUrl': '',
          'inlineText': '''# Bellman-Ford Algorithm

Handles **negative weight edges** (unlike Dijkstra). Detects negative cycles.

## Complexity
- Time: **O(V × E)**
- Space: **O(V)**

## When to use
- Graph has negative edge weights
- Need to detect negative cycles

```dart
List<int> bellmanFord(int src, int V, List<(int,int,int)> edges) {
  final dist = List.filled(V, 1 << 30);
  dist[src] = 0;
  for (int i = 0; i < V - 1; i++) {
    for (final (u, v, w) in edges) {
      if (dist[u] + w < dist[v]) dist[v] = dist[u] + w;
    }
  }
  return dist;
}
```
''',
        },
      ],
    },
    {
      'id': 'm3',
      'title': 'Spanning Trees',
      'lessons': [
        {
          'id': 'l6',
          'title': "Kruskal's MST",
          'kind': 'article',
          'contentUrl': '',
          'inlineText': '''# Minimum Spanning Tree — Kruskal's

Sort all edges by weight, greedily pick the smallest edge that doesn't form a cycle.

Uses **Union-Find (DSU)** for cycle detection.

## Complexity
- **O(E log E)** dominated by sorting

```dart
// Sort edges, union-find to detect cycles
edges.sort((a, b) => a.weight.compareTo(b.weight));
for (final e in edges) {
  if (find(e.u) != find(e.v)) { union(e.u, e.v); mst.add(e); }
}
```
''',
        },
      ],
    },
  ],
};

const _dpCourse = {
  'id': 'dp-101',
  'title': 'Dynamic Programming',
  'summary': 'From memoization to tabulation — crack the DP mindset.',
  'level': 'Advanced',
  'modules': [
    {
      'id': 'dp-m1',
      'title': 'DP Fundamentals',
      'lessons': [
        {
          'id': 'dp-l1',
          'title': 'What is Dynamic Programming?',
          'kind': 'article',
          'contentUrl': '',
          'inlineText': '''# Dynamic Programming

DP solves problems by breaking them into overlapping sub-problems and storing results.

## Two approaches
1. **Top-down (memoization)**: Recursive + cache
2. **Bottom-up (tabulation)**: Iterative + table

## Classic example — Fibonacci

```dart
// Top-down
final Map<int,int> memo = {};
int fib(int n) => n <= 1 ? n : memo.putIfAbsent(n, () => fib(n-1) + fib(n-2));

// Bottom-up
int fib(int n) {
  final dp = List.filled(n + 1, 0)..[1] = 1;
  for (int i = 2; i <= n; i++) dp[i] = dp[i-1] + dp[i-2];
  return dp[n];
}
```
''',
        },
        {
          'id': 'dp-l2',
          'title': 'Longest Common Subsequence',
          'kind': 'video',
          'contentUrl':
              'https://www.youtube.com/watch?v=oBt53YbR9Kk',
          'durationSec': 480,
        },
      ],
    },
    {
      'id': 'dp-m2',
      'title': 'Classic DP Patterns',
      'lessons': [
        {
          'id': 'dp-l3',
          'title': 'Knapsack Problem',
          'kind': 'article',
          'contentUrl': '',
          'inlineText': '''# 0/1 Knapsack

Given items with weight and value, maximize value within a weight limit.

```dart
int knapsack(int W, List<int> wt, List<int> val, int n) {
  final dp = List.generate(n+1, (_) => List.filled(W+1, 0));
  for (int i = 1; i <= n; i++) {
    for (int w = 0; w <= W; w++) {
      dp[i][w] = dp[i-1][w];
      if (wt[i-1] <= w)
        dp[i][w] = max(dp[i][w], dp[i-1][w - wt[i-1]] + val[i-1]);
    }
  }
  return dp[n][W];
}
```
''',
        },
        {
          'id': 'dp-l4',
          'title': 'DP Patterns Cheat Sheet',
          'kind': 'pdf',
          'contentUrl':
              'https://www.cs.princeton.edu/courses/archive/spring05/cos423/lectures/03dynamic-programming.pdf',
        },
      ],
    },
  ],
};
