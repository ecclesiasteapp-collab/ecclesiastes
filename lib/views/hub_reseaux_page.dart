import 'package:flutter/material.dart';
import 'package:ecclesiaste/services/social_media_aggregator_service.dart';
import 'package:ecclesiaste/services/social_interaction_tracker_service.dart';
import 'package:ecclesiaste/services/youtube_integration_service.dart';
import 'package:ecclesiaste/services/facebook_integration_service.dart';
import 'package:ecclesiaste/widgets/social/youtube_video_card.dart';
import 'package:ecclesiaste/widgets/social/facebook_post_card.dart';
import 'package:logger/logger.dart';

/// Page complète du Hub Réseaux avec intégration YouTube et Facebook
class HubReseauxPage extends StatefulWidget {
  const HubReseauxPage({super.key});

  @override
  State<HubReseauxPage> createState() => _HubReseauxPageState();
}

class _HubReseauxPageState extends State<HubReseauxPage> with SingleTickerProviderStateMixin {
  late SocialMediaAggregatorService _aggregatorService;
  late SocialInteractionTrackerService _trackerService;
  late TabController _tabController;
  final Logger _logger = Logger();

  AggregatedContent? _aggregatedContent;
  SocialMediaSummary? _summary;
  GlobalStats? _globalStats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _aggregatorService = SocialMediaAggregatorService();
    _trackerService = SocialInteractionTrackerService();
    _tabController = TabController(length: 3, vsync: this);
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    try {
      setState(() => _isLoading = true);
      await _aggregatorService.initialize();
      await _trackerService.initialize();
      await _loadData();
    } catch (e) {
      _logger.e('Error initializing Hub: $e');
      setState(() => _error = 'Erreur lors du chargement du Hub Réseaux');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadData() async {
    try {
      final content = await _aggregatorService.getRecentContent(limit: 20);
      final summary = await _aggregatorService.getSocialMediaSummary();
      final stats = await _trackerService.getGlobalStats();

      setState(() {
        _aggregatedContent = content;
        _summary = summary;
        _globalStats = stats;
        _error = null;
      });
    } catch (e) {
      _logger.e('Error loading data: $e');
      setState(() => _error = 'Impossible de charger les données');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B6B9E),
        elevation: 0,
        title: const Text(
          'Hub Réseaux Ecclesiaste',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tous'),
            Tab(text: 'YouTube'),
            Tab(text: 'Facebook'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B6B9E)),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllContentTab(),
                      _buildYouTubeTab(),
                      _buildFacebookTab(),
                    ],
                  ),
                ),
    );
  }

  /// Onglet avec tous les contenus
  Widget _buildAllContentTab() {
    if (_aggregatedContent == null || _aggregatedContent!.allContent.isEmpty) {
      return const Center(
        child: Text(
          'Aucun contenu disponible',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (_summary != null) _buildSummaryCard(),
        const SizedBox(height: 16),
        if (_globalStats != null) _buildGlobalStatsCard(),
        const SizedBox(height: 16),
        const Text(
          'Contenus Récents',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ..._buildContentList(_aggregatedContent!.allContent),
      ],
    );
  }

  /// Onglet YouTube
  Widget _buildYouTubeTab() {
    final youtubeContent = _aggregatedContent?.youtubeVideos ?? [];

    if (youtubeContent.isEmpty) {
      return const Center(
        child: Text(
          'Aucune vidéo YouTube disponible',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (_summary?.youtubeStats != null) _buildYouTubeStatsCard(),
        const SizedBox(height: 16),
        ...youtubeContent.map((video) => YouTubeVideoCard(
          video: video,
          showStats: true,
        )),
      ],
    );
  }

  /// Onglet Facebook
  Widget _buildFacebookTab() {
    final facebookContent = _aggregatedContent?.facebookPosts ?? [];

    if (facebookContent.isEmpty) {
      return const Center(
        child: Text(
          'Aucune publication Facebook disponible',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (_summary?.facebookStats != null) _buildFacebookStatsCard(),
        const SizedBox(height: 16),
        ...facebookContent.map((post) => FacebookPostCard(
          post: post,
          showStats: true,
        )),
      ],
    );
  }

  /// Carte de résumé
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Résumé Global',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(
                icon: Icons.visibility,
                label: 'Vues',
                value: _summary?.formattedTotalViews ?? '0',
              ),
              _SummaryItem(
                icon: Icons.people,
                label: 'Abonnés',
                value: _summary?.formattedTotalFollowers ?? '0',
              ),
              _SummaryItem(
                icon: Icons.video_library,
                label: 'Contenus',
                value: _summary?.formattedTotalContent ?? '0',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Carte des statistiques globales
  Widget _buildGlobalStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A4A6F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistiques Locales',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatsItem(
                icon: Icons.visibility,
                label: 'Vues App',
                value: _globalStats?.formattedTotalViews ?? '0',
              ),
              _StatsItem(
                icon: Icons.thumb_up,
                label: 'Likes App',
                value: _globalStats?.formattedTotalLikes ?? '0',
              ),
              _StatsItem(
                icon: Icons.share,
                label: 'Partages',
                value: _globalStats?.formattedTotalShares ?? '0',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Engagement: ${_globalStats?.globalEngagementRate.toStringAsFixed(2)}%',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Carte des statistiques YouTube
  Widget _buildYouTubeStatsCard() {
    final stats = _summary!.youtubeStats!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF0000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    '▶',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stats.channelTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${stats.formattedSubscriberCount} abonnés',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatsItem(
                icon: Icons.visibility,
                label: 'Vues',
                value: stats.formattedViewCount,
              ),
              _StatsItem(
                icon: Icons.video_library,
                label: 'Vidéos',
                value: stats.formattedVideoCount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Carte des statistiques Facebook
  Widget _buildFacebookStatsCard() {
    final stats = _summary!.facebookStats!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A4F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1877F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1877F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'f',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stats.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${stats.formattedFanCount} fans',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatsItem(
                icon: Icons.people,
                label: 'Fans',
                value: stats.formattedFanCount,
              ),
              _StatsItem(
                icon: Icons.thumb_up,
                label: 'Likes',
                value: stats.formattedLikes,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit la liste des contenus
  List<Widget> _buildContentList(List<SocialContent> content) {
    return content.map((item) {
      if (item.type == 'video') {
        // Trouver la vidéo correspondante
        final video = _aggregatedContent?.youtubeVideos
            .cast<YouTubeVideo?>()
            .firstWhere((v) => v?.id == item.id, orElse: () => null);
        if (video != null) {
          return YouTubeVideoCard(video: video, showStats: false);
        }
      } else if (item.type == 'post') {
        // Trouver la publication correspondante
        final post = _aggregatedContent?.facebookPosts
            .cast<FacebookPost?>()
            .firstWhere((p) => p?.id == item.id, orElse: () => null);
        if (post != null) {
          return FacebookPostCard(post: post, showStats: false);
        }
      }
      return const SizedBox.shrink();
    }).toList();
  }
}

/// Widget pour afficher un élément de résumé
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B6B9E), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// Widget pour afficher une statistique
class _StatsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatsItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}


