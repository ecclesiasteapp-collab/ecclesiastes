import 'package:flutter/material.dart';
import 'package:ecclesiaste/services/ministry_notification_service.dart';

/// Widget pour afficher un indicateur de notifications
class NotificationIndicator extends StatefulWidget {
  final String ministerId;
  final VoidCallback? onTap;
  final bool showBadge;
  final bool showLabel;

  const NotificationIndicator({
    required this.ministerId,
    this.onTap,
    this.showBadge = true,
    this.showLabel = false,
    super.key,
  });

  @override
  State<NotificationIndicator> createState() => _NotificationIndicatorState();
}

class _NotificationIndicatorState extends State<NotificationIndicator> {
  late MinistryNotificationService _notificationService;
  int _unreadCount = 0;
  bool _hasUrgent = false;

  @override
  void initState() {
    super.initState();
    _notificationService = MinistryNotificationService();
    _loadNotifications();
    _notificationService.addUnreadCountListener(_onUnreadCountChanged);
  }

  Future<void> _loadNotifications() async {
    final count = await _notificationService.getTotalNotificationsCount(widget.ministerId);
    final urgent = await _notificationService.getUrgentDirectives(widget.ministerId);
    if (mounted) {
      setState(() {
        _unreadCount = count;
        _hasUrgent = urgent.isNotEmpty;
      });
    }
  }

  void _onUnreadCountChanged(String ministerId, int count) {
    if (ministerId == widget.ministerId && mounted) {
      setState(() => _unreadCount = count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _hasUrgent ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hasUrgent ? Colors.red.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications,
                  color: _hasUrgent ? Colors.red : Colors.blue,
                  size: 18,
                ),
                if (widget.showLabel) ...[
                  const SizedBox(width: 6),
                  Text(
                    _unreadCount > 0 ? '$_unreadCount' : 'Aucune',
                    style: TextStyle(
                      color: _hasUrgent ? Colors.red : Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.showBadge && _unreadCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _hasUrgent ? Colors.red : Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  _unreadCount > 99 ? '99+' : '$_unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _notificationService.removeUnreadCountListener(_onUnreadCountChanged);
    super.dispose();
  }
}

/// Widget pour afficher une bannière d'alerte urgente
class UrgentNotificationBanner extends StatefulWidget {
  final String ministerId;
  final VoidCallback? onDismiss;

  const UrgentNotificationBanner({
    required this.ministerId,
    this.onDismiss,
    super.key,
  });

  @override
  State<UrgentNotificationBanner> createState() => _UrgentNotificationBannerState();
}

class _UrgentNotificationBannerState extends State<UrgentNotificationBanner> {
  late MinistryNotificationService _notificationService;
  List<Map<String, dynamic>> _urgentDirectives = [];
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _notificationService = MinistryNotificationService();
    _loadUrgentDirectives();
  }

  Future<void> _loadUrgentDirectives() async {
    final directives = await _notificationService.getUrgentDirectives(widget.ministerId);
    if (mounted) {
      setState(() => _urgentDirectives = directives);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || _urgentDirectives.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        border: Border.all(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_urgentDirectives.length} directive(s) urgente(s)',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 18),
                onPressed: () {
                  setState(() => _isVisible = false);
                  widget.onDismiss?.call();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._urgentDirectives.take(2).map((directive) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• ${directive['titre'] ?? 'Sans titre'}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
          if (_urgentDirectives.length > 2)
            Text(
              '+ ${_urgentDirectives.length - 2} autre(s)',
              style: TextStyle(
                color: Colors.red.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget pour afficher les notifications expirantes
class ExpiringNotificationAlert extends StatefulWidget {
  final String ministerId;
  final VoidCallback? onViewAll;

  const ExpiringNotificationAlert({
    required this.ministerId,
    this.onViewAll,
    super.key,
  });

  @override
  State<ExpiringNotificationAlert> createState() => _ExpiringNotificationAlertState();
}

class _ExpiringNotificationAlertState extends State<ExpiringNotificationAlert> {
  late MinistryNotificationService _notificationService;
  List<Map<String, dynamic>> _expiringDirectives = [];

  @override
  void initState() {
    super.initState();
    _notificationService = MinistryNotificationService();
    _loadExpiringDirectives();
  }

  Future<void> _loadExpiringDirectives() async {
    final directives = await _notificationService.getExpiringDirectives(widget.ministerId);
    if (mounted) {
      setState(() => _expiringDirectives = directives);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_expiringDirectives.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        border: Border.all(color: Colors.orange, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_expiringDirectives.length} directive(s) expire(nt) bientôt',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._expiringDirectives.take(2).map((directive) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• ${directive['titre'] ?? 'Sans titre'}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
          if (_expiringDirectives.length > 2)
            Text(
              '+ ${_expiringDirectives.length - 2} autre(s)',
              style: TextStyle(
                color: Colors.orange.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          const SizedBox(height: 8),
          if (widget.onViewAll != null)
            TextButton(
              onPressed: widget.onViewAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
              ),
              child: const Text(
                'Voir toutes les directives',
                style: TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

