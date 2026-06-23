import '../../models/article_model.dart';
import '../articles_data_source.dart';

class MockArticlesDataSource implements ArticlesDataSource {
  @override
  Future<List<ArticleModel>> getArticles({
    required int maxCount,
    int offset = 0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    ArticleModel article({
      required String id,
      required String title,
      required String author,
      required String excerpt,
      String? fullContent,
      required List<String> tags,
      int? rating,
      int daysAgo = 0,
    }) =>
        ArticleModel(
          id: id,
          title: title,
          author: author,
          source: 'Codeforces',
          sourceUrl: 'https://codeforces.com/blog/entry/${id.replaceFirst('cf_', '')}',
          excerpt: excerpt,
          fullContent: fullContent,
          publishedAt: now.subtract(Duration(days: daysAgo)),
          tags: tags,
          rating: rating,
        );

    final all = [
      article(
        id: 'cf_130001',
        title: 'The Ultimate Segment Tree Tutorial — From Basics to Lazy Propagation',
        author: 'tourist',
        excerpt: 'Segment trees are one of the most powerful data structures in competitive programming. In this tutorial I\'ll cover everything from the basic point-update range-query to lazy propagation and persistent variants.',
        fullContent: 'Segment trees are one of the most powerful data structures in competitive programming. In this tutorial I\'ll cover everything from the basic point-update range-query to lazy propagation and persistent variants.\n\n'
            'We start with the fundamentals: what a segment tree represents, how to build it in O(n), and how point updates and range queries each take O(log n). From there, we build up to range updates using lazy propagation — the technique that lets you defer work until it\'s actually needed.\n\n'
            'The second half covers advanced applications: segment tree with vectors for merge sort tree queries, persistent segment trees that let you query historical versions, and 2D segment trees for grid problems. Each section includes complete C++ code and a Codeforces problem you can solve immediately to test your understanding.\n\n'
            'Key takeaway: segment trees aren\'t just for range sum/min/max. Once you understand the monoid abstraction, you\'ll recognize segment tree problems everywhere — from GCD ranges to matrix multiplication on intervals.',
        tags: ['data structures', 'trees', 'tutorial'],
        rating: 342,
        daysAgo: 2,
      ),
      article(
        id: 'cf_130050',
        title: 'Mastering Dynamic Programming on Trees',
        author: 'Errichto',
        excerpt: 'Tree DP problems appear in almost every Codeforces round. Here I break down the four most common patterns: rerooting, subtree DP, path DP, and DP with diameter.',
        fullContent: 'Tree DP problems appear in almost every Codeforces round. Here I break down the four most common patterns: rerooting, subtree DP, path DP, and DP with diameter.\n\n'
            'Subtree DP is where most people start — compute dp[v] based on dp[children]. Classic example: find the size of every subtree, or compute the maximum independent set on a tree. The pattern is always the same: DFS, post-order processing, combine child results.\n\n'
            'Rerooting DP takes this further. Instead of running DFS from every node (O(n²)), we run one initial DFS then a second pass that "shifts" the root. Each shift is O(1) because we precompute prefix/suffix aggregates of child dp values. This pattern solves problems like "sum of distances to all other nodes" in O(n).\n\n'
            'Path DP and tree diameter problems round out the guide. I include 10 curated Codeforces problems progressing from 1400 to 2600 rating so you can build intuition systematically.',
        tags: ['dp', 'trees', 'tutorial'],
        rating: 278,
        daysAgo: 3,
      ),
      article(
        id: 'cf_130200',
        title: 'How I Went from Pupil to Grandmaster in 18 Months',
        author: 'IceKnight1093',
        excerpt: 'I started CP in January 2024 as a complete beginner. Here\'s exactly what I did, what worked, what didn\'t, and the resources that made the biggest difference.',
        fullContent: 'I started CP in January 2024 as a complete beginner. Here\'s exactly what I did, what worked, what didn\'t, and the resources that made the biggest difference.\n\n'
            'Months 1-3 (Pupil → Specialist): I solved the CSES problem set cover to cover. Every problem, no skipping. This built my fundamentals across sorting, searching, basic DP, and graph traversal. I also did every Codeforces round without exception — contest experience matters even when you perform badly.\n\n'
            'Months 4-9 (Specialist → Expert → Candidate Master): This was the deliberate practice phase. I stopped solving random problems and started targeting specific weaknesses. Each week I picked a topic (e.g. segment trees, binary lifting, SCC) and solved 10-15 problems on just that topic. I kept a spreadsheet tracking every problem with notes on what I learned.\n\n'
            'Months 10-18 (CM → Master → GM): Virtual contests became my main tool. Three per week, timed strictly, full upsolving afterward. I also started writing editorials for problems I solved — teaching others solidified my understanding. Rating really is just a number; focus on solving problems that are slightly above your current level and the rating follows.',
        tags: ['community', 'tips'],
        rating: 421,
        daysAgo: 1,
      ),
      article(
        id: 'cf_130400',
        title: 'Why Most CP Practice Routines Fail (And How to Fix Yours)',
        author: 'Um_nik',
        excerpt: 'Solving 500 random problems won\'t make you red. Here\'s the structured approach that actually builds skill, with data from top competitors\' training logs.',
        fullContent: 'Solving 500 random problems won\'t make you red. Here\'s the structured approach that actually builds skill, with data from top competitors\' training logs.\n\n'
            'The most common mistake: solving problems you already know how to solve. It feels productive but you\'re just reinforcing existing patterns, not building new ones. The sweet spot is problems where you have a 30-60% chance of solving — hard enough to grow, easy enough to not be demoralizing.\n\n'
            'Second mistake: not upsolving. If you skip the problems you couldn\'t solve during a contest, you\'re leaving 70% of the learning on the table. Read editorials, study other people\'s solutions, implement it yourself even after you\'ve "understood" it.\n\n'
            'The fix is simple: keep a structured log. For each problem, note the topic, what you tried, where you got stuck, and the key insight. Review your log weekly. Patterns emerge — you might find you consistently struggle with constructive algorithms, which tells you exactly what to practice next.',
        tags: ['tips', 'practice'],
        rating: 510,
        daysAgo: 4,
      ),
      article(
        id: 'cf_130320',
        title: 'A Complete Guide to Number Theory for Competitive Programming',
        author: 'galen_colin',
        excerpt: 'Modular arithmetic, CRT, Miller-Rabin primality, sieve variations, multiplicative functions — this guide has everything you need for number theory in contests.',
        fullContent: 'Modular arithmetic, CRT, Miller-Rabin primality, sieve variations, multiplicative functions — this guide has everything you need for number theory in contests.\n\n'
            'We start with the essentials: modular exponentiation (binary exponentiation) and modular inverse (Fermat\'s little theorem + extended Euclidean). These two techniques appear in roughly 80% of number theory problems.\n\n'
            'Next we tackle primality: from the naive O(√n) to Miller-Rabin with deterministic bases for 64-bit integers. For factorization, Pollard\'s Rho is covered with a clean, contest-ready implementation.\n\n'
            'The advanced section covers the sieve beyond primes: linear sieve for computing multiplicative functions (totient, Möbius, divisor count) in O(n), Dirichlet convolution for combining functions, and a practical introduction to the Chinese Remainder Theorem with both coprime and non-coprime moduli. Every section ends with 3-5 handpicked Codeforces problems.',
        tags: ['math', 'number theory', 'tutorial'],
        rating: 256,
        daysAgo: 7,
      ),
      article(
        id: 'cf_130620',
        title: 'Suffix Automaton Explained Intuitively',
        author: 'adamant',
        excerpt: 'Suffix automaton is often taught as a complex DFA construction. I\'ll show you the intuitive way to understand it — starting from the suffix tree and working backwards.',
        fullContent: 'Suffix automaton is often taught as a complex DFA construction. I\'ll show you the intuitive way to understand it — starting from the suffix tree and working backwards.\n\n'
            'A suffix automaton is the minimal DFA that accepts all suffixes of a string. But that definition doesn\'t help you build or use one. Here\'s the intuition: imagine compressing a suffix trie by merging isomorphic subtrees. What you get is the suffix automaton.\n\n'
            'The construction algorithm processes characters one by one, maintaining two key invariants: the "last" state (representing the whole current prefix) and suffix links (pointing from a state to the longest proper suffix that belongs to a different equivalence class).\n\n'
            'With suffix automaton you can solve problems like counting distinct substrings (O(n)), finding the longest common substring of two strings (O(n+m)), and computing the lexicographically k-th substring. I provide clean, commented C++ code for each algorithm.',
        tags: ['strings', 'advanced', 'tutorial'],
        rating: 189,
        daysAgo: 6,
      ),
      article(
        id: 'cf_130700',
        title: 'The State of Competitive Programming in Africa — 2026',
        author: 'Bereket Aschalew',
        excerpt: 'CP is growing fast across Africa. From Ethiopia to Nigeria, new hubs are forming, online judges are localizing, and a new generation of competitors is rising.',
        fullContent: 'CP is growing fast across Africa. From Ethiopia to Nigeria, new hubs are forming, online judges are localizing, and a new generation of competitors is rising.\n\n'
            'Ethiopia now hosts regular ICPC training camps in Addis Ababa, with participation doubling year over year. AASTU and AAiT have built competitive programming into their CS curriculum — not as an afterthought, but as a core problem-solving course. The results show: Ethiopian teams placed in the top 10 at the 2025 Africa and Arab Collegiate Programming Championship.\n\n'
            'Nigeria\'s CP community has exploded on Codeforces, with Lagos and Abuja each hosting monthly meetups. The "Naija CP" Discord server has grown to over 2,000 members. Meanwhile, Egypt continues to dominate the continental scene — but the gap is closing fast as Kenya, Rwanda, and South Africa invest in training infrastructure.\n\n'
            'The biggest challenge remains internet access and consistent electricity in some regions. But mobile-first platforms and offline judges are helping bridge that gap. The next five years will transform African competitive programming.',
        tags: ['community', 'Africa'],
        rating: 88,
        daysAgo: 10,
      ),
      article(
        id: 'cf_130120',
        title: 'Competitive Programming 2025 — A Year in Review',
        author: 'SecondThread',
        excerpt: 'From IOI to ICPC World Finals, 2025 was an incredible year for competitive programming. Let\'s look back at the biggest moments, best problems, and rising stars.',
        fullContent: 'From IOI to ICPC World Finals, 2025 was an incredible year for competitive programming. Let\'s look back at the biggest moments, best problems, and rising stars.\n\n'
            'ICPC World Finals 2025 in Baku saw an all-time classic showdown. Team "MIT Logarithims" solved 11 problems to take gold, but the real story was the nail-biting finish — three teams solved problem K in the final 12 minutes, flipping the entire podium.\n\n'
            'On Codeforces, 2025 was the year of the "Constructor Era" — constructive algorithm problems dominated Div.2 and Div.1 rounds alike. Round 2000 was celebrated with a week-long festival of special contests. Tourist returned to #1 on the rating list after a three-year gap, proving that legends don\'t fade.\n\n'
            'IOI 2025 in Bolivia crowned a new generation: the gold medal cutoff was the highest ever, reflecting how competitive the field has become. The "problem of the year" in my book was IOI\'s "Quantum Walk" — a brilliant graph problem with a subtle O(n log n) solution that even seasoned contestants missed.',
        tags: ['community', 'events'],
        rating: 195,
        daysAgo: 5,
      ),
      article(
        id: 'cf_130510',
        title: 'Interactive Problems: A Survival Guide',
        author: 'Monogon',
        excerpt: 'Interactive problems are becoming more common in Codeforces rounds. Learn the patterns, common pitfalls, and debugging tricks that save you during contests.',
        fullContent: 'Interactive problems are becoming more common in Codeforces rounds. Learn the patterns, common pitfalls, and debugging tricks that save you during contests.\n\n'
            'Rule #1: Always flush your output. In C++, std::endl or std::flush; in Python, print(..., flush=True); in Java, System.out.flush(). Forgetting this is the #1 cause of "Idleness Limit Exceeded" verdicts.\n\n'
            'The three most common interactive patterns: binary search (guess a hidden number in ≤ 30 queries), graph exploration (you\'re in a maze, query neighbors), and game playing (you and the judge alternate moves). Each has its own template.\n\n'
            'For debugging: write a local "jury" program that plays the other side. It\'s a bit of extra work upfront but saves hours of frustration. I include a Python jury template that reads your program\'s queries and responds according to the problem spec.\n\n'
            'Finally: interactive problems often have simpler solutions than their non-interactive counterparts. If you find yourself overcomplicating things, step back — the query limit is usually generous for the intended solution.',
        tags: ['tutorial', 'interactive'],
        rating: 167,
        daysAgo: 8,
      ),
      article(
        id: 'cf_130810',
        title: 'Flow Networks: From Ford-Fulkerson to Dinic with Scaling',
        author: 'pajenegod',
        excerpt: 'Max-flow min-cut is just the beginning. This deep dive covers Dinic\'s algorithm, capacity scaling, and the applications you\'ll actually see in Codeforces rounds.',
        fullContent: 'Max-flow min-cut is just the beginning. This deep dive covers Dinic\'s algorithm, capacity scaling, and the applications you\'ll actually see in Codeforces rounds.\n\n'
            'Dinic\'s algorithm runs in O(E√V) for unit-capacity networks and O(V²E) in general — but in practice it\'s much faster on CP problem constraints. The key insight is the level graph: BFS to assign distances from source, then DFS only along edges that go one level deeper.\n\n'
            'Capacity scaling takes this further for graphs with large capacities. Instead of pushing arbitrary flow, we start with a large capacity threshold Δ and only push flow ≥ Δ, halving Δ each round. This guarantees O(E² log U) complexity.\n\n'
            'The real value is in problem modeling: bipartite matching (Dinic runs in O(E√V) here), minimum path cover in a DAG, project selection with dependencies (via minimum cut), and circulation with lower bounds. Each application includes a complete solution to a Codeforces problem.',
        tags: ['graphs', 'flow', 'tutorial'],
        rating: 203,
        daysAgo: 3,
      ),
    ];

    // Sort by most recent first, then page with offset.
    all.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return all.skip(offset).take(maxCount).toList();
  }
}
