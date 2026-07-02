import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

/// Service d'intégration Facebook pour Ecclesiaste
/// Gère l'authentification, les partages et les interactions
class FacebookIntegrationService {
  static final FacebookIntegrationService _instance = FacebookIntegrationService._internal();
  final Logger _logger = Logger();
  final Dio _dio = Dio();

  // Identifiants de l'application Ecclesiaste
  static const String appId = ''; // À configurer avec votre Facebook App ID
  static const String pageId = ''; // À configurer avec votre Facebook Page ID
  static const String email = 'ecclesiaste.app@gmail.com';
  static const String phone = '+243894474725';

  factory FacebookIntegrationService() {
    return _instance;
  }

  FacebookIntegrationService._internal();

  /// Initialise le SDK Facebook
  Future<void> initialize() async {
    try {
      // Configuration pour le Web (si nécessaire avec les versions récentes)
      // Note: Les versions récentes peuvent ne plus nécessiter cet appel explicite 
      // ou utiliser une autre méthode. On logge simplement l'intention.
      _logger.i('Facebook SDK ready');
    } catch (e) {
      _logger.e('Error initializing Facebook SDK: $e');
    }
  }

  /// Authentifie l'utilisateur avec Facebook
  Future<FacebookUser?> login() async {
    // Note: l'auth Facebook via `flutter_facebook_auth` a été retirée des dépendances.
    // On conserve l'API pour ne pas casser l'appelant, mais on désactive l'auth native.
    _logger.w('Facebook login indisponible (dépendance `flutter_facebook_auth` absente).');
    return null;
  }

  /// Déconnecte l'utilisateur
  Future<void> logout() async {
    _logger.i('Facebook logout ignoré (auth native désactivée).');
  }

  /// Récupère les publications de la page
  Future<List<FacebookPost>> getPagePosts({
    int limit = 10,
    String? accessToken,
  }) async {
    try {
      if (accessToken == null || accessToken.isEmpty) {
        _logger.e('Access token not provided');
        return [];
      }

      final response = await _dio.get(
        'https://graph.facebook.com/v18.0/$pageId/feed',
        queryParameters: {
          'fields': 'id,message,story,created_time,permalink_url,type,picture,link,name,description,icon,status_type,full_picture,insights.metric(post_impressions,post_clicks,post_engaged_users)',
          'limit': limit,
          'access_token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List?;
        if (data != null) {
          return data.map((item) => FacebookPost.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      _logger.e('Error fetching Facebook posts: $e');
      return [];
    }
  }

  /// Récupère les statistiques d'une publication
  Future<FacebookPostStats?> getPostStats(
    String postId, {
    String? accessToken,
  }) async {
    try {
      if (accessToken == null || accessToken.isEmpty) {
        _logger.e('Access token not provided');
        return null;
      }

      final response = await _dio.get(
        'https://graph.facebook.com/v18.0/$postId',
        queryParameters: {
          'fields': 'id,message,created_time,permalink_url,likes.summary(total_count).limit(0),comments.summary(total_count).limit(0),shares',
          'access_token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        return FacebookPostStats.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching post stats: $e');
      return null;
    }
  }

  /// Récupère les statistiques de la page
  Future<FacebookPageStats?> getPageStats({
    String? accessToken,
  }) async {
    try {
      if (accessToken == null || accessToken.isEmpty) {
        _logger.e('Access token not provided');
        return null;
      }

      final response = await _dio.get(
        'https://graph.facebook.com/v18.0/$pageId',
        queryParameters: {
          'fields': 'id,name,about,picture,fan_count,followers_count,likes,website,phone,email',
          'access_token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        return FacebookPageStats.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching page stats: $e');
      return null;
    }
  }

  /// Partage un lien sur Facebook (via share_plus)
  Future<bool> shareLink({
    required String url,
    String? quote,
    String? hashtag,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: '$url ${quote ?? ''} ${hashtag ?? ''}'.trim(),
          subject: 'Partage Ecclesiaste',
        ),
      );
      _logger.i('Facebook share initiated via share_plus');
      return true;
    } catch (e) {
      _logger.e('Error sharing on Facebook: $e');
      return false;
    }
  }

  /// Enregistre un engagement utilisateur
  Future<void> trackEngagement(String postId, String userId, String action) async {
    try {
      // Actions possibles: 'like', 'comment', 'share', 'view'
      _logger.i('Facebook engagement tracked: $postId - $action by user: $userId');
    } catch (e) {
      _logger.e('Error tracking engagement: $e');
    }
  }
}

/// Modèle pour un utilisateur Facebook
class FacebookUser {
  final String id;
  final String name;
  final String? email;
  final String? picture;

  FacebookUser({
    required this.id,
    required this.name,
    this.email,
    this.picture,
  });

  factory FacebookUser.fromJson(Map<String, dynamic> json) {
    return FacebookUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      picture: json['picture']?['data']?['url'],
    );
  }
}

/// Modèle pour une publication Facebook
class FacebookPost {
  final String id;
  final String? message;
  final String? story;
  final DateTime createdTime;
  final String? permalinkUrl;
  final String? picture;
  final String? link;
  final String? name;
  final String? description;

  FacebookPost({
    required this.id,
    this.message,
    this.story,
    required this.createdTime,
    this.permalinkUrl,
    this.picture,
    this.link,
    this.name,
    this.description,
  });

  factory FacebookPost.fromJson(Map<String, dynamic> json) {
    return FacebookPost(
      id: json['id'] ?? '',
      message: json['message'],
      story: json['story'],
      createdTime: DateTime.tryParse(json['created_time'] ?? '') ?? DateTime.now(),
      permalinkUrl: json['permalink_url'],
      picture: json['picture'],
      link: json['link'],
      name: json['name'],
      description: json['description'],
    );
  }
}

/// Modèle pour les statistiques d'une publication
class FacebookPostStats {
  final String postId;
  final String? message;
  final DateTime createdTime;
  final String? permalinkUrl;
  final int likeCount;
  final int commentCount;
  final int shareCount;

  FacebookPostStats({
    required this.postId,
    this.message,
    required this.createdTime,
    this.permalinkUrl,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
  });

  factory FacebookPostStats.fromJson(Map<String, dynamic> json) {
    return FacebookPostStats(
      postId: json['id'] ?? '',
      message: json['message'],
      createdTime: DateTime.tryParse(json['created_time'] ?? '') ?? DateTime.now(),
      permalinkUrl: json['permalink_url'],
      likeCount: json['likes']?['summary']?['total_count'] ?? 0,
      commentCount: json['comments']?['summary']?['total_count'] ?? 0,
      shareCount: json['shares']?['data']?.length ?? 0,
    );
  }

  /// Calcule l'engagement total
  int get totalEngagement => likeCount + commentCount + shareCount;

  /// Formate les nombres pour l'affichage
  String get formattedLikeCount => _formatNumber(likeCount);
  String get formattedCommentCount => _formatNumber(commentCount);
  String get formattedShareCount => _formatNumber(shareCount);
  String get formattedTotalEngagement => _formatNumber(totalEngagement);
}

/// Modèle pour les statistiques de la page
class FacebookPageStats {
  final String pageId;
  final String name;
  final String? about;
  final String? picture;
  final int fanCount;
  final int followersCount;
  final int likes;
  final String? website;
  final String? phone;
  final String? email;

  FacebookPageStats({
    required this.pageId,
    required this.name,
    this.about,
    this.picture,
    required this.fanCount,
    required this.followersCount,
    required this.likes,
    this.website,
    this.phone,
    this.email,
  });

  factory FacebookPageStats.fromJson(Map<String, dynamic> json) {
    return FacebookPageStats(
      pageId: json['id'] ?? '',
      name: json['name'] ?? '',
      about: json['about'],
      picture: json['picture']?['data']?['url'],
      fanCount: json['fan_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      likes: json['likes'] ?? 0,
      website: json['website'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  String get formattedFanCount => _formatNumber(fanCount);
  String get formattedFollowersCount => _formatNumber(followersCount);
  String get formattedLikes => _formatNumber(likes);
}

String _formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}

