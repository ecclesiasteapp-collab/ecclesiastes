import 'package:ecclesiastes/services/logging_service.dart';
import 'package:hive/hive.dart';
import '../models/attachment_model.dart';
import '../models/news_model.dart';
import '../models/event.dart';

/// Initialise tous les adaptateurs Hive pour le système d'attachments
Future<void> initializeAttachmentAdapters() async {
  // Enregistre l'adaptateur pour Attachment
  if (!Hive.isAdapterRegistered(103)) {
    Hive.registerAdapter(AttachmentAdapter());
  }

  // Enregistre les adaptateurs pour News (si nécessaire)
  if (!Hive.isAdapterRegistered(40)) {
    Hive.registerAdapter(NewsAdapter());
  }

  // Enregistre les adaptateurs pour ChurchEvent
  if (!Hive.isAdapterRegistered(110)) {
    Hive.registerAdapter(ChurchEventAdapter());
  }

  // Ouvre les boîtes d'attachments
  try {
    await Hive.openBox<Attachment>('attachments_box');
    LoggingService.info('✅ AttachmentBox initialisée');
  } catch (e) {
    LoggingService.warning('⚠️ AttachmentBox déjà ouverte ou erreur: $e');
  }

  try {
    await Hive.openBox<News>('news');
    LoggingService.info('✅ NewsBox initialisée');
  } catch (e) {
    LoggingService.warning('⚠️ NewsBox déjà ouverte ou erreur: $e');
  }

  try {
    await Hive.openBox<ChurchEvent>('church_events_box');
    LoggingService.info('✅ ChurchEventsBox initialisée');
  } catch (e) {
    LoggingService.warning('⚠️ ChurchEventsBox déjà ouverte ou erreur: $e');
  }
}

/// À appeler dans main() avant runApp()
void setupAttachmentStorage() async {
  await initializeAttachmentAdapters();
  LoggingService.info('🎯 Système d\'attachments initialisé');
}

