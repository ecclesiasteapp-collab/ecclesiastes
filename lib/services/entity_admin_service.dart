import 'package:hive/hive.dart';

import '../models/entity_responsible.dart';
import '../models/hierarchy_models.dart';
import '../models/user.dart';
import '../core/rbac/admin_roles.dart';
import 'auth_service.dart';
import '../utils/entite_types.dart';
import 'database_helper.dart';
import 'database_service.dart';

class EntityAdminService {
  EntityAdminService._();

  static List<User> getAssignableUsers() {
    final users = DatabaseService.getAllUsers()
        .where((user) => user.isActive && user.status == 'active')
        .toList();
    users.sort(
        (a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
    return users;
  }

  static Future<void> assignLeadership({
    required String entityId,
    required String entityName,
    required String entityType,
    User? principal,
    User? deputy,
  }) async {
    // Vérification des permissions pour l'Église Internationale
    if (entityType == EntiteTypes.internationale) {
      final currentUser = AuthService.currentUser;
      if (currentUser == null || !AdminPermissions.can(currentUser.adminLevel, 'edit:international_church')) {
        throw Exception('Vous n\'avez pas la permission de modifier l\'Église Internationale.');
      }
    }
    if (principal != null && deputy != null && principal.id == deputy.id) {
      throw ArgumentError(
        'Le responsable principal et le suppléant doivent être deux personnes différentes.',
      );
    }

    await _clearPreviousAssignments(
      principalId: principal?.id,
      deputyId: deputy?.id,
      exceptEntityId: entityId,
    );

    final users = DatabaseService.getAllUsers();
    final entityLevel = _mapTypeToLevel(entityType);

    for (final user in users) {
      final isPrincipal = principal != null && user.id == principal.id;
      final isDeputy = deputy != null && user.id == deputy.id;
      final wasAssignedHere = user.entityId == entityId &&
          (user.entityRole == 'responsable' || user.entityRole == 'suppleant');

      if (wasAssignedHere && !isPrincipal && !isDeputy) {
        user.entityRole = null;
        await user.save();
      }

      if (isPrincipal) {
        user.entityId = entityId;
        user.entityLevel = entityLevel;
        user.entityRole = 'responsable';
        await user.save();
      }

      if (isDeputy) {
        user.entityId = entityId;
        user.entityLevel = entityLevel;
        user.entityRole = 'suppleant';
        await user.save();
      }
    }

    await _persistEntityMap(
      entityId: entityId,
      principal: principal,
      deputy: deputy,
    );

    await _archiveAndCreateLeadershipRecord(
      entityId: entityId,
      entityName: entityName,
      entityType: entityType,
      principal: principal,
      deputy: deputy,
    );
  }

  static Future<void> _clearPreviousAssignments({
    String? principalId,
    String? deputyId,
    required String exceptEntityId,
  }) async {
    final box = await Hive.openBox<Map>('entites');
    final targetIds = {
      if (principalId != null) principalId,
      if (deputyId != null) deputyId
    };

    if (targetIds.isEmpty) return;

    for (final key in box.keys) {
      final current = box.get(key);
      if (current == null) continue;

      final data = Map<String, dynamic>.from(current);
      if (data['id']?.toString() == exceptEntityId) continue;

      var changed = false;
      if (targetIds.contains(data['responsable_id']?.toString())) {
        data['responsable_id'] = null;
        data['responsable_nom'] = null;
        data['responsable_role'] = null;
        changed = true;
      }
      if (targetIds.contains(data['suppleant_id']?.toString())) {
        data['suppleant_id'] = null;
        data['suppleant_nom'] = null;
        changed = true;
      }

      if (changed) {
        await box.put(key, data);
      }
    }
  }

  static Future<void> _persistEntityMap({
    required String entityId,
    User? principal,
    User? deputy,
  }) async {
    final box = await Hive.openBox<Map>('entites');
    final entity = await DatabaseHelper.instance.getEntiteById(entityId);
    if (entity == null) return;

    final updated = Map<String, dynamic>.from(entity)
      ..['responsable_id'] = principal?.id
      ..['responsable_nom'] = principal?.fullName
      ..['responsable_role'] = principal?.role.name
      ..['suppleant_id'] = deputy?.id
      ..['suppleant_nom'] = deputy?.fullName;

    await box.put(entityId, updated);
  }

  static Future<void> _archiveAndCreateLeadershipRecord({
    required String entityId,
    required String entityName,
    required String entityType,
    User? principal,
    User? deputy,
  }) async {
    final box = Hive.box<EntityResponsible>('entity_responsibles');

    for (final record in box.values
        .where((item) => item.entityId == entityId && item.isActive)) {
      record
        ..isActive = false
        ..endDate = DateTime.now();
      await record.save();
    }

    final record = EntityResponsible(
      id: 'lead_${DateTime.now().millisecondsSinceEpoch}',
      entityId: entityId,
      entityName: entityName,
      level: EntiteTypes.normalize(entityType),
      principalName: principal?.fullName ?? 'Non assigné',
      principalEmail: principal?.email,
      deputyName: deputy?.fullName,
      deputyEmail: deputy?.email,
      startDate: DateTime.now(),
      isActive: true,
    );

    await box.put(record.id, record);
  }

  static EntityLevel _mapTypeToLevel(String type) {
    switch (EntiteTypes.normalize(type)) {
      case EntiteTypes.internationale:
        return EntityLevel.internationale;
      case EntiteTypes.egliseTerritoriale:
        return EntityLevel.territoriale;
      case EntiteTypes.champApostolique:
        return EntityLevel.champ;
      case EntiteTypes.district:
        return EntityLevel.district;
      case EntiteTypes.communaute:
      default:
        return EntityLevel.communaute;
    }
  }
}

