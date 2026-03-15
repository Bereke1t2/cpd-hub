import 'package:equatable/equatable.dart';

class HeatmapEntryEntity extends Equatable {
  final String date;
  final int solveCount;

  const HeatmapEntryEntity({required this.date, required this.solveCount});

  @override
  List<Object?> get props => [date, solveCount];
}
