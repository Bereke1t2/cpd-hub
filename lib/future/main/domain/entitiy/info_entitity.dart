import 'package:equatable/equatable.dart';

class InfoEntity extends Equatable {
  final String title;
  final String description;

  const InfoEntity({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}
