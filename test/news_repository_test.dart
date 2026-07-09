import 'package:ecclesiaste/models/attachment_model.dart';
import 'package:ecclesiaste/models/news_model.dart';
import 'package:ecclesiaste/services/hive_news_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() {
  group('HiveNewsRepository Tests', () {
    late HiveNewsRepository repository;

    setUpAll(() {
      // Initialisation de Hive en mémoire pour les tests
      final tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);
      
      // Enregistrement des adaptateurs nécessaires
      if (!Hive.isAdapterRegistered(NewsAdapter().typeId)) {
        Hive.registerAdapter(NewsAdapter());
      }
      if (!Hive.isAdapterRegistered(AttachmentAdapter().typeId)) {
        Hive.registerAdapter(AttachmentAdapter());
      }
    });

    setUp(() {
      repository = HiveNewsRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('Ajouter et récupérer une annonce', () async {
      final news = News(
        id: 'news-1',
        title: 'Titre Test',
        imageUrl: 'placeholder',
        content: 'Contenu de test',
        date: DateTime.now(),
      );

      await repository.addNews(news);
      final allNews = await repository.getAllNews();

      expect(allNews.length, 1);
      expect(allNews.first.title, 'Titre Test');
      expect(allNews.first.id, 'news-1');
    });

    test('Supprimer une annonce', () async {
      final news = News(
        id: 'news-to-delete',
        title: 'Delete Me',
        imageUrl: 'placeholder',
        content: 'Content',
        date: DateTime.now(),
      );

      await repository.addNews(news);
      await repository.deleteNews('news-to-delete');
      final allNews = await repository.getAllNews();

      expect(allNews.isEmpty, isTrue);
    });

    test('Les annonces sont triées par date décroissante', () async {
      final newsOld = News(
        id: 'old',
        title: 'Vieille annonce',
        imageUrl: '',
        content: '',
        date: DateTime.now().subtract(const Duration(days: 10)),
      );
      final newsNew = News(
        id: 'new',
        title: 'Nouvelle annonce',
        imageUrl: '',
        content: '',
        date: DateTime.now(),
      );

      await repository.addNews(newsOld);
      await repository.addNews(newsNew);
      
      final allNews = await repository.getAllNews();

      expect(allNews.first.id, 'new');
      expect(allNews.last.id, 'old');
    });
  });
}
