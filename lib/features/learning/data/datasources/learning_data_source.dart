import '../models/lesson_model.dart';
import '../models/topic_model.dart';
import '../models/track_model.dart';

abstract class LearningDataSource {
  Future<List<TopicModel>> getTopics();
  Future<List<TrackModel>> getTracks();
  Future<LessonModel?> getLesson(String topicId);
}
