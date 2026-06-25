import 'package:hive/hive.dart';
import '../models/audit_log.dart';
import 'auth_service.dart';

class AuditLogService {
  static final AuditLogService _instance = AuditLogService._internal();
  factory AuditLogService() => _instance;
  AuditLogService._internal();

  final Box<AuditLog> _logBox = Hive.box<AuditLog>('audit_logs');

  /// Enregistre une action utilisateur
  Future<void> logAction({
    required String action,
    required String details,
    String? entityId,
    String? entityType,
  }) async {
    final user = AuthService.currentUser;
    final log = AuditLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      userId: user?.id ?? 'SYSTEM',
      userName: user?.fullName ?? 'Système',
      action: action,
      details: details,
      timestamp: DateTime.now(),
      entityId: entityId,
      entityType: entityType,
      userRole: user?.role.name ?? 'N/A',
    );
    await _logBox.add(log);
  }

  List<AuditLog> getRecentLogs({int limit = 50}) {
    final logs = _logBox.values.toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs.take(limit).toList();
  }
}
