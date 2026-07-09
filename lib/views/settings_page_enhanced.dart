import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Les fichiers l10n générés sont référencés depuis `lib/l10n/`.
import 'package:ecclesiaste/l10n/app_localizations.dart';
import 'package:ecclesiaste/providers/theme_provider.dart';
import '../models/app_settings.dart';
import '../providers/locale_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../services/export_service.dart';
import '../services/cloud_sync_service.dart';
import '../domain/repositories/sync_repository.dart';
import '../services/repository_providers.dart';
import '../models/sync_queue_model.dart';
import '../services/migration/legacy_to_erp_migration_service.dart';
import '../data/repositories/hive_organization_repository.dart';

/// Page de paramètres améliorée avec toutes les fonctionnalités modernes
class SettingsPageEnhanced extends ConsumerWidget {
  const SettingsPageEnhanced({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<AppSettings>('settings_box').listenable(),
        builder: (context, Box<AppSettings> box, _) {
          final settings = box.get('current') ?? AppSettings();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // ========== SÉCURITÉ ==========
              _buildSectionHeader(l10n.security, Icons.security),
              _buildSwitchTile(
                icon: Icons.fingerprint,
                color: Colors.blue,
                title: l10n.biometrics,
                subtitle: 'Face ID / Empreinte digitale',
                value: settings.biometricsEnabled,
                onChanged: (v) {
                  settings.biometricsEnabled = v;
                  settings.save();
                },
              ),
              _buildListTile(
                icon: Icons.lock_outline,
                title: 'Changer le mot de passe',
                subtitle: 'Dernière modification : ${settings.lastPasswordChange?.toString().split('.')[0] ?? "Jamais"}',
                onTap: () => _showPasswordChangeDialog(context),
              ),

              // ========== NOTIFICATIONS ==========
              _buildSectionHeader(l10n.notifications, Icons.notifications),
              _buildSwitchTile(
                icon: Icons.notifications_active,
                color: Colors.orange,
                title: 'Notifications activées',
                subtitle: 'Recevoir des notifications de l\'application',
                value: settings.notificationsEnabled,
                onChanged: (v) {
                  settings.notificationsEnabled = v;
                  settings.save();
                },
              ),

              // ========== ACCESSIBILITÉ ==========
              _buildSectionHeader(l10n.accessibility, Icons.accessibility),
              _buildListTile(
                icon: Icons.text_fields,
                title: l10n.fontSize,
                subtitle: 'Actuel : ${_fontSizeLabel(settings.fontSizeLevel)}',
                onTap: () => _showFontSizePicker(context, settings, box),
              ),
              _buildSwitchTile(
                icon: Icons.contrast,
                color: Colors.purple,
                title: 'Mode Contraste Élevé',
                subtitle: 'Améliore la lisibilité pour les malvoyants',
                value: settings.highContrast,
                onChanged: (v) {
                  settings.highContrast = v;
                  settings.save();
                },
              ),

              // ========== APPARENCE ==========
              _buildSectionHeader(l10n.appearance, Icons.palette),
              _buildListTile(
                icon: Icons.language,
                title: l10n.language,
                subtitle: _languageLabel(settings.language),
                onTap: () => _showLanguagePicker(context, ref, box, settings),
              ),
              _buildSwitchTile(
                icon: Icons.dark_mode,
                color: Colors.grey,
                title: l10n.darkMode,
                value: settings.isDarkMode,
                onChanged: (v) {
                  settings.isDarkMode = v;
                  settings.save();
                  ref.read(themeProvider.notifier).toggleTheme(v);
                },
              ),

              // ========== CONFIDENTIALITÉ ==========
              _buildSectionHeader(l10n.privacy, Icons.privacy_tip),
              _buildSwitchTile(
                icon: Icons.visibility_off,
                color: Colors.red,
                title: 'Mode Discret (Floutage auto)',
                subtitle: 'Masque les noms et chiffres en public',
                value: settings.isDiscreteMode,
                onChanged: (v) {
                  settings.isDiscreteMode = v;
                  settings.save();
                },
              ),
              _buildListTile(
                icon: Icons.download,
                title: l10n.exportData,
                subtitle: 'Télécharger une copie de vos données personnelles',
                onTap: () => _showExportData(context),
              ),
              _buildListTile(
                icon: Icons.delete_forever,
                title: l10n.deleteAccount,
                subtitle: 'Suppression permanente et irréversible',
                onTap: () => _showDeleteAccount(context),
              ),

              // ========== SYNCHRONISATION & SAUVEGARDE ==========
              _buildSectionHeader(l10n.syncAndBackup, Icons.cloud_sync),
              _buildSyncTile(context, ref),
              _buildSwitchTile(
                icon: Icons.backup,
                color: Colors.teal,
                title: l10n.autoBackup,
                subtitle: 'Sauvegarder automatiquement vos données',
                value: settings.autoBackup,
                onChanged: (v) {
                  settings.autoBackup = v;
                  settings.save();
                },
              ),
              _buildListTile(
                icon: Icons.upload_file,
                title: 'Sauvegarder maintenant (Backup)',
                subtitle: 'Créer un point de restauration complet',
                onTap: () => _performBackup(context),
              ),
              _buildListTile(
                icon: Icons.restore,
                title: 'Restaurer les données',
                subtitle: 'Restaurer à partir d\'un fichier .bak',
                onTap: () => _showRestoreDialog(context),
              ),

              // ========== TRANSITION ERP (PHASE 1-3) ==========
              _buildSectionHeader('ARCHITECTURE ERP', Icons.upgrade),
              _buildListTile(
                icon: Icons.data_thresholding,
                title: 'Migrer vers le moteur ERP',
                subtitle: 'Convertir les membres et entités vers le nouveau système de Mandats.',
                onTap: () => _showMigrationDialog(context),
              ),

              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Ecclésiaste v1.0.0+1 - 2026\nConforme RGPD & WCAG 2.1',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  String _languageLabel(String languageCode) {
    switch (languageCode) {
      case 'en': return 'English';
      case 'ln': return 'Lingala';
      case 'ko': return 'Kikongo';
      case 'sw': return 'Swahili';
      case 'tl': return 'Tshiluba';
      case 'fr': default: return 'Français';
    }
  }

  String _fontSizeLabel(String size) {
    switch (size) {
      case 'small': return 'Petite';
      case 'large': return 'Grande';
      case 'xlarge': return 'Très grande';
      case 'normal': default: return 'Normal';
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF003366), size: 18),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    ),
  );

  Widget _buildSwitchTile({
    required IconData icon,
    required Color color,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withAlpha(25), shape: BoxShape.circle),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    // ... existant
  }

  Widget _buildSyncTile(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<SyncQueueItem>>(
      future: ref.read(syncRepositoryProvider).getPendingItems(),
      builder: (context, snapshot) {
        final pendingCount = snapshot.data?.length ?? 0;
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue.withAlpha(25), shape: BoxShape.circle),
            child: Icon(Icons.sync, color: pendingCount > 0 ? Colors.orange : Colors.blue),
          ),
          title: const Text('Synchronisation Cloud', style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(pendingCount > 0 
            ? '$pendingCount éléments en attente' 
            : 'Toutes les données sont synchronisées'),
          trailing: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _runSync(context, ref),
          ),
          onTap: () => _runSync(context, ref),
        );
      },
    );
  }

  Future<void> _runSync(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final syncService = ref.read(cloudSyncServiceProvider);
    
    messenger.showSnackBar(const SnackBar(content: Text('Début de la synchronisation...')));
    final result = await syncService.synchronize();
    
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(result.success ? 'Succès' : 'Info Sync'),
          content: Text(result.message),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
    }
  }

  void _showExportData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exporter mes données'),
        content: const Text('Voulez-vous générer un fichier JSON contenant toutes vos données personnelles (conforme RGPD) ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              try {
                await ExportService.exportUserData();
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Erreur lors de l\'exportation : $e')),
                );
              }
            },
            child: const Text('EXPORTER'),
          ),
        ],
      ),
    );
  }

  void _showMigrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Migration vers ERP'),
        content: const Text('Cette action va transformer vos membres actuels en "Personnes" avec des "Mandats". Cela est nécessaire pour activer le nouveau Hub dynamique.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              try {
                final migrationService = LegacyToErpMigrationService(HiveOrganizationRepository());
                await migrationService.runMigration();
                messenger.showSnackBar(
                  const SnackBar(content: Text('✅ Migration réussie ! Redémarrez pour voir les changements.')),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('❌ Erreur : $e')),
                );
              }
            },
            child: const Text('LANCER LA MIGRATION'),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, Box<AppSettings> box, AppSettings settings) {
    const languages = <Map<String, String>>[
      {'code': 'fr', 'label': 'Français'},
      {'code': 'en', 'label': 'English'},
      {'code': 'ln', 'label': 'Lingala'},
      {'code': 'ko', 'label': 'Kikongo'},
      {'code': 'sw', 'label': 'Swahili'},
      {'code': 'tl', 'label': 'Tshiluba'},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Choisir la langue', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...languages.map(
              (language) => ListTile(
                title: Text(language['label']!),
                trailing: settings.language == language['code']
                    ? const Icon(Icons.check, color: Color(0xFF003366))
                    : null,
                onTap: () {
                  // 1. Persistance dans Hive pour le prochain redémarrage
                  settings.language = language['code']!;
                  settings.save(); // ou box.put('current', settings);
                  
                  // 2. Mise à jour immédiate de l'UI via Riverpod
                  ref.read(localeProvider.notifier).setLocale(language['code']!);
                  
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizePicker(BuildContext context, AppSettings settings, Box<AppSettings> box) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Taille de police'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Petite', style: TextStyle(fontSize: 12)),
              onTap: () {
                settings.fontSizeLevel = 'small';
                settings.save();
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Normal', style: TextStyle(fontSize: 14)),
              onTap: () {
                settings.fontSizeLevel = 'normal';
                settings.save();
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Grande', style: TextStyle(fontSize: 16)),
              onTap: () {
                settings.fontSizeLevel = 'large';
                settings.save();
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPasswordChangeDialog(BuildContext context) {
    // Implémentation simplifiée pour le nettoyage
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: const Text('Fonctionnalité de sécurité en cours de déploiement.'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  void _showDeleteAccount(BuildContext context) {
    // ... existant
  }

  Future<void> _performBackup(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ExportService.performFullBackup();
      messenger.showSnackBar(const SnackBar(content: Text('✅ Sauvegarde réussie !')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('❌ Erreur de sauvegarde : $e')));
    }
  }

  Future<void> _showRestoreDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restaurer les données'),
        content: const Text('Attention : cette action va écraser TOUTES vos données locales par celles du fichier de sauvegarde. Voulez-vous continuer ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('RESTAURER'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.any,
        );

        if (result != null && result.files.single.path != null) {
          await ExportService.restoreFromBackup(File(result.files.single.path!));
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                title: const Text('Restauration terminée'),
                content: const Text('Les données ont été restaurées avec succès. L\'application va redémarrer pour appliquer les changements.'),
                actions: [
                  ElevatedButton(
                    onPressed: () => exit(0),
                    child: const Text('Quitter l\'application'),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erreur de restauration : $e')));
        }
      }
    }
  }
}

