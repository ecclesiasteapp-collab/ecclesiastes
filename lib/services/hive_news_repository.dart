import 'package:hive/hive.dart';
import '../domain/repositories/news_repository.dart';
import '../models/news_model.dart';
import 'database_service.dart';

/// Implémentation de [NewsRepository] utilisant Hive pour le stockage local.
/// Cette implémentation fonctionne sur Mobile et Web.
class HiveNewsRepository implements NewsRepository {
  @override
  Future<List<News>> getAllNews() async {
    final box = await DatabaseService.openBox<News>(DatabaseService.newsBoxName);
    final list = box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<void> addNews(News news) async {
    final box = await DatabaseService.openBox<News>(DatabaseService.newsBoxName);
    await box.put(news.id, news);
  }

  @override
  Future<void> updateNews(News news) async {
    final box = await DatabaseService.openBox<News>(DatabaseService.newsBoxName);
    await box.put(news.id, news);
  }

  @override
  Future<void> deleteNews(String id) async {
    final box = await DatabaseService.openBox<News>(DatabaseService.newsBoxName);
    await box.delete(id);
  }
}
