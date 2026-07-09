import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/attachment_repository.dart';
import '../services/mobile_attachment_repository.dart';
import '../services/web_attachment_repository.dart';
import '../domain/repositories/news_repository.dart';
import '../services/hive_news_repository.dart';
import '../domain/repositories/member_repository.dart';
import '../services/hive_member_repository.dart';
import '../domain/repositories/finance_repository.dart';
import '../services/hive_finance_repository.dart';
import '../domain/repositories/report_repository.dart';
import '../services/hive_report_repository.dart';
import '../domain/repositories/bible_repository.dart';
import '../services/hive_bible_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../services/hive_user_repository.dart';
import '../domain/repositories/governance_repository.dart';
import '../services/hive_governance_repository.dart';
import '../domain/repositories/sync_repository.dart';
import '../services/hive_sync_repository.dart';
import '../domain/repositories/inventory_repository.dart';
import '../services/hive_inventory_repository.dart';
import '../domain/repositories/social_repository.dart';
import '../services/hive_social_repository.dart';
import '../domain/repositories/construction_repository.dart';
import '../services/hive_construction_repository.dart';

/// Fournit l'implémentation appropriée du [AttachmentRepository] en fonction de la plateforme.
///
/// Sur mobile, il utilise [MobileAttachmentRepository] qui sauvegarde les fichiers sur le disque.
/// Sur le web, il utilise [WebAttachmentRepository] qui sauvegarde les données dans Hive/IndexedDB.
final attachmentRepositoryProvider = Provider<AttachmentRepository>((ref) {
  if (kIsWeb) {
    return WebAttachmentRepository();
  }
  return MobileAttachmentRepository();
});

/// Fournit l'implémentation de [NewsRepository].
/// Utilise HiveNewsRepository pour la persistance locale sur toutes les plateformes.
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return HiveNewsRepository();
});

/// Fournit l'implémentation de [MemberRepository].
final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return HiveMemberRepository();
});

/// Fournit l'implémentation de [FinanceRepository].
final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return HiveFinanceRepository();
});

/// Fournit l'implémentation de [ReportRepository].
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return HiveReportRepository();
});

/// Fournit l'implémentation de [BibleRepository].
final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  return HiveBibleRepository();
});

/// Fournit l'implémentation de [UserRepository].
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return HiveUserRepository();
});

/// Fournit l'implémentation de [GovernanceRepository].
final governanceRepositoryProvider = Provider<GovernanceRepository>((ref) {
  return HiveGovernanceRepository();
});

/// Fournit l'implémentation de [SyncRepository].
final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return HiveSyncRepository();
});

/// Fournit l'implémentation de [InventoryRepository].
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return HiveInventoryRepository();
});

/// Fournit l'implémentation de [SocialRepository].
final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return HiveSocialRepository();
});

/// Fournit l'implémentation de [ConstructionRepository].
final constructionRepositoryProvider = Provider<ConstructionRepository>((ref) {
  return HiveConstructionRepository();
});
