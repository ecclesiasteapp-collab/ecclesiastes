import '../../models/bible_model.dart';

/// Interface pour l'accès à la Bible TOB et la gestion des notes/favoris.
abstract class BibleRepository {
  /// Initialise la base de données de la Bible (chargement depuis assets si vide).
  Future<void> initialize();

  /// Récupère tous les livres de la Bible.
  Future<List<BibleBook>> getBooks();

  /// Récupère un livre spécifique par son identifiant.
  Future<BibleBook?> getBook(String id);

  /// Bascule l'état favori d'un verset.
  Future<void> toggleFavorite(BibleBook book, BibleVerse verse);

  /// Ajoute ou modifie une note pastorale (chiffrée).
  Future<void> saveNote({
    required String bookId,
    required int chapterNumber,
    required int verseNumber,
    required String content,
  });

  /// Récupère la note déchiffrée d'un verset.
  Future<String?> getNote(String bookId, int chapterNumber, int verseNumber);

  /// Recherche textuelle dans toute la Bible.
  Future<List<BibleVerse>> search(String query);
}
