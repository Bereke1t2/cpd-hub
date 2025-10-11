import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../entitiy/user_entity.dart';
import '../repository/main_repo.dart';

class GetProfile {
  final MainRepo repository;

  GetProfile(this.repository);

  Future<Either<UserEntity, Failure>> call() async {
    return await repository.getProfile();
  }
}
