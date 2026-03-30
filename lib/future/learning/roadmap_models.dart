import 'package:equatable/equatable.dart';

/// Mirrors proposed backend shape: GET /roadmaps → list of these.
class RoadmapPath extends Equatable {
  final String roadmapId;
  final String title;
  final String difficultyLevel;
  final String description;
  final List<RoadmapModule> modules;

  const RoadmapPath({
    required this.roadmapId,
    required this.title,
    required this.difficultyLevel,
    required this.description,
    required this.modules,
  });

  int get totalModules => modules.length;

  int completedCount(Set<String> completedModuleIds) {
    return modules.where((m) => completedModuleIds.contains(m.moduleId)).length;
  }

  @override
  List<Object?> get props => [roadmapId, title, difficultyLevel, modules];
}

class RoadmapModule extends Equatable {
  final String moduleId;
  final String title;
  final String summaryLine;
  final String markdownContent;
  final String? videoUrl;
  final List<PracticeProblemRef> linkedProblems;

  const RoadmapModule({
    required this.moduleId,
    required this.title,
    required this.summaryLine,
    required this.markdownContent,
    this.videoUrl,
    required this.linkedProblems,
  });

  @override
  List<Object?> get props => [moduleId, title];
}

class PracticeProblemRef extends Equatable {
  final String problemId;
  final String title;
  final String difficulty;
  final List<String> tags;

  const PracticeProblemRef({
    required this.problemId,
    required this.title,
    required this.difficulty,
    required this.tags,
  });

  @override
  List<Object?> get props => [problemId];
}

/// One row in the roadmap-wide practice checklist (module context).
class RoadmapProblemItem extends Equatable {
  final String moduleId;
  final String moduleTitle;
  final PracticeProblemRef problem;

  const RoadmapProblemItem({
    required this.moduleId,
    required this.moduleTitle,
    required this.problem,
  });

  @override
  List<Object?> get props => [problem.problemId, moduleId];
}

extension RoadmapPathChecklist on RoadmapPath {
  List<RoadmapProblemItem> get checklistItems => [
        for (final m in modules)
          for (final p in m.linkedProblems)
            RoadmapProblemItem(moduleId: m.moduleId, moduleTitle: m.title, problem: p),
      ];

  int get totalPracticeProblems => modules.fold<int>(0, (a, m) => a + m.linkedProblems.length);

  int solvedPracticeCount(Set<String> completedProblemIds) {
    var n = 0;
    for (final m in modules) {
      for (final p in m.linkedProblems) {
        if (completedProblemIds.contains(p.problemId)) n++;
      }
    }
    return n;
  }
}
