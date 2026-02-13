import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final String date;
  final String status; // Present, Absent, Excused

  const AttendanceEntity({
    required this.date,
    required this.status,
  });

  @override
  List<Object?> get props => [date, status];
}
