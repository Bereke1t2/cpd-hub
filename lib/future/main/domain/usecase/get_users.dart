import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/failure.dart';
import '../entitiy/user_entity.dart';
import '../repository/main_repo.dart';

class GetUsers {
  final MainRepo repository;
  GetUsers(this.repository);

  Future<Either<List<UserEntity>, Failure>> call({int page = 1, int limit = 20}) async {
    return await repository.getUsers(page: page, limit: limit);
  }
}
