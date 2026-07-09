import '../entities/library_document.dart';

abstract class LibraryRepository {
  Future<List<LibraryDocument>> getDocuments();
  Future<void> saveDocument(LibraryDocument doc);
  Future<void> deleteDocument(String id);
}
