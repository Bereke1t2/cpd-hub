import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/failure.dart';
import '../entitiy/attendance_entity.dart';
import '../repository/main_repo.dart';

class GetAttendance {
  final MainRepo repository;
  GetAttendance(this.repository);

  Future<Either<List<AttendanceEntity>, Failure>> call(String username, int month, int year) async {
    return await repository.getAttendance(username, month, year);
  }
}
