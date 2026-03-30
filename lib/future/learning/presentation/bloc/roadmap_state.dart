part of 'roadmap_cubit.dart';

class RoadmapState extends Equatable {
  final List<RoadmapPath> roadmaps;
  final Set<String> completedModuleIds;
  final Set<String> completedProblemIds;
  final String? selectedRoadmapId;

  const RoadmapState({
    this.roadmaps = const [],
    this.completedModuleIds = const {},
    this.completedProblemIds = const {},
    this.selectedRoadmapId,
  });

  RoadmapPath? get selectedRoadmap {
    if (selectedRoadmapId == null) {
      return null;
    }
    try {
      return roadmaps.firstWhere((r) => r.roadmapId == selectedRoadmapId);
    } catch (_) {
      return null;
    }
  }

  double progressFor(RoadmapPath path) {
    if (path.modules.isEmpty) {
      return 0;
    }
    return path.completedCount(completedModuleIds) / path.modules.length;
  }

  double practiceProgressFor(RoadmapPath path) {
    final t = path.totalPracticeProblems;
    if (t == 0) return 0;
    return path.solvedPracticeCount(completedProblemIds) / t;
  }

  RoadmapState copyWith({
    List<RoadmapPath>? roadmaps,
    Set<String>? completedModuleIds,
    Set<String>? completedProblemIds,
    String? selectedRoadmapId,
  }) {
    return RoadmapState(
      roadmaps: roadmaps ?? this.roadmaps,
      completedModuleIds: completedModuleIds ?? this.completedModuleIds,
      completedProblemIds: completedProblemIds ?? this.completedProblemIds,
      selectedRoadmapId: selectedRoadmapId ?? this.selectedRoadmapId,
    );
  }

  @override
  List<Object?> get props => [roadmaps, completedModuleIds, completedProblemIds, selectedRoadmapId];
}
