import '../learning_data_source.dart';
import '../../../domain/entity/lesson_entity.dart';
import '../../models/lesson_model.dart';
import '../../models/topic_model.dart';
import '../../models/track_model.dart';

class MockLearningDataSource implements LearningDataSource {
  @override
  Future<List<TopicModel>> getTopics() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _topics;
  }

  @override
  Future<List<TrackModel>> getTracks() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _tracks;
  }

  @override
  Future<LessonModel?> getLesson(String topicId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _lessons[topicId];
  }
}

// ---------------------------------------------------------------------------
// Topic graph — a real CP curriculum as a DAG.
// prerequisiteIds defines "learn X before this".
// problemIds map into existing MockProblemsDataSource ids.
// ---------------------------------------------------------------------------
const _topics = <TopicModel>[
  // ── FOUNDATIONS ─────────────────────────────────────────────────────────
  TopicModel(
    id: 'basics',
    name: 'Programming Basics',
    category: 'Foundations',
    summary:
        'Variables, loops, conditionals, functions, and I/O. The ground everything else stands on.',
    difficulty: 1,
    prerequisiteIds: [],
    problemIds: ['two-sum', 'valid-parentheses'],
    referenceUrls: ['https://cp-algorithms.com/'],
  ),
  TopicModel(
    id: 'complexity',
    name: 'Time & Space Complexity',
    category: 'Foundations',
    summary:
        'Big-O notation: how to reason about algorithm speed and memory before you write a line of code.',
    difficulty: 1,
    prerequisiteIds: ['basics'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/'],
  ),

  // ── SEARCHING & SORTING ──────────────────────────────────────────────────
  TopicModel(
    id: 'sorting',
    name: 'Sorting',
    category: 'Searching & Sorting',
    summary:
        'Comparison sorts (merge, quick) and non-comparison sorts (counting, radix). Why order matters.',
    difficulty: 1,
    prerequisiteIds: ['basics'],
    problemIds: ['two-sum'],
    referenceUrls: ['https://cp-algorithms.com/algebra/sorting.html'],
  ),
  TopicModel(
    id: 'binary-search',
    name: 'Binary Search',
    category: 'Searching & Sorting',
    summary:
        'Halve the search space on every step. Works on any monotonic predicate, not just sorted arrays.',
    difficulty: 2,
    prerequisiteIds: ['sorting'],
    problemIds: ['median-two-sorted-arrays', 'search-rotated'],
    referenceUrls: ['https://cp-algorithms.com/num_methods/binary_search.html'],
  ),
  TopicModel(
    id: 'two-pointers',
    name: 'Two Pointers',
    category: 'Searching & Sorting',
    summary:
        'Shrink a window from both ends to avoid O(n²). Classic for pair-sum, palindrome, and merge problems.',
    difficulty: 2,
    prerequisiteIds: ['sorting'],
    problemIds: ['two-sum'],
    referenceUrls: ['https://cp-algorithms.com/'],
  ),
  TopicModel(
    id: 'bs-on-answer',
    name: 'Binary Search on Answer',
    category: 'Searching & Sorting',
    summary:
        'Binary-search on the answer space instead of the array. Turns minimise/maximise problems into feasibility checks.',
    difficulty: 3,
    prerequisiteIds: ['binary-search'],
    problemIds: ['search-rotated'],
    referenceUrls: ['https://usaco.guide/silver/binary-search'],
  ),

  // ── DATA STRUCTURES ──────────────────────────────────────────────────────
  TopicModel(
    id: 'prefix-sums',
    name: 'Prefix Sums',
    category: 'Data Structures',
    summary:
        'Pre-compute cumulative sums to answer range queries in O(1). Extends to 2-D and difference arrays.',
    difficulty: 2,
    prerequisiteIds: ['basics'],
    problemIds: ['two-sum'],
    referenceUrls: ['https://usaco.guide/silver/prefix-sums'],
  ),
  TopicModel(
    id: 'stacks-queues',
    name: 'Stacks & Queues',
    category: 'Data Structures',
    summary:
        'LIFO/FIFO abstractions. Monotonic stacks solve next-greater-element in O(n); deques power sliding-window maximum.',
    difficulty: 2,
    prerequisiteIds: ['basics'],
    problemIds: ['valid-parentheses'],
    referenceUrls: ['https://cp-algorithms.com/'],
  ),
  TopicModel(
    id: 'segment-tree',
    name: 'Segment Tree',
    category: 'Data Structures',
    summary:
        'Range queries and point updates in O(log n). The Swiss Army knife of competitive programming.',
    difficulty: 4,
    prerequisiteIds: ['prefix-sums', 'binary-search'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/data_structures/segment_tree.html'],
  ),
  TopicModel(
    id: 'dsu',
    name: 'Disjoint Set Union (DSU)',
    category: 'Data Structures',
    summary:
        'Union-Find with path compression and union by rank. Tracks connected components in near O(1) per query.',
    difficulty: 3,
    prerequisiteIds: ['basics'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/data_structures/disjoint_set_union.html'],
  ),

  // ── GRAPHS ───────────────────────────────────────────────────────────────
  TopicModel(
    id: 'graphs-intro',
    name: 'Graph Basics',
    category: 'Graphs',
    summary:
        'Adjacency list/matrix, BFS, DFS. The language every graph problem is written in.',
    difficulty: 2,
    prerequisiteIds: ['stacks-queues'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/graph/breadth-first-search.html'],
  ),
  TopicModel(
    id: 'shortest-paths',
    name: 'Shortest Paths',
    category: 'Graphs',
    summary:
        "Dijkstra (non-negative weights), Bellman-Ford (negative edges), Floyd-Warshall (all-pairs). Know when to use which.",
    difficulty: 3,
    prerequisiteIds: ['graphs-intro'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/graph/dijkstra.html'],
  ),
  TopicModel(
    id: 'topo-sort',
    name: 'Topological Sort',
    category: 'Graphs',
    summary:
        'Order nodes of a DAG so every edge goes forward. Required for DP on DAGs and scheduling problems.',
    difficulty: 3,
    prerequisiteIds: ['graphs-intro'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/graph/topological-sort.html'],
  ),
  TopicModel(
    id: 'mst',
    name: 'Minimum Spanning Tree',
    category: 'Graphs',
    summary:
        "Kruskal's (DSU + sort edges) and Prim's (priority queue). Builds cheapest connected subgraph.",
    difficulty: 3,
    prerequisiteIds: ['graphs-intro', 'dsu'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/graph/mst_kruskal.html'],
  ),

  // ── GREEDY & MATH ────────────────────────────────────────────────────────
  TopicModel(
    id: 'greedy',
    name: 'Greedy',
    category: 'Greedy & Math',
    summary:
        'Make the locally optimal choice at each step. Hard to prove correct, easy to implement. Exchange argument is the proof technique.',
    difficulty: 2,
    prerequisiteIds: ['sorting'],
    problemIds: ['median-two-sorted-arrays'],
    referenceUrls: ['https://usaco.guide/bronze/greedy-intro'],
  ),
  TopicModel(
    id: 'math-basics',
    name: 'Number Theory Basics',
    category: 'Greedy & Math',
    summary:
        'GCD/LCM (Euclidean), primality, Sieve of Eratosthenes. Appears in every third problem.',
    difficulty: 2,
    prerequisiteIds: ['basics'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/algebra/euclid-algorithm.html'],
  ),
  TopicModel(
    id: 'modular-arithmetic',
    name: 'Modular Arithmetic',
    category: 'Greedy & Math',
    summary:
        'Modular inverse (Fermat + extended Euclid), fast exponentiation. Required for combinatorics under a prime modulus.',
    difficulty: 3,
    prerequisiteIds: ['math-basics'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/algebra/module-inverse.html'],
  ),
  TopicModel(
    id: 'combinatorics',
    name: 'Combinatorics',
    category: 'Greedy & Math',
    summary:
        'Counting with factorials, nCr, inclusion-exclusion, Pigeonhole. Most contest math lives here.',
    difficulty: 3,
    prerequisiteIds: ['modular-arithmetic'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/combinatorics/binomial-coefficients.html'],
  ),

  // ── DYNAMIC PROGRAMMING ──────────────────────────────────────────────────
  TopicModel(
    id: 'dp-intro',
    name: 'DP Introduction',
    category: 'Dynamic Programming',
    summary:
        'Overlapping subproblems + optimal substructure. Memoisation vs tabulation. Always define the state first.',
    difficulty: 3,
    prerequisiteIds: ['basics', 'complexity'],
    problemIds: [],
    referenceUrls: ['https://usaco.guide/gold/intro-dp'],
  ),
  TopicModel(
    id: 'dp-knapsack',
    name: 'Knapsack DP',
    category: 'Dynamic Programming',
    summary:
        '0/1 knapsack, unbounded knapsack, subset sum. The first "real" DP every CP student needs.',
    difficulty: 3,
    prerequisiteIds: ['dp-intro'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/dynamic_programming/knapsack.html'],
  ),
  TopicModel(
    id: 'dp-lis',
    name: 'LIS & Sequence DP',
    category: 'Dynamic Programming',
    summary:
        'Longest Increasing Subsequence and friends. Patience sorting gives O(n log n). Base for many sequence problems.',
    difficulty: 3,
    prerequisiteIds: ['dp-intro'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/sequences/longest-increasing-subsequence.html'],
  ),
  TopicModel(
    id: 'dp-interval',
    name: 'Interval DP',
    category: 'Dynamic Programming',
    summary:
        'dp[l][r] — solve subproblems on all intervals of a sequence. Classic: matrix chain, burst balloons, stone merge.',
    difficulty: 4,
    prerequisiteIds: ['dp-knapsack', 'dp-lis'],
    problemIds: [],
    referenceUrls: ['https://usaco.guide/platinum/interval-dp'],
  ),
  TopicModel(
    id: 'dp-bitmask',
    name: 'Bitmask DP',
    category: 'Dynamic Programming',
    summary:
        'Encode a subset of elements as a bitmask. Handles small-n exponential state spaces. TSP is the archetype.',
    difficulty: 4,
    prerequisiteIds: ['dp-interval'],
    problemIds: [],
    referenceUrls: ['https://usaco.guide/gold/dp-bitmask'],
  ),
  TopicModel(
    id: 'dp-tree',
    name: 'Tree DP',
    category: 'Dynamic Programming',
    summary:
        'Run DP on a rooted tree: state = (node, subtree info). Re-rooting trick handles unrooted variants.',
    difficulty: 4,
    prerequisiteIds: ['dp-intro', 'topo-sort'],
    problemIds: [],
    referenceUrls: ['https://usaco.guide/gold/dp-trees'],
  ),

  // ── STRINGS ──────────────────────────────────────────────────────────────
  TopicModel(
    id: 'strings-intro',
    name: 'String Basics & Hashing',
    category: 'Strings',
    summary:
        'Polynomial rolling hash for O(1) substring comparison. Collision avoidance and double-hashing.',
    difficulty: 2,
    prerequisiteIds: ['basics'],
    problemIds: ['longest-substring'],
    referenceUrls: ['https://cp-algorithms.com/string/string-hashing.html'],
  ),
  TopicModel(
    id: 'kmp',
    name: 'KMP & Z-Algorithm',
    category: 'Strings',
    summary:
        'Linear-time pattern matching without brute force. KMP prefix function and Z-array are dual views of the same idea.',
    difficulty: 3,
    prerequisiteIds: ['strings-intro'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/string/prefix-function.html'],
  ),
  TopicModel(
    id: 'trie',
    name: 'Trie',
    category: 'Strings',
    summary:
        'Prefix tree for O(L) string insert/lookup. XOR trie solves maximum XOR subarray.',
    difficulty: 3,
    prerequisiteIds: ['strings-intro'],
    problemIds: [],
    referenceUrls: ['https://cp-algorithms.com/string/aho_corasick.html'],
  ),
];

// ---------------------------------------------------------------------------
// Tracks — curated, goal-oriented sequences of topics.
// ---------------------------------------------------------------------------
const _tracks = <TrackModel>[
  TrackModel(
    id: 'div2-survival',
    title: 'Div 2 A–C Survival Kit',
    description:
        'Everything you need to consistently solve the first three problems in a Codeforces Div 2 round.',
    topicIds: [
      'basics',
      'complexity',
      'sorting',
      'binary-search',
      'two-pointers',
      'prefix-sums',
      'greedy',
      'stacks-queues',
    ],
    iconName: 'bolt',
  ),
  TrackModel(
    id: 'graph-mastery',
    title: 'Graph Mastery',
    description:
        'From adjacency lists to shortest paths, MST and topological sort. Covers DP on DAGs.',
    topicIds: [
      'basics',
      'stacks-queues',
      'dsu',
      'graphs-intro',
      'topo-sort',
      'shortest-paths',
      'mst',
    ],
    iconName: 'account_tree',
  ),
  TrackModel(
    id: 'dp-track',
    title: 'Dynamic Programming Deep Dive',
    description:
        'From first principles through interval, bitmask and tree DP. The highest-impact skill gap to close.',
    topicIds: [
      'basics',
      'complexity',
      'dp-intro',
      'dp-knapsack',
      'dp-lis',
      'dp-interval',
      'dp-bitmask',
      'dp-tree',
    ],
    iconName: 'layers',
  ),
  TrackModel(
    id: 'math-track',
    title: 'CP Mathematics',
    description:
        'Number theory, modular arithmetic and combinatorics — the math layer every D contestant needs.',
    topicIds: [
      'basics',
      'math-basics',
      'modular-arithmetic',
      'combinatorics',
    ],
    iconName: 'functions',
  ),
];

// ---------------------------------------------------------------------------
// Lessons — one per topic (body + key ideas).
// ---------------------------------------------------------------------------
final _lessons = <String, LessonModel>{
  'basics': const LessonModel(
    topicId: 'basics',
    body:
        'Every competitive programming solution is just a program: read input, compute, write output. '
        'Fluency with your language\'s I/O (scanf/printf or cin/cout with sync disabled), loops, '
        'conditionals, and functions is the only true prerequisite for everything else.',
    keyIdeas: [
      'Fast I/O: use ios::sync_with_stdio(false); cin.tie(nullptr); in C++.',
      'Prefer int over long long until you need range > 2×10⁹.',
      'Read the problem statement twice before writing a single line.',
      'Test on the sample cases manually before submitting.',
    ],
  ),
  'binary-search': const LessonModel(
    topicId: 'binary-search',
    body:
        'Binary search works on any *monotonic* predicate `f(x)`: it finds the boundary '
        'where `f` flips from false to true. The classic sorted-array search is just one '
        'instance of this idea.\n\n'
        'The core loop keeps two bounds `lo` and `hi`, checks the midpoint '
        '`mid = (lo + hi) / 2`, and discards half the range based on `f(mid)`. Each step '
        'halves the search space, so it runs in `O(log n)`.\n\n'
        'Off-by-one errors are the only real danger here — pin down your loop invariant '
        'before you write a single line.',
    keyIdeas: [
      'Works on *any* monotonic predicate, not just sorted arrays.',
      'Use `long long` for `mid` when `lo + hi` can overflow.',
      '“Binary search on the answer” turns optimisation into repeated feasibility checks.',
      'Always verify what `f(lo)` and `f(hi)` are before the loop starts.',
    ],
    code: 'int lo = 0, hi = n - 1, ans = -1;\n'
        'while (lo <= hi) {\n'
        '    int mid = lo + (hi - lo) / 2;   // avoids overflow\n'
        '    if (a[mid] <= target) {\n'
        '        ans = mid;                  // candidate found\n'
        '        lo = mid + 1;               // search the right half\n'
        '    } else {\n'
        '        hi = mid - 1;               // search the left half\n'
        '    }\n'
        '}\n'
        'return ans;',
    codeLang: 'cpp',
    videos: [
      LessonVideo(
        title: 'Binary Search in 100 seconds',
        url: 'https://www.youtube.com/watch?v=MFhxShGxHWc',
        durationLabel: '2 min',
      ),
    ],
  ),
  'graphs-intro': const LessonModel(
    topicId: 'graphs-intro',
    body:
        'A graph is a set of nodes (vertices) connected by edges. In competitive '
        'programming you almost always store it as an *adjacency list* — one list of '
        'neighbours per node.\n\n'
        '`BFS` (using a queue) explores level by level and finds shortest paths in '
        'unweighted graphs. `DFS` (recursion or a stack) dives deep first and is the '
        'workhorse for connected components, cycle detection, and most tree problems.',
    keyIdeas: [
      'An adjacency list is almost always right; use a matrix only when `n < 1000`.',
      '`BFS` = shortest path (unweighted). `DFS` = reachability, cycles, components.',
      'Mark a node visited *before* pushing it to the queue, not after popping.',
      'For trees, `DFS` gives parent/children naturally — store the parent to avoid revisiting.',
    ],
    code: 'vector<int> adj[N];\n'
        'bool seen[N];\n\n'
        'void bfs(int src) {\n'
        '    queue<int> q;\n'
        '    q.push(src);\n'
        '    seen[src] = true;               // mark on push\n'
        '    while (!q.empty()) {\n'
        '        int u = q.front(); q.pop();\n'
        '        for (int v : adj[u])\n'
        '            if (!seen[v]) {\n'
        '                seen[v] = true;\n'
        '                q.push(v);\n'
        '            }\n'
        '    }\n'
        '}',
    codeLang: 'cpp',
    videos: [
      LessonVideo(
        title: 'Graph Traversals — BFS & DFS',
        url: 'https://www.youtube.com/watch?v=pcKY4hjDrxk',
        durationLabel: '18 min',
      ),
    ],
  ),
  'dp-intro': const LessonModel(
    topicId: 'dp-intro',
    body:
        'Dynamic programming solves problems that have *overlapping subproblems* and '
        '*optimal substructure*. The recipe is always the same four steps.\n\n'
        '1. Define the state — what exactly does `dp[i]` mean?\n'
        '2. Write the recurrence relating it to smaller states.\n'
        '3. Identify the base cases.\n'
        '4. Choose top-down (memoisation) or bottom-up (tabulation).\n\n'
        'If you cannot state precisely what `dp[i]` means in plain English, you cannot '
        'write the DP — that definition is most of the work.',
    keyIdeas: [
      'The state definition is 80% of the work — write it in English first.',
      'Memoisation is easier to write; tabulation is faster (no recursion overhead).',
      'The recurrence must only reference *strictly smaller* subproblems.',
      'Print the `dp` table on small inputs to debug a wrong recurrence.',
    ],
    code: '// Fibonacci, bottom-up tabulation\n'
        'vector<long long> dp(n + 1);\n'
        'dp[0] = 0;\n'
        'dp[1] = 1;                          // base cases\n'
        'for (int i = 2; i <= n; i++)\n'
        '    dp[i] = dp[i - 1] + dp[i - 2];  // recurrence\n'
        'return dp[n];',
    codeLang: 'cpp',
    videos: [
      LessonVideo(
        title: 'Dynamic Programming — full course',
        url: 'https://www.youtube.com/watch?v=oBt53YbR9Kk',
        durationLabel: '5 hr',
      ),
    ],
  ),
  'greedy': const LessonModel(
    topicId: 'greedy',
    body:
        'A greedy algorithm makes the locally optimal choice at each step and never backtracks. '
        'It works when the "greedy choice property" holds: a local optimum leads to a global one. '
        'The exchange argument is the standard proof: assume the optimal solution differs from the '
        'greedy one, then show you can swap to the greedy choice without making things worse.',
    keyIdeas: [
      'Always sort first — most greedy problems become obvious after sorting.',
      'Prove correctness with an exchange argument before coding.',
      'If greedy gives WA, the problem is likely DP.',
      'Interval scheduling: sort by finish time, pick greedily.',
    ],
  ),
  'prefix-sums': const LessonModel(
    topicId: 'prefix-sums',
    body:
        'Build prefix[i] = a[0]+a[1]+…+a[i]. Then sum(l,r) = prefix[r] - prefix[l-1] in O(1). '
        'Extend to 2D for rectangle sum queries. Difference arrays (inverse of prefix sums) let you '
        'apply range updates in O(1) and reconstruct in O(n).',
    keyIdeas: [
      'Always use a 1-indexed prefix array to avoid the l-1 = -1 edge case.',
      '2D prefix: pre[i][j] = pre[i-1][j] + pre[i][j-1] - pre[i-1][j-1] + a[i][j].',
      'Difference array: to add x to [l,r] do diff[l]+=x, diff[r+1]-=x.',
      'Prefix XOR answers range XOR queries the same way.',
    ],
  ),
  'sorting': const LessonModel(
    topicId: 'sorting',
    body:
        'Most CP problems that involve sorting use the language\'s built-in sort (O(n log n)) with a '
        'custom comparator. Know merge sort to understand stable sorting and inversion counting. '
        'Counting sort / radix sort are O(n+k) when the value range is small.',
    keyIdeas: [
      'std::sort with a lambda comparator handles 95% of sorting needs.',
      'Stable sort matters when equal elements must keep their relative order.',
      'Counting sort beats comparison sort when values fit in a small range.',
      'Inversion count = number of swaps needed to sort = merge sort side-effect.',
    ],
  ),
  'two-pointers': const LessonModel(
    topicId: 'two-pointers',
    body:
        'Two pointers move inward from both ends (or slide a window) to avoid the O(n²) brute force. '
        'They work when the problem has monotonicity: moving one pointer in a direction '
        'makes the other move in a predictable direction too.',
    keyIdeas: [
      'Sort first if the problem allows it — most two-pointer problems require sorted input.',
      'Sliding window is the same idea: lo moves right when the window is invalid.',
      'Total pointer movement is O(n) — that\'s why it\'s fast.',
      'Classic: two-sum (sorted), three-sum, minimum window substring.',
    ],
  ),
  'stacks-queues': const LessonModel(
    topicId: 'stacks-queues',
    body:
        'Stack (LIFO) and queue (FIFO) are the backbone of DFS and BFS respectively. '
        'A monotonic stack maintains elements in increasing/decreasing order and solves '
        '"next greater element" in O(n). A deque-based sliding window finds the max/min '
        'in any window in O(n).',
    keyIdeas: [
      'Monotonic stack: pop while stack top >= current; push current.',
      'Sliding window max: use a deque, keep indices in decreasing value order.',
      'Valid Parentheses: push opens, pop and check on closes.',
      'Expression evaluation: two stacks (operators + operands) or Shunting Yard.',
    ],
  ),
  'strings-intro': const LessonModel(
    topicId: 'strings-intro',
    body:
        'Rolling polynomial hash: h(s[l..r]) = sum of s[i]*p^i mod M. Pre-compute prefix hashes and '
        'inverse powers to answer "are two substrings equal?" in O(1). Use two different (M, p) pairs '
        'to reduce collision probability to negligible.',
    keyIdeas: [
      'Choose p > alphabet size (31 for lowercase letters, 131 for general).',
      'Choose M as a large prime (1e9+7, 1e9+9) or 2^61-1 with __int128.',
      'Double hashing (two independent hashes) gives collision rate ≈ 1/(M₁×M₂).',
      'Hashing enables O(n log n) longest common substring via binary search + hash.',
    ],
  ),
  'math-basics': const LessonModel(
    topicId: 'math-basics',
    body:
        'GCD via Euclidean algorithm: gcd(a,b) = gcd(b, a%b). LCM = a*b/gcd(a,b) (watch overflow). '
        'Sieve of Eratosthenes: mark multiples to find all primes up to N in O(N log log N). '
        'Factorisation: trial divide up to sqrt(n).',
    keyIdeas: [
      '__gcd(a, b) in C++ or math.gcd(a, b) in Python — no need to write it.',
      'LCM: compute a/gcd(a,b)*b to avoid intermediate overflow.',
      'Sieve is fast up to ~10^7; beyond that, use a segmented sieve.',
      'A number n has at most 2*sqrt(n) divisors below sqrt(n) — useful bound.',
    ],
  ),
  'modular-arithmetic': const LessonModel(
    topicId: 'modular-arithmetic',
    body:
        'All arithmetic under a prime modulus p. Addition and multiplication work normally. '
        'Division: multiply by modular inverse instead. Inverse via Fermat\'s little theorem: '
        'inv(a) = a^(p-2) mod p (works when p is prime). Extended Euclidean gives inverse for non-prime p.',
    keyIdeas: [
      'Always take mod after addition and multiplication to avoid overflow.',
      'pow(a, p-2, p) in Python gives modular inverse when p is prime.',
      'Precompute factorials and inverse-factorials for fast nCr mod p.',
      'If p is not prime, use extended Euclidean — Fermat\'s theorem doesn\'t apply.',
    ],
  ),
};
