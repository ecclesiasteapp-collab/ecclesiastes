import 'package:isar/isar.dart';
import '../core/security/encryption_service.dart';

part 'pastoral_note.g.dart';

@collection
class PastoralNote {
  Id id = Isar.autoIncrement;
  @Index() late String memberId; // ID de la personne concernée
  late String encryptedContent; // Contenu chiffré
  @Index() late DateTime createdAt;
  String? createdBy; // ID du ministre auteur
  
  // Getter pour déchiffrer à la volée
  @ignore
  Future<String> get content async => 
      await EncryptionService.decryptPastoralNote(encryptedContent);
  
  // Setter pour chiffrer avant sauvegarde
  Future<void> setContent(String plainText) async {
    encryptedContent = await EncryptionService.encryptPastoralNote(plainText);
  }
}
