import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/utils/entite_types.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';

/// Périmètre actif du tableau de bord (champ / district / communauté sélectionnés).
class EntiteScopeService {
  EntiteScopeService._();

  static String? internationaleId;
  static String? territorialeId;
  static String? champId;
  static String? districtId;
  static String? communauteId;

  static String? get filterCommunauteId {
    if (communauteId != null && communauteId!.isNotEmpty) return communauteId;
    return AuthService.filterCommunauteId;
  }

  static void setScope({
    String? internationale,
    String? territoriale,
    String? champ,
    String? district,
    String? communaute,
  }) {
    internationaleId = internationale;
    territorialeId = territoriale;
    champId = champ;
    districtId = district;
    communauteId = communaute;
  }

  static void clear() {
    internationaleId = null;
    territorialeId = null;
    champId = null;
    districtId = null;
    communauteId = null;
  }

  /// Récupère l'entité et le niveau les plus précis actuellement sélectionnés.
  static Map<String, dynamic> getActiveScope() {
    if (communauteId != null && communauteId!.isNotEmpty) {
      return {'id': communauteId, 'level': EntityLevel.communaute};
    }
    if (districtId != null && districtId!.isNotEmpty) {
      return {'id': districtId, 'level': EntityLevel.district};
    }
    if (champId != null && champId!.isNotEmpty) {
      return {'id': champId, 'level': EntityLevel.champ};
    }
    if (territorialeId != null && territorialeId!.isNotEmpty) {
      return {'id': territorialeId, 'level': EntityLevel.territoriale};
    }
    return {'id': internationaleId, 'level': EntityLevel.internationale};
  }

  /// Libellé pill : « Champ (Kinshasa Sud-Ouest) »
  static String pillLabel(String niveau, String nom) => '$niveau ($nom)';

  /// Initialise le scope depuis la communauté de session (login).
  static Future<void> initFromSession() async {
    final sessionComm = AuthService.currentEntiteId;
    if (sessionComm.isEmpty) {
      await initDefaultForAdmin();
      return;
    }
    await initFromCommunaute(sessionComm);
  }

  static Future<void> initFromCommunaute(String communauteIdParam) async {
    final chain = await DatabaseHelper.instance.getChaineAncestres(communauteIdParam);
    String? internationale;
    String? territoriale;
    String? champ;
    String? district;

    // La chaîne est retournée de l'entité actuelle vers la racine, donc nous la parcourons pour trouver les ancêtres.
    for (final e in chain) {
      final t = EntiteTypes.normalize(e['type']?.toString());
      if (t == EntiteTypes.internationale) internationale = e['id']?.toString();
      if (t == EntiteTypes.egliseTerritoriale) territoriale = e['id']?.toString();
      if (t == EntiteTypes.champApostolique) champ = e['id']?.toString();
      if (t == EntiteTypes.district) district = e['id']?.toString();
    }
    setScope(
      internationale: internationale,
      territoriale: territoriale,
      champ: champ,
      district: district,
      communaute: communauteIdParam,
    );
  }

  /// Super-admin / ministre : premier champ + premier district + première communauté.
  static Future<void> initDefaultForAdmin() async {
    final internationales = await DatabaseHelper.instance.getEntitesByType(EntiteTypes.internationale);
    if (internationales.isEmpty) return;
    final internationale = internationales.first['id'].toString();

    final territoriales = await DatabaseHelper.instance.getSubEntites(internationale, EntiteTypes.egliseTerritoriale);
    if (territoriales.isEmpty) {
      setScope(internationale: internationale);
      return;
    }
    final territoriale = territoriales.first['id'].toString();

    final champs = await DatabaseHelper.instance.getSubEntites(territoriale, EntiteTypes.champApostolique);
    if (champs.isEmpty) {
      setScope(internationale: internationale, territoriale: territoriale);
      return;
    }
    final champ = champs.first['id'].toString();

    final districts = await DatabaseHelper.instance.getSubEntites(champ, EntiteTypes.district);
    if (districts.isEmpty) {
      setScope(internationale: internationale, territoriale: territoriale, champ: champ);
      return;
    }
    final district = districts.first['id'].toString();

    final comms = await DatabaseHelper.instance.getSubEntites(district, EntiteTypes.communaute);
    setScope(
      internationale: internationale,
      territoriale: territoriale,
      champ: champ,
      district: district,
      communaute: comms.isNotEmpty ? comms.first['id'].toString() : null,
    );
  }
}

