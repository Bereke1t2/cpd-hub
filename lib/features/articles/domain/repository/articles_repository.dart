import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../../domain/entity/article_entity.dart';

abstract class ArticlesRepository {
  Future<Either<List<ArticleEntity>, Failure>> getArticles({
    required int maxCount,
    int offset = 0,
  });
}
