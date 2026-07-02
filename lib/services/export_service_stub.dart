class ExportService {
  static Future<void> exportUserData() async {
    // L'exportation de fichiers locaux n'est pas supportée sur le Web de cette manière.
    throw Exception("L'exportation de données n'est pas encore disponible sur le Web.");
  }
}

