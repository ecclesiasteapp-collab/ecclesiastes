import '../../models/news_model.dart';

/// Interface pour la gestion des annonces (News).
/// Suit le pattern Repository pour permettre l'abstraction de la source de données (Hive, API, etc.).
abstract class NewsRepository {
  /// Récupère toutes les annonces triées par date décroissante.
  Future<List<News>> getAllNews();

  /// Ajoute une nouvelle annonce.
  Future<void> addNews(News news);

  /// Met à jour une annonce existante.
  Future<void> updateNews(News news);

  /// Supprime une annonce.
  Future<void> deleteNews(String id);
}
