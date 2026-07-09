import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pastoral_analytics_service.dart';
import '../services/repository_providers.dart';

/// Fournit l'instance de [PastoralAnalyticsService] injectée avec les repositories nécessaires.
final pastoralAnalyticsProvider = Provider<PastoralAnalyticsService>((ref) {
  final reportRepo = ref.watch(reportRepositoryProvider);
  final memberRepo = ref.watch(memberRepositoryProvider);
  
  return PastoralAnalyticsService(
    reportRepository: reportRepo,
    memberRepository: memberRepo,
  );
});
