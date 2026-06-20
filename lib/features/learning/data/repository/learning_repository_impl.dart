import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../../domain/entity/lesson_entity.dart';
import '../../domain/entity/topic_entity.dart';
import '../../domain/entity/track_entity.dart';
import '../../domain/repository/learning_repository.dart';
import '../datasources/learning_data_source.dart';

class LearningRepositoryImpl implements LearningRepository {
  final LearningDataSource _dataSource;

  LearningRepositoryImpl(this._dataSource);

  @override
  Future<Either<List<TopicEntity>, Failure>> getTopics() async {
    try {
      final topics = await _dataSource.getTopics();
      return Left(topics);
    } catch (e) {
      return Right(Failure('Failed to load topics. Please try again.'));
    }
  }

  @override
  Future<Either<List<TrackEntity>, Failure>> getTracks() async {
    try {
      final tracks = await _dataSource.getTracks();
      return Left(tracks);
    } catch (e) {
      return Right(Failure('Failed to load tracks. Please try again.'));
    }
  }

  @override
  Future<Either<LessonEntity?, Failure>> getLesson(String topicId) async {
    try {
      final lesson = await _dataSource.getLesson(topicId);
      return Left(lesson);
    } catch (e) {
      return Right(Failure('Failed to load lesson content.'));
    }
  }
}
