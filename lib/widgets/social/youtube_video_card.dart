import 'package:flutter/material.dart';
import 'package:ecclesiaste/services/youtube_integration_service.dart';
import 'package:ecclesiaste/services/social_interaction_tracker_service.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget pour afficher une vidéo YouTube avec tracking des interactions
class YouTubeVideoCard extends StatefulWidget {
  final YouTubeVideo video;
  final YouTubeVideoStats? stats;
  final VoidCallback? onViewMore;
  final bool showStats;

  const YouTubeVideoCard({
    required this.video,
    this.stats,
    this.onViewMore,
    this.showStats = true,
    super.key,
  });

  @override
  State<YouTubeVideoCard> createState() => _YouTubeVideoCardState();
}

class _YouTubeVideoCardState extends State<YouTubeVideoCard> {
  late SocialInteractionTrackerService _trackerService;
  bool _liked = false;
  bool _shared = false;

  @override
  void initState() {
    super.initState();
    _trackerService = SocialInteractionTrackerService();
    _trackView();
  }

  Future<void> _trackView() async {
    final user = AuthService.currentUser;
    if (user != null) {
      await _trackerService.trackInteraction(
        userId: user.id,
        contentId: widget.video.id,
        platform: 'youtube',
        contentType: 'video',
        action: 'view',
        contentTitle: widget.video.title,
        contentDescription: widget.video.description,
      );
    }
  }

  Future<void> _trackLike() async {
    final user = AuthService.currentUser;
    if (user != null) {
      await _trackerService.trackInteraction(
        userId: user.id,
        contentId: widget.video.id,
        platform: 'youtube',
        contentType: 'video',
        action: 'like',
        contentTitle: widget.video.title,
      );
      setState(() => _liked = true);
    }
  }

  Future<void> _trackShare() async {
    final user = AuthService.currentUser;
    if (user != null) {
      await _trackerService.trackInteraction(
        userId: user.id,
        contentId: widget.video.id,
        platform: 'youtube',
        contentType: 'video',
        action: 'share',
        contentTitle: widget.video.title,
      );
      setState(() => _shared = true);
    }
  }

  Future<void> _openVideo() async {
    final url = 'https://www.youtube.com/watch?v=${widget.video.id}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          GestureDetector(
            onTap: _openVideo,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    widget.video.thumbnail,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                // Play button overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.red,
                        size: 56,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.video.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Channel and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.video.channelTitle,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatDate(widget.video.publishedAt),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                if (widget.showStats && widget.stats != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.visibility,
                          label: 'Vues',
                          value: widget.stats!.formattedViewCount,
                        ),
                        _StatItem(
                          icon: Icons.thumb_up,
                          label: 'J\'aime',
                          value: widget.stats!.formattedLikeCount,
                        ),
                        _StatItem(
                          icon: Icons.comment,
                          label: 'Commentaires',
                          value: widget.stats!.formattedCommentCount,
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      icon: Icons.thumb_up,
                      label: "J'aime",
                      isActive: _liked,
                      onTap: _trackLike,
                    ),
                    _ActionButton(
                      icon: Icons.share,
                      label: 'Partager',
                      isActive: _shared,
                      onTap: _trackShare,
                    ),
                    _ActionButton(
                      icon: Icons.open_in_new,
                      label: 'Ouvrir',
                      onTap: _openVideo,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui";
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      return 'Il y a ${(difference.inDays / 7).floor()} semaines';
    } else {
      return 'Il y a ${(difference.inDays / 30).floor()} mois';
    }
  }
}

/// Widget pour afficher une statistique
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.red, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

/// Widget pour un bouton d'action
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.red : Colors.grey[400],
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.red : Colors.grey[400],
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

