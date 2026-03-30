import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/failure.dart';
import '../entitiy/activity_entity.dart';
import '../repository/main_repo.dart';

class GetActivityFeed {
  final MainRepo repository;
  GetActivityFeed(this.repository);

  Future<Either<List<ActivityEntity>, Failure>> call({int page = 1, int limit = 20}) async {
    return await repository.getActivityFeed(page: page, limit: limit);
  }
}
