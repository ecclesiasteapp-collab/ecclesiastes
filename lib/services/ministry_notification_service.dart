import 'package:hive/hive.dart';

/// Service de gestion des notifications pour le corps ministériel
class MinistryNotificationService {
  static final MinistryNotificationService _instance = MinistryNotificationService._internal();

  factory MinistryNotificationService() {
    return _instance;
  }

  MinistryNotificationService._internal();

  // Callbacks pour les mises à jour en temps réel
  final List<Function(String ministerId, int unreadCount)> _unreadCountListeners = [];
  final List<Function(String ministerId, Map<String, dynamic> directive)> _directiveListeners = [];
  final List<Function(String ministerId, Map<String, dynamic> document)> _documentListeners = [];

  /// Obtient le nombre de directives non lues pour un ministre
  Future<int> getUnreadDirectivesCount(String ministerId) async {
    try {
      final box = await Hive.openBox<Map>('entity_directives');
      final directives = box.values
          .where((d) => (d['destinataires_ministres_ids'] as List?)?.contains(ministerId) ?? false)
          .toList();

      return directives.where((d) => (d['lecture_status'] as Map?)?[ministerId] == null).length;
    } catch (e) {
      return 0;
    }
  }

  /// Obtient le nombre de documents confidentiels non lus
  Future<int> getUnreadDocumentsCount(String ministerId) async {
    try {
      final box = await Hive.openBox<Map>('bibliotheque');
      final documents = box.values
          .where((d) =>
              (d['is_confidential'] == true) &&
              ((d['destinataires_ministres_ids'] as List?)?.contains(ministerId) ?? false))
          .toList();

      return documents.where((d) => (d['acces_log'] as List?)?.isEmpty ?? true).length;
    } catch (e) {
      return 0;
    }
  }

  /// Obtient le nombre total de notifications
  Future<int> getTotalNotificationsCount(String ministerId) async {
    final directives = await getUnreadDirectivesCount(ministerId);
    final documents = await getUnreadDocumentsCount(ministerId);
    return directives + documents;
  }

  /// Obtient les directives urgentes
  Future<List<Map<String, dynamic>>> getUrgentDirectives(String ministerId) async {
    try {
      final box = await Hive.openBox<Map>('entity_directives');
      return box.values
          .where((d) =>
              ((d['destinataires_ministres_ids'] as List?)
                          ?.contains(ministerId) ??
                      false) &&
                  d['priorite'] == 'urgente')
          .map((d) => Map<String, dynamic>.from(d))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Obtient les directives expirées bientôt
  Future<List<Map<String, dynamic>>> getExpiringDirectives(String ministerId, {int daysThreshold = 3}) async {
    try {
      final box = await Hive.openBox<Map>('entity_directives');
      final now = DateTime.now();
      final threshold = now.add(Duration(days: daysThreshold));

      return box.values
          .where((d) {
            if (!((d['destinataires_ministres_ids'] as List?)?.contains(ministerId) ?? false)) {
              return false;
            }
            final expiryStr = d['date_expiration']?.toString();
            if (expiryStr == null) return false;
            final expiry = DateTime.tryParse(expiryStr);
            if (expiry == null) return false;
            return expiry.isAfter(now) && expiry.isBefore(threshold);
          })
          .map((d) => Map<String, dynamic>.from(d))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Marque une directive comme lue
  Future<void> markDirectiveAsRead(String directiveId, String ministerId) async {
    try {
      final box = await Hive.openBox<Map>('entity_directives');
      final directive = box.get(directiveId);
      if (directive != null) {
        final updated = Map<String, dynamic>.from(directive);
        final lectureStatus = Map<String, String>.from(updated['lecture_status'] ?? {});
        lectureStatus[ministerId] = 'lu';
        updated['lecture_status'] = lectureStatus;
        await box.put(directiveId, updated);
        _notifyUnreadCountChanged(ministerId);
      }
    } catch (e) {
      // Erreur silencieuse
    }
  }

  /// Marque un document comme accédé
  Future<void> markDocumentAsAccessed(String documentId, String ministerId) async {
    try {
      final box = await Hive.openBox<Map>('bibliotheque');
      final document = box.get(documentId);
      if (document != null) {
        final updated = Map<String, dynamic>.from(document);
        final accesList = List<Map<String, dynamic>>.from(updated['acces_log'] ?? []);
        accesList.add({
          'minister_id': ministerId,
          'timestamp': DateTime.now().toIso8601String(),
        });
        updated['acces_log'] = accesList;
        await box.put(documentId, updated);
        _notifyUnreadCountChanged(ministerId);
      }
    } catch (e) {
      // Erreur silencieuse
    }
  }

  /// Enregistre un écouteur pour les changements de compteur non lus
  void addUnreadCountListener(Function(String ministerId, int unreadCount) listener) {
    _unreadCountListeners.add(listener);
  }

  /// Supprime un écouteur
  void removeUnreadCountListener(Function(String ministerId, int unreadCount) listener) {
    _unreadCountListeners.remove(listener);
  }

  /// Enregistre un écouteur pour les nouvelles directives
  void addDirectiveListener(Function(String ministerId, Map<String, dynamic> directive) listener) {
    _directiveListeners.add(listener);
  }

  /// Supprime un écouteur de directives
  void removeDirectiveListener(Function(String ministerId, Map<String, dynamic> directive) listener) {
    _directiveListeners.remove(listener);
  }

  /// Enregistre un écouteur pour les nouveaux documents
  void addDocumentListener(Function(String ministerId, Map<String, dynamic> document) listener) {
    _documentListeners.add(listener);
  }

  /// Supprime un écouteur de documents
  void removeDocumentListener(Function(String ministerId, Map<String, dynamic> document) listener) {
    _documentListeners.remove(listener);
  }

  /// Notifie les écouteurs d'un changement de compteur
  Future<void> _notifyUnreadCountChanged(String ministerId) async {
    final count = await getTotalNotificationsCount(ministerId);
    for (final listener in _unreadCountListeners) {
      listener(ministerId, count);
    }
  }

  /// Notifie les écouteurs d'une nouvelle directive
  void notifyNewDirective(String ministerId, Map<String, dynamic> directive) {
    for (final listener in _directiveListeners) {
      listener(ministerId, directive);
    }
    _notifyUnreadCountChanged(ministerId);
  }

  /// Notifie les écouteurs d'un nouveau document
  void notifyNewDocument(String ministerId, Map<String, dynamic> document) {
    for (final listener in _documentListeners) {
      listener(ministerId, document);
    }
    _notifyUnreadCountChanged(ministerId);
  }
}

