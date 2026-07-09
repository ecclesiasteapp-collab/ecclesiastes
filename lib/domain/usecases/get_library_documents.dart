import '../entities/library_document.dart';
import '../entities/ecclesiastical_entity.dart';
import '../entities/mandate.dart';
import '../repositories/library_repository.dart';

class GetLibraryDocuments {
  final LibraryRepository repository;

  GetLibraryDocuments(this.repository);

  Future<List<LibraryDocument>> execute({
    required List<Mandate> userMandates,
    required EntityLevel userMaxLevel,
  }) async {
    final allDocs = await repository.getDocuments();
    
    // Logic: Filter by level and roles
    return allDocs.where((doc) {
      // Check if user level is sufficient (lower index in enum usually means higher authority)
      final hasLevel = userMaxLevel.index <= doc.minimumLevel.index;
      
      // Check if user roles match (simplified)
      final userRoles = userMandates.map((m) => m.roleName.toUpperCase()).toList();
      final hasRole = doc.allowedRoles.any((role) => userRoles.contains(role.toUpperCase()));

      return hasLevel || hasRole;
    }).toList();
  }
}
