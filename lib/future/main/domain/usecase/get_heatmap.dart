import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/failure.dart';
import '../entitiy/heatmap_entry_entity.dart';
import '../repository/main_repo.dart';

class GetHeatmap {
  final MainRepo repository;
  GetHeatmap(this.repository);

  Future<Either<List<HeatmapEntryEntity>, Failure>> call(String username, int month, int year) async {
    return await repository.getHeatmap(username, month, year);
  }
}
