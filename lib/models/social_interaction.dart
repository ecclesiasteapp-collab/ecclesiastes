import 'package:hive/hive.dart';
/// Modèle pour tracker les interactions utilisateur sur les réseaux sociaux
/// Enregistre chaque vue, like, partage, etc.
@HiveType(typeId: 130)
class SocialInteraction {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String contentId; // ID de la vidéo YouTube ou publication Facebook

  @HiveField(3)
  final String platform; // 'youtube' ou 'facebook'

  @HiveField(4)
  final String contentType; // 'video' ou 'post'

  @HiveField(5)
  final String action; // 'view', 'like', 'share', 'comment', 'subscribe'

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final String? contentTitle;

  @HiveField(8)
  final String? contentDescription;

  @HiveField(9)
  final Map<String, dynamic>? metadata; // Données supplémentaires

  @HiveField(10)
  final bool isSyncedToServer; // Indique si l'interaction a été synchronisée

  @HiveField(11)
  final DateTime? syncedAt; // Date de synchronisation

  SocialInteraction({
    required this.id,
    required this.userId,
    required this.contentId,
    required this.platform,
    required this.contentType,
    required this.action,
    required this.timestamp,
    this.contentTitle,
    this.contentDescription,
    this.metadata,
    this.isSyncedToServer = false,
    this.syncedAt,
  });

  /// Marque l'interaction comme synchronisée
  SocialInteraction markAsSynced() {
    return SocialInteraction(
      id: id,
      userId: userId,
      contentId: contentId,
      platform: platform,
      contentType: contentType,
      action: action,
      timestamp: timestamp,
      contentTitle: contentTitle,
      contentDescription: contentDescription,
      metadata: metadata,
      isSyncedToServer: true,
      syncedAt: DateTime.now(),
    );
  }

  /// Convertit en JSON pour l'envoi au serveur
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'contentId': contentId,
      'platform': platform,
      'contentType': contentType,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'contentTitle': contentTitle,
      'contentDescription': contentDescription,
      'metadata': metadata,
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }
}

/// Modèle pour les statistiques d'engagement
@HiveType(typeId: 131)
class EngagementStats {
  @HiveField(0)
  final String contentId;

  @HiveField(1)
  final String platform;

  @HiveField(2)
  final int viewCount;

  @HiveField(3)
  final int likeCount;

  @HiveField(4)
  final int shareCount;

  @HiveField(5)
  final int commentCount;

  @HiveField(6)
  final int subscribeCount;

  @HiveField(7)
  final DateTime lastUpdated;

  @HiveField(8)
  final int localViewCount; // Vues depuis l'application

  @HiveField(9)
  final int localLikeCount; // Likes depuis l'application

  @HiveField(10)
  final int localShareCount; // Partages depuis l'application

  EngagementStats({
    required this.contentId,
    required this.platform,
    required this.viewCount,
    required this.likeCount,
    required this.shareCount,
    required this.commentCount,
    required this.subscribeCount,
    required this.lastUpdated,
    this.localViewCount = 0,
    this.localLikeCount = 0,
    this.localShareCount = 0,
  });

  /// Calcule le taux d'engagement
  double get engagementRate {
    if (viewCount == 0) return 0;
    final totalEngagement = likeCount + shareCount + commentCount;
    return (totalEngagement / viewCount) * 100;
  }

  /// Calcule le taux d'engagement local
  double get localEngagementRate {
    if (localViewCount == 0) return 0;
    final totalEngagement = localLikeCount + localShareCount;
    return (totalEngagement / localViewCount) * 100;
  }

  /// Formate les nombres pour l'affichage
  String get formattedViewCount => _formatNumber(viewCount + localViewCount);
  String get formattedLikeCount => _formatNumber(likeCount + localLikeCount);
  String get formattedShareCount => _formatNumber(shareCount + localShareCount);
  String get formattedCommentCount => _formatNumber(commentCount);
  String get formattedSubscribeCount => _formatNumber(subscribeCount);

  /// Obtient le total des engagements
  int get totalEngagement =>
      likeCount + shareCount + commentCount + subscribeCount + localLikeCount + localShareCount;

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

/// Modèle pour tracker les utilisateurs actifs
@HiveType(typeId: 132)
class ActiveUser {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String? userName;

  @HiveField(2)
  final String platform; // 'youtube' ou 'facebook'

  @HiveField(3)
  final int totalInteractions;

  @HiveField(4)
  final DateTime firstInteractionAt;

  @HiveField(5)
  final DateTime lastInteractionAt;

  @HiveField(6)
  final List<String> favoriteContentIds;

  @HiveField(7)
  final Map<String, int> actionCounts; // Compte par action

  ActiveUser({
    required this.userId,
    this.userName,
    required this.platform,
    required this.totalInteractions,
    required this.firstInteractionAt,
    required this.lastInteractionAt,
    required this.favoriteContentIds,
    required this.actionCounts,
  });

  /// Ajoute une interaction
  ActiveUser addInteraction(String contentId, String action) {
    final newFavorites = List<String>.from(favoriteContentIds);
    if (!newFavorites.contains(contentId)) {
      newFavorites.add(contentId);
    }

    final newActionCounts = Map<String, int>.from(actionCounts);
    newActionCounts[action] = (newActionCounts[action] ?? 0) + 1;

    return ActiveUser(
      userId: userId,
      userName: userName,
      platform: platform,
      totalInteractions: totalInteractions + 1,
      firstInteractionAt: firstInteractionAt,
      lastInteractionAt: DateTime.now(),
      favoriteContentIds: newFavorites,
      actionCounts: newActionCounts,
    );
  }

  /// Obtient l'action la plus fréquente
  String? get mostFrequentAction {
    if (actionCounts.isEmpty) return null;
    return actionCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

