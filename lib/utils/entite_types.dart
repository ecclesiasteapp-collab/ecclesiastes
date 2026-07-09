/// Hiérarchie officielle conforme au DCG Juillet 2026 : 
/// Internationale → Église territoriale → Région apostolique → Champ apostolique → District → Communauté.
class EntiteTypes {
  EntiteTypes._();

  static const String internationale = 'INTERNATIONALE';
  static const String egliseTerritoriale = 'EGLISE_TERRITORIALE';
  static const String regionApostolique = 'REGION_APOSTOLIQUE';
  static const String champApostolique = 'CHAMP_APOSTOLIQUE';
  static const String district = 'DISTRICT';
  static const String communaute = 'COMMUNAUTE';

  /// Racine de navigation (écran initial hiérarchie).
  static const String racine = 'RACINE';

  static const List<String> hierarchie = [
    internationale,
    egliseTerritoriale,
    regionApostolique,
    champApostolique,
    district,
    communaute,
  ];

  static const List<String> typesConfigurables = hierarchie;

  static String label(String type) {
    switch (normalize(type)) {
      case internationale:
        return 'Église internationale';
      case egliseTerritoriale:
        return 'Église territoriale';
      case regionApostolique:
        return 'Région apostolique';
      case champApostolique:
        return 'Champ apostolique';
      case district:
        return 'District';
      case communaute:
        return 'Communauté';
      default:
        return type;
    }
  }

  /// Type des enfants directs pour un parent donné.
  static String? enfantDe(String typeParent) {
    switch (normalize(typeParent)) {
      case racine:
        return internationale;
      case internationale:
        return egliseTerritoriale;
      case egliseTerritoriale:
        return regionApostolique;
      case regionApostolique:
        return champApostolique;
      case champApostolique:
        return district;
      case district:
        return communaute;
      default:
        return null;
    }
  }

  /// Convertit les anciens codes vers le nouveau modèle.
  static String normalize(String? type) {
    if (type == null || type.isEmpty) return type ?? '';
    switch (type.toUpperCase()) {
      case 'INTERNATIONALE':
      case 'ROOT':
        return internationale;
      case 'TERRITOIRE':
      case 'EGLISE':
      case 'EGLISE_TERRITORIALE':
        return egliseTerritoriale;
      case 'REGION':
      case 'REGION_APOSTOLIQUE':
        return regionApostolique;
      case 'CHAMP':
      case 'CHAMP_APOSTOLIQUE':
        return champApostolique;
      case 'DISTRICT':
        return district;
      case 'COMMUNAUTE':
        return communaute;
      case 'RACINE':
        return racine;
      default:
        return type.toUpperCase();
    }
  }

  static bool peutNaviguerVersEnfants(String type) => type != communaute;
}
