import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/failure.dart';
import '../entitiy/info_entitity.dart';
import '../repository/main_repo.dart';

class GetInfoList {
  final MainRepo repository;
  GetInfoList(this.repository);

  Future<Either<List<InfoEntity>, Failure>> call() async {
    return await repository.getInfoList();
  }
}
