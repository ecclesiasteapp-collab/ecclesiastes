import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/auth_service.dart';

class MemberDashboard extends StatefulWidget {
  const MemberDashboard({super.key});

  @override
  State<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _profileImagePath = AuthService.currentUser?['photo_path'];
  }

  Future<void> _changePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
      // Ici vous pourriez sauvegarder le chemin dans votre base de données
      if (AuthService.currentUser != null) {
        AuthService.currentUser!['photo_path'] = pickedFile.path;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final name = user?['nom_complet'] ?? 'Membre';

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Profil avec Photo
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImagePath != null 
                        ? FileImage(File(_profileImagePath!)) 
                        : null,
                      child: _profileImagePath == null 
                        ? const Icon(Icons.person, size: 50, color: Color(0xFF003366)) 
                        : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changePhoto,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF003366),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(user?['role_label'] ?? 'Membre', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text("Bienvenue dans votre Communauté", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildInfoCard("Prochain Service Divin", "Dimanche 09:00", Icons.church),
          const SizedBox(height: 16),
          const Text("Dernières Annonces", style: TextStyle(fontWeight: FontWeight.bold)),
          const ListTile(leading: Icon(Icons.announcement, color: Colors.orange), title: Text("Collecte spéciale Econfi"), subtitle: Text("Dimanche 26 Avril")),
          const ListTile(leading: Icon(Icons.event), title: Text("Répétition Chorale"), subtitle: Text("Samedi 14h00")),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String val, IconData icon) => Card(
    color: const Color(0xFF003366),
    child: ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      subtitle: Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    ),
  );
}
