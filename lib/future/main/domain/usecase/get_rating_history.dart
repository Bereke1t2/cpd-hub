import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/failure.dart';
import '../entitiy/rating_point_entity.dart';
import '../repository/main_repo.dart';

class GetRatingHistory {
  final MainRepo repository;
  GetRatingHistory(this.repository);

  Future<Either<List<RatingPointEntity>, Failure>> call(String username) async {
    return await repository.getRatingHistory(username);
  }
}
