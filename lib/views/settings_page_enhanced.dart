import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Les fichiers l10n générés sont référencés depuis `lib/l10n/`.
import 'package:ecclesiastes/l10n/app_localizations.dart';
import '../models/app_settings.dart';
import '../providers/locale_provider.dart';
import '../services/export_service.dart';

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
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey.withAlpha(25), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.grey.shade700),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer mon compte'),
        content: const Text('Cette action est irréversible. Toutes vos données seront supprimées.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

