import 'package:hive/hive.dart';
import 'package:ecclesiastes/models/social_interaction.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Service pour tracker les interactions utilisateur sur les réseaux sociaux
/// Enregistre localement et prépare la synchronisation
class SocialInteractionTrackerService {
  static final SocialInteractionTrackerService _instance = SocialInteractionTrackerService._internal();
  final Logger _logger = Logger();

  late Box<SocialInteraction> _interactionsBox;
  late Box<EngagementStats> _statsBox;
  late Box<ActiveUser> _usersBox;

  factory SocialInteractionTrackerService() {
    return _instance;
  }

  SocialInteractionTrackerService._internal();

  /// Initialise les boîtes Hive
  Future<void> initialize() async {
    try {
      _interactionsBox = await Hive.openBox<SocialInteraction>('social_interactions');
      _statsBox = await Hive.openBox<EngagementStats>('engagement_stats');
      _usersBox = await Hive.openBox<ActiveUser>('active_users');
      _logger.i('Social Interaction Tracker initialized');
    } catch (e) {
      _logger.e('Error initializing tracker: $e');
    }
  }

  /// Enregistre une interaction utilisateur
  Future<void> trackInteraction({
    required String userId,
    required String contentId,
    required String platform, // 'youtube' ou 'facebook'
    required String contentType, // 'video' ou 'post'
    required String action, // 'view', 'like', 'share', 'comment', 'subscribe'
    String? contentTitle,
    String? contentDescription,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      const uuid = Uuid();
      final interaction = SocialInteraction(
        id: uuid.v4(),
        userId: userId,
        contentId: contentId,
        platform: platform,
        contentType: contentType,
        action: action,
        timestamp: DateTime.now(),
        contentTitle: contentTitle,
        contentDescription: contentDescription,
        metadata: metadata,
      );

      // Enregistrer l'interaction
      await _interactionsBox.add(interaction);

      // Mettre à jour les statistiques d'engagement
      await _updateEngagementStats(contentId, platform, action);

      // Mettre à jour l'utilisateur actif
      await _updateActiveUser(userId, platform, contentId, action);

      _logger.i('Interaction tracked: $action on $contentId by $userId');
    } catch (e) {
      _logger.e('Error tracking interaction: $e');
    }
  }

  /// Met à jour les statistiques d'engagement
  Future<void> _updateEngagementStats(
    String contentId,
    String platform,
    String action,
  ) async {
    try {
      final key = '${platform}_$contentId';
      var stats = _statsBox.get(key);

      stats ??= EngagementStats(
          contentId: contentId,
          platform: platform,
          viewCount: 0,
          likeCount: 0,
          shareCount: 0,
          commentCount: 0,
          subscribeCount: 0,
          lastUpdated: DateTime.now(),
        );

      // Incrémenter le compteur approprié
      switch (action) {
        case 'view':
          stats = EngagementStats(
            contentId: stats.contentId,
            platform: stats.platform,
            viewCount: stats.viewCount,
            likeCount: stats.likeCount,
            shareCount: stats.shareCount,
            commentCount: stats.commentCount,
            subscribeCount: stats.subscribeCount,
            lastUpdated: DateTime.now(),
            localViewCount: stats.localViewCount + 1,
            localLikeCount: stats.localLikeCount,
            localShareCount: stats.localShareCount,
          );
        case 'like':
          stats = EngagementStats(
            contentId: stats.contentId,
            platform: stats.platform,
            viewCount: stats.viewCount,
            likeCount: stats.likeCount,
            shareCount: stats.shareCount,
            commentCount: stats.commentCount,
            subscribeCount: stats.subscribeCount,
            lastUpdated: DateTime.now(),
            localViewCount: stats.localViewCount,
            localLikeCount: stats.localLikeCount + 1,
            localShareCount: stats.localShareCount,
          );
        case 'share':
          stats = EngagementStats(
            contentId: stats.contentId,
            platform: stats.platform,
            viewCount: stats.viewCount,
            likeCount: stats.likeCount,
            shareCount: stats.shareCount,
            commentCount: stats.commentCount,
            subscribeCount: stats.subscribeCount,
            lastUpdated: DateTime.now(),
            localViewCount: stats.localViewCount,
            localLikeCount: stats.localLikeCount,
            localShareCount: stats.localShareCount + 1,
          );
      }

      await _statsBox.put(key, stats);
    } catch (e) {
      _logger.e('Error updating engagement stats: $e');
    }
  }

  /// Met à jour l'utilisateur actif
  Future<void> _updateActiveUser(
    String userId,
    String platform,
    String contentId,
    String action,
  ) async {
    try {
      final key = '${platform}_$userId';
      var user = _usersBox.get(key);

      user ??= ActiveUser(
          userId: userId,
          platform: platform,
          totalInteractions: 0,
          firstInteractionAt: DateTime.now(),
          lastInteractionAt: DateTime.now(),
          favoriteContentIds: [],
          actionCounts: {},
        );

      user = user.addInteraction(contentId, action);
      await _usersBox.put(key, user);
    } catch (e) {
      _logger.e('Error updating active user: $e');
    }
  }

  /// Récupère les interactions non synchronisées
  Future<List<SocialInteraction>> getUnsyncedInteractions() async {
    try {
      return _interactionsBox.values
          .where((i) => !i.isSyncedToServer)
          .toList();
    } catch (e) {
      _logger.e('Error getting unsynced interactions: $e');
      return [];
    }
  }

  /// Marque une interaction comme synchronisée
  Future<void> markInteractionAsSynced(String interactionId) async {
    try {
      final index = _interactionsBox.values
          .toList()
          .indexWhere((i) => i.id == interactionId);
      if (index != -1) {
        final interaction = _interactionsBox.getAt(index)!;
        await _interactionsBox.putAt(index, interaction.markAsSynced());
      }
    } catch (e) {
      _logger.e('Error marking interaction as synced: $e');
    }
  }

  /// Récupère les statistiques d'engagement pour un contenu
  Future<EngagementStats?> getEngagementStats(
    String contentId,
    String platform,
  ) async {
    try {
      final key = '${platform}_$contentId';
      return _statsBox.get(key);
    } catch (e) {
      _logger.e('Error getting engagement stats: $e');
      return null;
    }
  }

  /// Récupère les utilisateurs actifs pour une plateforme
  Future<List<ActiveUser>> getActiveUsers(String platform) async {
    try {
      return _usersBox.values
          .where((u) => u.platform == platform)
          .toList();
    } catch (e) {
      _logger.e('Error getting active users: $e');
      return [];
    }
  }

  /// Récupère les interactions d'un utilisateur
  Future<List<SocialInteraction>> getUserInteractions(String userId) async {
    try {
      return _interactionsBox.values
          .where((i) => i.userId == userId)
          .toList();
    } catch (e) {
      _logger.e('Error getting user interactions: $e');
      return [];
    }
  }

  /// Récupère les interactions pour un contenu
  Future<List<SocialInteraction>> getContentInteractions(String contentId) async {
    try {
      return _interactionsBox.values
          .where((i) => i.contentId == contentId)
          .toList();
    } catch (e) {
      _logger.e('Error getting content interactions: $e');
      return [];
    }
  }

  /// Récupère les statistiques globales
  Future<GlobalStats> getGlobalStats() async {
    try {
      final allInteractions = _interactionsBox.values.toList();
      final allStats = _statsBox.values.toList();

      int totalViews = 0;
      int totalLikes = 0;
      int totalShares = 0;
      int totalComments = 0;

      for (final stat in allStats) {
        totalViews += stat.viewCount + stat.localViewCount;
        totalLikes += stat.likeCount + stat.localLikeCount;
        totalShares += stat.shareCount + stat.localShareCount;
        totalComments += stat.commentCount;
      }

      return GlobalStats(
        totalInteractions: allInteractions.length,
        totalViews: totalViews,
        totalLikes: totalLikes,
        totalShares: totalShares,
        totalComments: totalComments,
        uniqueUsers: _usersBox.length,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _logger.e('Error getting global stats: $e');
      return GlobalStats(
        totalInteractions: 0,
        totalViews: 0,
        totalLikes: 0,
        totalShares: 0,
        totalComments: 0,
        uniqueUsers: 0,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Efface les interactions synchronisées
  Future<void> clearSyncedInteractions() async {
    try {
      final syncedIds = _interactionsBox.values
          .where((i) => i.isSyncedToServer)
          .map((i) => i.id)
          .toList();

      for (final id in syncedIds) {
        final index = _interactionsBox.values
            .toList()
            .indexWhere((i) => i.id == id);
        if (index != -1) {
          await _interactionsBox.deleteAt(index);
        }
      }
    } catch (e) {
      _logger.e('Error clearing synced interactions: $e');
    }
  }
}

/// Modèle pour les statistiques globales
class GlobalStats {
  final int totalInteractions;
  final int totalViews;
  final int totalLikes;
  final int totalShares;
  final int totalComments;
  final int uniqueUsers;
  final DateTime lastUpdated;

  GlobalStats({
    required this.totalInteractions,
    required this.totalViews,
    required this.totalLikes,
    required this.totalShares,
    required this.totalComments,
    required this.uniqueUsers,
    required this.lastUpdated,
  });

  /// Calcule le taux d'engagement global
  double get globalEngagementRate {
    if (totalViews == 0) return 0;
    final totalEngagement = totalLikes + totalShares + totalComments;
    return (totalEngagement / totalViews) * 100;
  }

  /// Formate les nombres pour l'affichage
  String get formattedTotalViews => _formatNumber(totalViews);
  String get formattedTotalLikes => _formatNumber(totalLikes);
  String get formattedTotalShares => _formatNumber(totalShares);
  String get formattedTotalComments => _formatNumber(totalComments);
  String get formattedUniqueUsers => _formatNumber(uniqueUsers);
}

String _formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}

