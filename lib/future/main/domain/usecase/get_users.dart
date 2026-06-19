import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../entity/user_entity.dart';
import '../repository/main_repo.dart';

class GetUsers {
  final MainRepo repo;

  GetUsers(this.repo);

  Future<Either<List<UserEntity>, Failure>> call() {
    return repo.getUsers();
  }
}
