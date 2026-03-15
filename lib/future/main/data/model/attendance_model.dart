import '../../domain/entitiy/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({required super.date, required super.status});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: json['date'] ?? '',
      status: json['status'] ?? 'Absent',
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'status': status};
  }
}
