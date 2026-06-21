import 'package:equatable/equatable.dart';

enum LessonKind { video, article, pdf }

class LessonEntity extends Equatable {
  final String id;
  final String title;
  final LessonKind kind;
  final String contentUrl;
  final String? inlineText; // article markdown served inline
  final Duration? duration; // video length
  final bool completed;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.kind,
    required this.contentUrl,
    this.inlineText,
    this.duration,
    this.completed = false,
  });

  LessonEntity copyWith({bool? completed}) => LessonEntity(
        id: id,
        title: title,
        kind: kind,
        contentUrl: contentUrl,
        inlineText: inlineText,
        duration: duration,
        completed: completed ?? this.completed,
      );

  @override
  List<Object?> get props =>
      [id, title, kind, contentUrl, inlineText, duration, completed];
}
