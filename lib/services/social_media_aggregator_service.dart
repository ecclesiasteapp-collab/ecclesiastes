import 'package:ecclesiaste/services/youtube_integration_service.dart';
import 'package:ecclesiaste/services/facebook_integration_service.dart';
import 'package:logger/logger.dart';

/// Service agrégateur pour centraliser toutes les données sociales
/// Combine YouTube, Facebook et autres réseaux sociaux
class SocialMediaAggregatorService {
  static final SocialMediaAggregatorService _instance = SocialMediaAggregatorService._internal();
  final Logger _logger = Logger();

  late YouTubeIntegrationService _youtubeService;
  late FacebookIntegrationService _facebookService;

  factory SocialMediaAggregatorService() {
    return _instance;
  }

  SocialMediaAggregatorService._internal() {
    _youtubeService = YouTubeIntegrationService();
    _facebookService = FacebookIntegrationService();
  }

  /// Initialise tous les services
  Future<void> initialize() async {
    try {
      await _facebookService.initialize();
      _logger.i('Social Media Aggregator initialized');
    } catch (e) {
      _logger.e('Error initializing Social Media Aggregator: $e');
    }
  }

  /// Récupère un résumé complet des statistiques sociales
  Future<SocialMediaSummary> getSocialMediaSummary() async {
    try {
      final youtubeStats = await _youtubeService.getChannelStats();
      // Note: Pour Facebook, il faudrait un accessToken valide
      // const facebookStats = await _facebookService.getPageStats();

      return SocialMediaSummary(
        youtubeStats: youtubeStats,
        facebookStats: null, // À implémenter avec authentification
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _logger.e('Error getting social media summary: $e');
      return SocialMediaSummary(
        youtubeStats: null,
        facebookStats: null,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Récupère les contenus récents de tous les réseaux
  Future<AggregatedContent> getRecentContent({
    int limit = 10,
    String? facebookAccessToken,
  }) async {
    try {
      final youtubeVideos = await _youtubeService.getChannelVideos(maxResults: limit);
      final facebookPosts = facebookAccessToken != null
          ? await _facebookService.getPagePosts(limit: limit, accessToken: facebookAccessToken)
          : <FacebookPost>[];

      return AggregatedContent(
        youtubeVideos: youtubeVideos,
        facebookPosts: facebookPosts,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _logger.e('Error getting aggregated content: $e');
      return AggregatedContent(
        youtubeVideos: [],
        facebookPosts: [],
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Récupère les statistiques détaillées d'une vidéo YouTube
  Future<YouTubeVideoStats?> getYouTubeVideoStats(String videoId) async {
    return _youtubeService.getVideoStats(videoId);
  }

  /// Récupère les statistiques détaillées d'une publication Facebook
  Future<FacebookPostStats?> getFacebookPostStats(
    String postId, {
    String? accessToken,
  }) async {
    return _facebookService.getPostStats(postId, accessToken: accessToken);
  }

  /// Enregistre une interaction utilisateur
  Future<void> trackUserInteraction({
    required String platform, // 'youtube' ou 'facebook'
    required String contentId,
    required String userId,
    required String action, // 'view', 'like', 'share', 'comment'
    Map<String, dynamic>? metadata,
  }) async {
    try {
      if (platform == 'youtube') {
        await _youtubeService.trackVideoEngagement(contentId, userId, action);
      } else if (platform == 'facebook') {
        await _facebookService.trackEngagement(contentId, userId, action);
      }
      _logger.i('User interaction tracked: $platform - $contentId - $action');
    } catch (e) {
      _logger.e('Error tracking user interaction: $e');
    }
  }

  /// Obtient les services individuels si nécessaire
  YouTubeIntegrationService get youtubeService => _youtubeService;
  FacebookIntegrationService get facebookService => _facebookService;
}

/// Modèle pour le résumé des statistiques sociales
class SocialMediaSummary {
  final YouTubeChannelStats? youtubeStats;
  final FacebookPageStats? facebookStats;
  final DateTime lastUpdated;

  SocialMediaSummary({
    this.youtubeStats,
    this.facebookStats,
    required this.lastUpdated,
  });

  /// Calcule le nombre total de vues
  int get totalViews => (youtubeStats?.viewCount ?? 0) + (facebookStats?.likes ?? 0);

  /// Calcule le nombre total d'abonnés/fans
  int get totalFollowers =>
      (youtubeStats?.subscriberCount ?? 0) + (facebookStats?.fanCount ?? 0);

  /// Calcule le nombre total de contenus
  int get totalContent => (youtubeStats?.videoCount ?? 0);

  /// Formate les nombres pour l'affichage
  String get formattedTotalViews => _formatNumber(totalViews);
  String get formattedTotalFollowers => _formatNumber(totalFollowers);
  String get formattedTotalContent => _formatNumber(totalContent);

  /// Vérifie si les données sont à jour (moins de 1 heure)
  bool get isUpToDate {
    final now = DateTime.now();
    return now.difference(lastUpdated).inMinutes < 60;
  }
}

/// Modèle pour le contenu agrégé
class AggregatedContent {
  final List<YouTubeVideo> youtubeVideos;
  final List<FacebookPost> facebookPosts;
  final DateTime lastUpdated;

  AggregatedContent({
    required this.youtubeVideos,
    required this.facebookPosts,
    required this.lastUpdated,
  });

  /// Obtient tous les contenus fusionnés et triés par date
  List<SocialContent> get allContent {
    final content = <SocialContent>[];

    // Ajouter les vidéos YouTube
    for (final video in youtubeVideos) {
      content.add(SocialContent.youtube(
        id: video.id,
        title: video.title,
        description: video.description,
        thumbnail: video.thumbnail,
        publishedAt: video.publishedAt,
        platform: 'YouTube',
      ));
    }

    // Ajouter les publications Facebook
    for (final post in facebookPosts) {
      content.add(SocialContent.facebook(
        id: post.id,
        title: post.name ?? 'Publication',
        description: post.message ?? post.description ?? '',
        thumbnail: post.picture,
        publishedAt: post.createdTime,
        platform: 'Facebook',
      ));
    }

    // Trier par date (plus récent en premier)
    content.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return content;
  }

  /// Nombre total de contenus
  int get totalContent => youtubeVideos.length + facebookPosts.length;
}

/// Modèle pour un contenu social générique
class SocialContent {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final DateTime publishedAt;
  final String platform;
  final String type; // 'video' ou 'post'

  SocialContent({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnail,
    required this.publishedAt,
    required this.platform,
    required this.type,
  });

  factory SocialContent.youtube({
    required String id,
    required String title,
    required String description,
    String? thumbnail,
    required DateTime publishedAt,
    required String platform,
  }) {
    return SocialContent(
      id: id,
      title: title,
      description: description,
      thumbnail: thumbnail,
      publishedAt: publishedAt,
      platform: platform,
      type: 'video',
    );
  }

  factory SocialContent.facebook({
    required String id,
    required String title,
    required String description,
    String? thumbnail,
    required DateTime publishedAt,
    required String platform,
  }) {
    return SocialContent(
      id: id,
      title: title,
      description: description,
      thumbnail: thumbnail,
      publishedAt: publishedAt,
      platform: platform,
      type: 'post',
    );
  }

  /// Obtient l'icône de la plateforme
  String get platformIcon {
    switch (platform) {
      case 'YouTube':
        return '▶';
      case 'Facebook':
        return 'f';
      case 'Instagram':
        return '📷';
      default:
        return '📰';
    }
  }
}

String _formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}

