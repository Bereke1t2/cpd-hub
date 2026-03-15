import '../../domain/entitiy/heatmap_entry_entity.dart';

class HeatmapEntryModel extends HeatmapEntryEntity {
  const HeatmapEntryModel({required super.date, required super.solveCount});

  factory HeatmapEntryModel.fromJson(Map<String, dynamic> json) {
    return HeatmapEntryModel(
      date: json['date'] ?? '',
      solveCount: json['solveCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'solveCount': solveCount};
  }
}
