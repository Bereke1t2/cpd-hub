import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/topic_entity.dart';
import '../repository/learning_repository.dart';

class GetTopics {
  final LearningRepository repo;
  GetTopics(this.repo);
  Future<Either<List<TopicEntity>, Failure>> call() => repo.getTopics();
}
