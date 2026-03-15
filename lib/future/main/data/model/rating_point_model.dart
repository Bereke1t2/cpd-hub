import '../../domain/entitiy/rating_point_entity.dart';

class RatingPointModel extends RatingPointEntity {
  const RatingPointModel({required super.date, required super.rating});

  factory RatingPointModel.fromJson(Map<String, dynamic> json) {
    return RatingPointModel(
      date: json['date'] ?? '',
      rating: json['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'rating': rating};
  }
}
