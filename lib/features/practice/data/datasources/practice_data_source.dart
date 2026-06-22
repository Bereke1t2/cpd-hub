import '../models/review_item_model.dart';
import '../models/upsolve_item_model.dart';

abstract class PracticeDataSource {
  Future<List<ReviewItemModel>> getReviewQueue();
  Future<void> saveReviewItem(ReviewItemModel item);
  Future<void> addToReview(ReviewItemModel item);
  Future<void> removeFromReview(String problemId);

  Future<List<UpsolveItemModel>> getUpsolves();
  Future<void> saveUpsolve(UpsolveItemModel item);
  Future<void> addUpsolve(UpsolveItemModel item);
}
