import '../../models/member_profile.dart';

/// Interface pour la gestion des profils des membres.
/// Centralise les opérations CRUD et le filtrage par entité.
abstract class MemberRepository {
  /// Récupère tous les membres.
  Future<List<MemberProfile>> getAllMembers();

  /// Récupère les membres d'une entité spécifique (ex: une communauté).
  Future<List<MemberProfile>> getMembersByEntity(String entityId);

  /// Récupère un membre par son identifiant unique.
  Future<MemberProfile?> getMemberById(String id);

  /// Ajoute un nouveau membre.
  Future<void> addMember(MemberProfile member);

  /// Met à jour les informations d'un membre.
  Future<void> updateMember(MemberProfile member);

  /// Supprime un membre.
  Future<void> deleteMember(String id);
}
