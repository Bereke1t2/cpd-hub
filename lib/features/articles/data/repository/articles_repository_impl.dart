import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../../domain/entity/article_entity.dart';
import '../../domain/repository/articles_repository.dart';
import '../datasources/articles_data_source.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesDataSource _dataSource;

  ArticlesRepositoryImpl({required ArticlesDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<List<ArticleEntity>, Failure>> getArticles({
    required int maxCount,
    int offset = 0,
  }) async {
    try {
      final articles =
          await _dataSource.getArticles(maxCount: maxCount, offset: offset);
      return Left(articles);
    } catch (e) {
      return Right(ServerFailure(e.toString()));
    }
  }
}
