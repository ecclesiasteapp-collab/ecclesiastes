import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Service d'intégration YouTube pour Ecclesiaste
/// Gère la récupération des vidéos, statistiques et interactions
class YouTubeIntegrationService {
  static final YouTubeIntegrationService _instance = YouTubeIntegrationService._internal();
  final Logger _logger = Logger();
  final Dio _dio = Dio();

  // Identifiants de l'application Ecclesiaste
  static const String channelId = 'UCEcclesiasteKSO'; // À remplacer par votre vrai Channel ID
  static const String apiKey = ''; // À configurer avec votre YouTube API Key
  static const String email = 'ecclesiaste.app@gmail.com';
  static const String phone = '+243894474725';

  factory YouTubeIntegrationService() {
    return _instance;
  }

  YouTubeIntegrationService._internal();

  /// Récupère les dernières vidéos de la chaîne
  Future<List<YouTubeVideo>> getChannelVideos({
    int maxResults = 10,
    String? order = 'date', // 'date', 'rating', 'relevance', 'viewCount'
  }) async {
    try {
      if (apiKey.isEmpty) {
        _logger.e('YouTube API Key not configured');
        return [];
      }

      final response = await _dio.get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          'key': apiKey,
          'channelId': channelId,
          'part': 'snippet',
          'order': order,
          'maxResults': maxResults,
          'type': 'video',
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List?;
        if (items != null) {
          return items
              .map((item) => YouTubeVideo.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      _logger.e('Error fetching YouTube videos: $e');
      return [];
    }
  }

  /// Récupère les statistiques d'une vidéo spécifique
  Future<YouTubeVideoStats?> getVideoStats(String videoId) async {
    try {
      if (apiKey.isEmpty) {
        _logger.e('YouTube API Key not configured');
        return null;
      }

      final response = await _dio.get(
        'https://www.googleapis.com/youtube/v3/videos',
        queryParameters: {
          'key': apiKey,
          'id': videoId,
          'part': 'statistics,snippet,contentDetails',
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List?;
        if (items != null && items.isNotEmpty) {
          return YouTubeVideoStats.fromJson(items[0]);
        }
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching video stats: $e');
      return null;
    }
  }

  /// Récupère les statistiques de la chaîne
  Future<YouTubeChannelStats?> getChannelStats() async {
    try {
      if (apiKey.isEmpty) {
        _logger.e('YouTube API Key not configured');
        return null;
      }

      final response = await _dio.get(
        'https://www.googleapis.com/youtube/v3/channels',
        queryParameters: {
          'key': apiKey,
          'id': channelId,
          'part': 'statistics,snippet,contentDetails',
        },
      );

      if (response.statusCode == 200) {
        final items = response.data['items'] as List?;
        if (items != null && items.isNotEmpty) {
          return YouTubeChannelStats.fromJson(items[0]);
        }
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching channel stats: $e');
      return null;
    }
  }

  /// Enregistre une vue de vidéo (pour suivi analytique)
  Future<void> trackVideoView(String videoId, String userId) async {
    try {
      // Cette fonction peut être utilisée pour enregistrer les vues localement
      // et les synchroniser avec votre backend
      _logger.i('Video view tracked: $videoId by user: $userId');
    } catch (e) {
      _logger.e('Error tracking video view: $e');
    }
  }

  /// Enregistre un engagement utilisateur
  Future<void> trackVideoEngagement(String videoId, String userId, String action) async {
    try {
      // Actions possibles: 'like', 'share', 'comment', 'subscribe'
      _logger.i('Video engagement tracked: $videoId - $action by user: $userId');
    } catch (e) {
      _logger.e('Error tracking engagement: $e');
    }
  }
}

/// Modèle pour une vidéo YouTube
class YouTubeVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final DateTime publishedAt;
  final String channelTitle;

  YouTubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.publishedAt,
    required this.channelTitle,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    return YouTubeVideo(
      id: json['id']?['videoId'] ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnail: snippet['thumbnails']?['medium']?['url'] ?? '',
      publishedAt: DateTime.tryParse(snippet['publishedAt'] ?? '') ?? DateTime.now(),
      channelTitle: snippet['channelTitle'] ?? '',
    );
  }
}

/// Modèle pour les statistiques d'une vidéo
class YouTubeVideoStats {
  final String videoId;
  final String title;
  final String description;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final Duration duration;
  final DateTime publishedAt;

  YouTubeVideoStats({
    required this.videoId,
    required this.title,
    required this.description,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.duration,
    required this.publishedAt,
  });

  factory YouTubeVideoStats.fromJson(Map<String, dynamic> json) {
    final stats = json['statistics'] ?? {};
    final snippet = json['snippet'] ?? {};
    final contentDetails = json['contentDetails'] ?? {};

    // Parse ISO 8601 duration
    final durationStr = contentDetails['duration'] ?? 'PT0S';
    final duration = _parseDuration(durationStr);

    return YouTubeVideoStats(
      videoId: json['id'] ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      viewCount: int.tryParse(stats['viewCount']?.toString() ?? '0') ?? 0,
      likeCount: int.tryParse(stats['likeCount']?.toString() ?? '0') ?? 0,
      commentCount: int.tryParse(stats['commentCount']?.toString() ?? '0') ?? 0,
      duration: duration,
      publishedAt: DateTime.tryParse(snippet['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Calcule le taux d'engagement (likes / views)
  double get engagementRate {
    if (viewCount == 0) return 0;
    return (likeCount / viewCount) * 100;
  }

  /// Formate les nombres pour l'affichage
  String get formattedViewCount => _formatNumber(viewCount);
  String get formattedLikeCount => _formatNumber(likeCount);
  String get formattedCommentCount => _formatNumber(commentCount);
}

/// Modèle pour les statistiques de la chaîne
class YouTubeChannelStats {
  final String channelId;
  final String channelTitle;
  final String description;
  final String thumbnail;
  final int subscriberCount;
  final int videoCount;
  final int viewCount;

  YouTubeChannelStats({
    required this.channelId,
    required this.channelTitle,
    required this.description,
    required this.thumbnail,
    required this.subscriberCount,
    required this.videoCount,
    required this.viewCount,
  });

  factory YouTubeChannelStats.fromJson(Map<String, dynamic> json) {
    final stats = json['statistics'] ?? {};
    final snippet = json['snippet'] ?? {};

    return YouTubeChannelStats(
      channelId: json['id'] ?? '',
      channelTitle: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnail: snippet['thumbnails']?['medium']?['url'] ?? '',
      subscriberCount: int.tryParse(stats['subscriberCount']?.toString() ?? '0') ?? 0,
      videoCount: int.tryParse(stats['videoCount']?.toString() ?? '0') ?? 0,
      viewCount: int.tryParse(stats['viewCount']?.toString() ?? '0') ?? 0,
    );
  }

  String get formattedSubscriberCount => _formatNumber(subscriberCount);
  String get formattedVideoCount => _formatNumber(videoCount);
  String get formattedViewCount => _formatNumber(viewCount);
}

/// Utilitaires
Duration _parseDuration(String duration) {
  final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
  final match = regex.firstMatch(duration);
  if (match == null) return Duration.zero;

  final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
  final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
  final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

String _formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}

