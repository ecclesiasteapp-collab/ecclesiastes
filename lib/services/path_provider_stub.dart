import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Un stub pour path_provider sur le web, où getApplicationDocumentsDirectory n'est pas disponible.
// Il retourne simplement null ou un chemin temporaire non persistant.
class PathProviderStub extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return null; // Ou un chemin temporaire si nécessaire pour le web
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return null; // Pas de répertoire de documents persistant sur le web
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return null;
  }

  @override
  Future<String?> getLibraryPath() async {
    return null;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return null;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return null;
  }

  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) async {
    return null;
  }

  @override
  Future<String?> getDownloadsPath() async {
    return null;
  }
}

// Fonction de remplacement pour getApplicationDocumentsDirectory sur le web
Future<String?> getApplicationDocumentsDirectory() async {
  return PathProviderStub().getApplicationDocumentsPath();
}
