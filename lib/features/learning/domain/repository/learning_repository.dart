import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/lesson_entity.dart';
import '../entity/topic_entity.dart';
import '../entity/track_entity.dart';

// Left = success, Right = Failure (repo convention — see docs/00-conventions)
abstract class LearningRepository {
  Future<Either<List<TopicEntity>, Failure>> getTopics();
  Future<Either<List<TrackEntity>, Failure>> getTracks();
  Future<Either<LessonEntity?, Failure>> getLesson(String topicId);
}
