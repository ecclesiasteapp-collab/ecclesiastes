import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          final settings = box.get('current', defaultValue: AppSettings())!;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _buildSectionHeader("CONFIDENTIALITÉ (§3.20.6)"),
              _buildSwitchTile(
                icon: Icons.visibility_off,
                color: Colors.red,
                title: "Mode Discret (Floutage auto)",
                subtitle: "Masque les noms et chiffres en public",
                value: settings.isDiscreteMode,
                onChanged: (v) {
                  settings.isDiscreteMode = v;
                  settings.save();
                },
              ),
              
              _buildSectionHeader("SÉCURITÉ"),
              _buildSwitchTile(
                icon: Icons.fingerprint,
                color: Colors.blue,
                title: "Verrouillage Biométrique",
                subtitle: "Face ID / Empreinte digitale",
                value: settings.biometricsEnabled,
                onChanged: (v) {
                  settings.biometricsEnabled = v;
                  settings.save();
                },
              ),
              _buildListTile(
                icon: Icons.lock_outline,
                title: "Changer le mot de passe",
              ),
              
              _buildSectionHeader("SYNCHRONISATION"),
              ListTile(
                leading: const Icon(Icons.sync, color: Colors.green),
                title: const Text("État de la base locale"),
                subtitle: Text(settings.lastSync != null 
                  ? "Dernière synchro : ${settings.lastSync}" 
                  : "Hors-ligne - Données stockées localement"),
                trailing: ElevatedButton(
                  onPressed: () {
                    settings.lastSync = DateTime.now();
                    settings.save();
                  },
                  child: const Text("SYNCHRO"),
                ),
              ),

              _buildSectionHeader("PRÉFÉRENCES"),
              _buildListTile(
                icon: Icons.language,
                title: "Langue de l'interface",
                subtitle: settings.language == 'fr' ? 'Français' : 'Lingala / Swahili',
              ),
              _buildSwitchTile(
                icon: Icons.dark_mode,
                color: Colors.grey,
                title: "Mode Sombre",
                value: settings.isDarkMode,
                onChanged: (v) {
                  settings.isDarkMode = v;
                  settings.save();
                },
              ),
              
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Ecclésiastes v1.0.0+1 - 2026\nConforme aux Directives Ministres Nov 2023",
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

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(title, style: const TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold, fontSize: 12)),
  );

  Widget _buildSwitchTile({required IconData icon, required Color color, required String title, String? subtitle, required bool value, required Function(bool) onChanged}) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile({required IconData icon, required String title, String? subtitle}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.grey.shade700),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () {},
    );
  }
}
