import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/track_entity.dart';
import '../repository/learning_repository.dart';

class GetTracks {
  final LearningRepository repo;
  GetTracks(this.repo);
  Future<Either<List<TrackEntity>, Failure>> call() => repo.getTracks();
}
