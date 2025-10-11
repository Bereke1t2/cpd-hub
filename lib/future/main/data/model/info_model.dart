import 'package:lab_portal/future/main/domain/entitiy/info_entitity.dart';

class InfoModel extends InfoEntity{
  const InfoModel({
    required super.title,
    required super.description,
  });
  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }

}