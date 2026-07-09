import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecclesiaste/views/reports/my_reports_screen.dart';
import 'package:ecclesiaste/views/create_report_screen.dart';
import '../models/notification_model.dart';
import '../services/auth_service.dart';
import '../services/database_helper.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<AppNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      _notificationsFuture = DatabaseHelper.instance.getNotificationsForUser(currentUser.id);
    } else {
      _notificationsFuture = Future.value([]);
    }
  }

  Future<void> _onNotificationTapped(AppNotification notif) async {
    // Marquer la notification comme lue
    if (!notif.isRead) {
      await DatabaseHelper.instance.markNotificationAsRead(notif.id);
      setState(() {
        notif.isRead = true; // Mettre à jour l'UI immédiatement
      });
    }

    // Naviguer vers l'objet lié (si applicable)
    if (notif.relatedObjectType == 'report' && notif.relatedObjectId != null && mounted) {
      final report = await DatabaseHelper.instance.getReportById(notif.relatedObjectId!);
      if (report != null) {
        if (!mounted) return;
        // Naviguer vers l'écran d'édition avec le rapport spécifique
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateReportScreen()),
        ).then((_) {
          if (mounted) _loadNotifications();
        });
      } else {
        if (!mounted) return;
        // Fallback : naviguer vers la liste générale si le rapport n'est pas trouvé
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MyReportsScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notifications'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<AppNotification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Vous n\'avez aucune notification.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(notif.createdAt);

              return ListTile(
                leading: Icon(
                  notif.isRead ? Icons.mark_email_read_outlined : Icons.mark_email_unread,
                  color: notif.isRead ? Colors.grey : Theme.of(context).primaryColor,
                ),
                title: Text(notif.title, style: TextStyle(fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold)),
                subtitle: Text('${notif.message}\n$formattedDate'),
                isThreeLine: true,
                onTap: () => _onNotificationTapped(notif),
              );
            },
          );
        },
      ),
    );
  }
}
