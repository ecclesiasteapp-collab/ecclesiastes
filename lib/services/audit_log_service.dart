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
    required String actionType,
    required String targetType,
    required String targetId,
    required String changesJson,
  }) async {
    final user = AuthService.currentUser;
    final log = AuditLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      adminId: user?.id ?? 'SYSTEM',
      actionType: actionType,
      targetType: targetType,
      targetId: targetId,
      changesJson: changesJson,
      timestamp: DateTime.now(),
    );
    await _logBox.add(log);
  }

  List<AuditLog> getRecentLogs({int limit = 50}) {
    final logs = _logBox.values.toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs.take(limit).toList();
  }
}

