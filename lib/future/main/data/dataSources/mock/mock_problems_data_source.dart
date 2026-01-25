import '../../model/problem_model.dart';

abstract class MockProblemsDataSource {
  Future<List<ProblemModel>> getProblems();
}

class MockProblemsDataSourceImpl implements MockProblemsDataSource {
  @override
  Future<List<ProblemModel>> getProblems() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const [
      ProblemModel(
        title: 'Two Sum',
        difficulty: 'Easy',
        tags: ['Array', 'Hash Table'],
        numberOfLikes: 5,
        numberOfDislikes: 1,
        problemUrl: 'https://example.com/problems/two-sum',
        problemId: 'two-sum',
        isLiked: false,
        isDisliked: false,
        isSolved: false,
      ),
      ProblemModel(
        title: 'Longest Substring Without Repeating Characters',
        difficulty: 'Medium',
        tags: ['String', 'Sliding Window'],
        numberOfLikes: 3,
        numberOfDislikes: 0,
        problemUrl: 'https://example.com/problems/longest-substring',
        problemId: 'longest-substring',
        isLiked: false,
        isDisliked: false,
        isSolved: false,
      ),
      ProblemModel(
        title: 'Median of Two Sorted Arrays',
        difficulty: 'Hard',
        tags: ['Array', 'Binary Search'],
        numberOfLikes: 8,
        numberOfDislikes: 2,
        problemUrl: 'https://example.com/problems/median-two-sorted-arrays',
        problemId: 'median-two-sorted-arrays',
        isLiked: false,
        isDisliked: false,
        isSolved: true,
      ),
      ProblemModel(
        title: 'Valid Parentheses',
        difficulty: 'Easy',
        tags: ['Stack', 'String'],
        numberOfLikes: 1,
        numberOfDislikes: 1,
        problemUrl: 'https://example.com/problems/valid-parentheses',
        problemId: 'valid-parentheses',
        isLiked: false,
        isDisliked: false,
        isSolved: false,
      ),
      ProblemModel(
        title: 'Merge k Sorted Lists',
        difficulty: 'Hard',
        tags: ['Linked List', 'Heap'],
        numberOfLikes: 4,
        numberOfDislikes: 0,
        problemUrl: 'https://example.com/problems/merge-k-lists',
        problemId: 'merge-k-lists',
        isLiked: true,
        isDisliked: false,
        isSolved: true,
      ),
      ProblemModel(
        title: 'Search in Rotated Sorted Array',
        difficulty: 'Medium',
        tags: ['Array', 'Binary Search'],
        numberOfLikes: 6,
        numberOfDislikes: 1,
        problemUrl: 'https://example.com/problems/search-rotated',
        problemId: 'search-rotated',
        isLiked: false,
        isDisliked: false,
        isSolved: true,
      ),
    ];
  }
}
