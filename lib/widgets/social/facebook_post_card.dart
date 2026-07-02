import 'package:flutter/material.dart';
import 'package:ecclesiastes/services/facebook_integration_service.dart';
import 'package:ecclesiastes/services/social_interaction_tracker_service.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget pour afficher une publication Facebook avec tracking des interactions
class FacebookPostCard extends StatefulWidget {
  final FacebookPost post;
  final FacebookPostStats? stats;
  final VoidCallback? onViewMore;
  final bool showStats;

  const FacebookPostCard({
    required this.post,
    this.stats,
    this.onViewMore,
    this.showStats = true,
    super.key,
  });

  @override
  State<FacebookPostCard> createState() => _FacebookPostCardState();
}

class _FacebookPostCardState extends State<FacebookPostCard> {
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
        contentId: widget.post.id,
        platform: 'facebook',
        contentType: 'post',
        action: 'view',
        contentTitle: widget.post.name,
        contentDescription: widget.post.message ?? widget.post.description,
      );
    }
  }

  Future<void> _trackLike() async {
    final user = AuthService.currentUser;
    if (user != null) {
      await _trackerService.trackInteraction(
        userId: user.id,
        contentId: widget.post.id,
        platform: 'facebook',
        contentType: 'post',
        action: 'like',
        contentTitle: widget.post.name,
      );
      setState(() => _liked = true);
    }
  }

  Future<void> _trackShare() async {
    final user = AuthService.currentUser;
    if (user != null) {
      await _trackerService.trackInteraction(
        userId: user.id,
        contentId: widget.post.id,
        platform: 'facebook',
        contentType: 'post',
        action: 'share',
        contentTitle: widget.post.name,
      );
      setState(() => _shared = true);
    }
  }

  Future<void> _openPost() async {
    if (widget.post.permalinkUrl != null) {
      if (await canLaunchUrl(Uri.parse(widget.post.permalinkUrl!))) {
        await launchUrl(
          Uri.parse(widget.post.permalinkUrl!),
          mode: LaunchMode.externalApplication,
        );
      }
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
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
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
                      const Text(
                        'Ecclesiaste',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(widget.post.createdTime),
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
          ),

          const Divider(color: Colors.grey, height: 1),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.name != null)
                  Text(
                    widget.post.name!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (widget.post.message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.post.message!,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 13,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (widget.post.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.post.description!,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Image if available
          if (widget.post.picture != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.post.picture!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

          // Stats
          if (widget.showStats && widget.stats != null) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.thumb_up,
                      label: "J'aime",
                      value: widget.stats!.formattedLikeCount,
                    ),
                    _StatItem(
                      icon: Icons.comment,
                      label: 'Commentaires',
                      value: widget.stats!.formattedCommentCount,
                    ),
                    _StatItem(
                      icon: Icons.share,
                      label: 'Partages',
                      value: widget.stats!.formattedShareCount,
                    ),
                  ],
                ),
              ),
            ),
          ],

          const Divider(color: Colors.grey, height: 1),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.thumb_up,
                  label: "J'aime",
                  isActive: _liked,
                  onTap: _trackLike,
                ),
                _ActionButton(
                  icon: Icons.comment,
                  label: 'Commenter',
                  onTap: () {},
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
                  onTap: _openPost,
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

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return 'Il y a ${(difference.inDays / 7).floor()} semaines';
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
        Icon(icon, color: const Color(0xFF1877F2), size: 16),
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
            color: isActive ? const Color(0xFF1877F2) : Colors.grey[400],
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF1877F2) : Colors.grey[400],
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

