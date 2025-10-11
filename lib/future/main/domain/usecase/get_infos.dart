import 'package:dartz/dartz.dart';

import 'package:lab_portal/core/failure.dart';

import '../entitiy/info_entitity.dart';
import '../repository/main_repo.dart';

class GetInfo {
  final MainRepo repository;

  GetInfo(this.repository);

  Future<Either<InfoEntity, Failure>> call() async {
    return await repository.getInfo();
  }
}
