import 'package:hive/hive.dart';
import '../../domain/entities/library_document.dart';
import '../../domain/repositories/library_repository.dart';
import '../models/library_document_model.dart';

class HiveLibraryRepository implements LibraryRepository {
  static const String libraryBoxName = 'erp_library';

  Future<Box<LibraryDocumentModel>> get _libraryBox async =>
      await Hive.openBox<LibraryDocumentModel>(libraryBoxName);

  @override
  Future<List<LibraryDocument>> getDocuments() async {
    final box = await _libraryBox;
    return box.values.map((doc) => doc.toEntity()).toList();
  }

  @override
  Future<void> saveDocument(LibraryDocument doc) async {
    final box = await _libraryBox;
    await box.put(doc.id, LibraryDocumentModel.fromEntity(doc));
  }

  @override
  Future<void> deleteDocument(String id) async {
    final box = await _libraryBox;
    await box.delete(id);
  }
}
