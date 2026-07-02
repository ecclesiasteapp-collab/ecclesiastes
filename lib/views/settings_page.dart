import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_settings.dart';
import '../providers/locale_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Paramètres & Sécurité'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<AppSettings>('settings_box').listenable(),
        builder: (context, Box<AppSettings> box, _) {
          final settings = box.get('current') ?? AppSettings();

          // Ajout du logo en haut de la page
          final logo = Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Image.asset('assets/logos/logo_ena.png', height: 60),
          );

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _buildSectionHeader('CONFIDENTIALITÉ (§3.20.6)'),
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
              
              _buildSectionHeader('SÉCURITÉ'),
              _buildSwitchTile(
                icon: Icons.fingerprint,
                color: Colors.blue,
                title: 'Verrouillage Biométrique',
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
              ),
              
              _buildSectionHeader('SYNCHRONISATION'),
              ListTile(
                leading: const Icon(Icons.sync, color: Colors.green),
                title: const Text('État de la base locale'),
                subtitle: Text(settings.lastSync != null 
                  ? 'Dernière synchro : ${settings.lastSync}' 
                  : 'Hors-ligne - Données stockées localement'),
                trailing: ElevatedButton(
                  onPressed: () {
                    settings.lastSync = DateTime.now();
                    settings.save();
                  },
                  child: const Text('SYNCHRO'),
                ),
              ),

              _buildSectionHeader('PRÉFÉRENCES'),
              _buildListTile(
                icon: Icons.language,
                title: 'Langue de l\'interface',
                subtitle: _languageLabel(settings.language),
                onTap: () => _showLanguagePicker(context, ref, box, settings),
              ),
              _buildSwitchTile(
                icon: Icons.dark_mode,
                color: Colors.grey,
                title: 'Mode Sombre',
                value: settings.isDarkMode,
                onChanged: (v) {
                  settings.isDarkMode = v;
                  settings.save();
                },
              ),
              
              logo, // Affichage du logo au milieu de la page
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Ecclésiaste v1.0.0+1 - 2026\nConforme aux Directives Ministres Nov 2023',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _languageLabel(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ln':
        return 'Lingala';
      case 'kg':
        return 'Kikongo';
      case 'sw':
        return 'Swahili';
      case 'lua':
        return 'Tshiluba';
      case 'fr':
      default:
        return 'Français';
    }
  }

  Future<void> _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    Box<AppSettings> box,
    AppSettings settings,
  ) async {
    const languages = <Map<String, String>>[
      {'code': 'fr', 'label': 'Français'},
      {'code': 'en', 'label': 'English'},
      {'code': 'ln', 'label': 'Lingala'},
      {'code': 'kg', 'label': 'Kikongo'},
      {'code': 'sw', 'label': 'Swahili'},
      {'code': 'lua', 'label': 'Tshiluba'},
    ];

    final selectedCode = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Choisir la langue',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...languages.map(
              (language) => ListTile(
                title: Text(language['label']!),
                trailing: settings.language == language['code']
                    ? const Icon(Icons.check, color: Color(0xFF003366))
                    : null,
                onTap: () => Navigator.of(context).pop(language['code']),
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedCode == null || selectedCode == settings.language) {
      return;
    }

    settings.language = selectedCode;
    await box.put('current', settings);
    await ref.read(localeProvider.notifier).setLocale(selectedCode);
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(title, style: const TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold, fontSize: 12)),
  );

  Widget _buildSwitchTile({required IconData icon, required Color color, required String title, String? subtitle, required bool value, required Function(bool) onChanged}) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withAlpha(25), shape: BoxShape.circle),
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
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}

