import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../entity/article_entity.dart';
import '../repository/articles_repository.dart';

class GetArticles {
  final ArticlesRepository repo;

  GetArticles(this.repo);

  Future<Either<List<ArticleEntity>, Failure>> call({
    required int maxCount,
    int offset = 0,
  }) =>
      repo.getArticles(maxCount: maxCount, offset: offset);
}
