import 'package:hive/hive.dart';
import '../models/member_profile.dart';
import '../models/hierarchy_models.dart';

class PastoralAnalyticsService {
  static Box<MemberProfile> get _memberBox => Hive.box<MemberProfile>('member_profiles');

  /// 1. Analyse Sacramentelle
  static Map<String, int> getSacramentalStatus(String entityId, EntityLevel level) {
    final members = _getMembersInScope(entityId, level);
    final now = DateTime.now();
    
    return {
      'Baptisés non scellés': members.where((m) => m.baptise && !m.scelle).length,
      'Jeunes (14+) baptisés non scellés': members.where((m) {
        final age = now.difference(m.dateNaissance).inDays / 365;
        return age >= 14 && m.baptise && !m.scelle;
      }).length,
      'Besoins pastoraux (Incohérences)': members.where((m) => m.hasSacramentalInconsistency).length,
      'Membres nés NAC': members.where((m) => m.membreNeApostolique).length,
      'Convertis': members.where((m) => !m.membreNeApostolique).length,
    };
  }

  /// 2. Analyse des Commissions
  static Map<CommissionType, int> getCommissionDistribution(String entityId, EntityLevel level) {
    final members = _getMembersInScope(entityId, level);
    Map<CommissionType, int> distribution = {};
    
    for (var type in CommissionType.values) {
      distribution[type] = members.where((m) => m.commissions.contains(type)).length;
    }
    return distribution;
  }

  /// 3. Analyse Démographique
  static Map<String, int> getDemographics(String entityId, EntityLevel level) {
    final members = _getMembersInScope(entityId, level);
    final now = DateTime.now();
    
    return {
      'Enfants (0-14 ans)': members.where((m) => now.difference(m.dateNaissance).inDays < 14 * 365).length,
      'Jeunesse (15-25 ans)': members.where((m) => now.difference(m.dateNaissance).inDays >= 14 * 365 && now.difference(m.dateNaissance).inDays < 25 * 365).length,
      'Adultes (26-64 ans)': members.where((m) => now.difference(m.dateNaissance).inDays >= 26 * 365 && now.difference(m.dateNaissance).inDays < 64 * 365).length,
      'Aînés (65+ ans)': members.where((m) => now.difference(m.dateNaissance).inDays >= 65 * 365).length,
    };
  }

  /// 4. Filtrage hiérarchique
  static List<MemberProfile> _getMembersInScope(String entityId, EntityLevel level) {
    return _memberBox.values.where((m) {
      switch (level) {
        case EntityLevel.communaute:
          return m.communauteId == entityId;
        case EntityLevel.district:
          return m.districtId == entityId;
        case EntityLevel.champ:
          return m.champApostoliqueId == entityId;
        case EntityLevel.territoriale:
          return m.egliseTerritorialeId == entityId;
        case EntityLevel.internationale:
          return true;
      }
    }).toList();
  }
}
