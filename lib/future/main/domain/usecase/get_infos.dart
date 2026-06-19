import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../entity/info_entity.dart';
import '../repository/main_repo.dart';

class GetInfo {
  final MainRepo repository;

  GetInfo(this.repository);

  Future<Either<InfoEntity, Failure>> call() async {
    return await repository.getInfo();
  }
}
