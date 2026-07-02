import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../utils/profile_image_provider.dart';
import '../widgets/discrete_wrapper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  dynamic _profilePhoto;
  bool _isLoadingPhoto = false;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    final user = AuthService.currentUser;
    if (user != null) {
      final photo = await _profileService.getProfilePhoto(user.id);
      if (mounted) {
        setState(() {
          _profilePhoto = photo;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF003366)),
              title: const Text('Galerie'),
              onTap: () async {
                final img = await _profileService.pickImage(source: ImageSource.gallery);
                if (context.mounted) Navigator.pop(context, img);
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF003366)),
                title: const Text('Appareil photo'),
                onTap: () async {
                  final img = await _profileService.pickImage(source: ImageSource.camera);
                  if (context.mounted) Navigator.pop(context, img);
                },
              ),
          ],
        ),
      ),
    );

    if (!mounted) return;

    if (image != null) {
      setState(() => _isLoadingPhoto = true);
      try {
        await _profileService.saveProfilePhoto(image, user.id);
        
        if (!mounted) return;
        await _loadProfilePhoto();
        
        if (!mounted) return;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Photo mise à jour avec succès'),
              backgroundColor: Colors.green,
            )
          );
        }
      } catch (e) {
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Erreur: $e'), backgroundColor: Colors.red)
          );
        }
      } finally {
        if (mounted) setState(() => _isLoadingPhoto = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final userName = user?.fullName ?? 'Ministre';
    final role = user?.role.name ?? 'Responsable';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Mon Profil Ecclésial'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. CARTE MINISTÉRIELLE (QR Code)
            _buildMinisterCard(context, userName, role),
            const SizedBox(height: 30),
            
            // 2. IDENTITÉ ECCLÉSIALE (Badges)
            const Text('Statut Sacramentel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            _buildSacramentalSection(),
            const SizedBox(height: 30),

            // 3. STATISTIQUES PERSONNELLES
            const Text('Mes Statistiques du Mois', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            _buildStatsGrid(),
            
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share),
              label: const Text('PARTAGER MON PROFIL'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinisterCard(BuildContext context, String name, String role) {
    final imageProvider = buildProfileImageProvider(_profilePhoto);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003366), Color(0xFF0055AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: imageProvider,
                      child: (imageProvider == null && !_isLoadingPhoto)
                          ? const Icon(Icons.person, size: 45, color: Color(0xFF003366))
                          : null,
                    ),
                    if (_isLoadingPhoto)
                      const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      role,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: QrImageView(
              data: 'ID-MIN-${name.hashCode}',
              version: QrVersions.auto,
              size: 140,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'SCANNABLE POUR VÉRIFICATION DE MANDAT',
            style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildSacramentalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _badge(Icons.water_drop, 'Baptisé', Colors.blue),
        _badge(Icons.auto_awesome, 'Scellé', Colors.amber),
        _badge(Icons.church, 'Sainte-Cène', Colors.green),
      ],
    );
  }

  Widget _badge(IconData icon, String text, Color color) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 28),
      ),
      const SizedBox(height: 8),
      Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    ],
  );

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.6,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _statCard('Rapports Validés', '18', Icons.assignment_turned_in),
        _statCard('Membres Suivis', '452', Icons.people),
        _statCard('Heures Pastorales', '12h', Icons.access_time),
        _statCard('Événements', '4', Icons.event),
      ],
    );
  }

  Widget _statCard(String title, String val, IconData icon) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF003366), size: 22),
        const Spacer(),
        DiscreteWrapper(child: Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    ),
  );
}

