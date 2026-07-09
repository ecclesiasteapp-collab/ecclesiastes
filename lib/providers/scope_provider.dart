import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/entite_scope_service.dart';

/// Provider pour l'identifiant de l'entité active dans le scope.
/// Permet aux autres providers (comme les statistiques ERP) de réagir au changement d'entité.
final activeEntityIdProvider = StateProvider<String>((ref) {
  final scope = EntiteScopeService.getActiveScope();
  return scope['id'] ?? '';
});
