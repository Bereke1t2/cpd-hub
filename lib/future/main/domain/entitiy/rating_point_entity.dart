import 'package:equatable/equatable.dart';

class RatingPointEntity extends Equatable {
  final String date;
  final int rating;

  const RatingPointEntity({
    required this.date,
    required this.rating,
  });

  @override
  List<Object?> get props => [date, rating];
}
