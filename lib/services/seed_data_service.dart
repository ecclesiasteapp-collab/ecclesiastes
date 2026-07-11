import 'package:hive/hive.dart';
import '../config/kso_districts_config.dart';
import '../models/district_model.dart';
import '../models/hierarchy_models.dart';
import '../models/user.dart';
import '../models/news_model.dart';
import '../features/workflow/domain/models/workflow_models.dart';
import '../utils/password_utils.dart';

class SeedDataService {
  static Future<void> initialize() async {
    final userBox = Hive.box<User>('users');
    const adminId = 'admin_root_001';

    // 1. Super Admin Nestor Mbuyi
    if (userBox.get(adminId) == null) {
      final superAdmin = User(
        id: adminId,
        fullName: 'Nestor Mbuyi Kankolongo',
        email: 'superadmin@ecclesiastes.rdc',
        passwordHash: hashPassword('Admin@2026!RDC'),
        role: UserRole.superAdmin,
        entityLevel: EntityLevel.internationale,
        entityId: 'ROOT',
        isActive: true,
      );
      await userBox.put(superAdmin.id, superAdmin);
    }

    // 2. Districts Réels KSO
    final districtBox = Hive.box<DistrictModel>('districts');
    if (districtBox.isEmpty) {
      for (var d in KSODistrictsConfig.districts) {
        final district = DistrictModel(
          id: d['code'],
          name: d['name'],
          code: d['code'],
          communitiesCount: d['communautes'],
          membersCount: d['membres'],
          responsables: [],
          champId: 'kso',
          territorialId: 'rdc_ouest',
          siege: d['siege'],
        );
        await districtBox.put(district.id, district);
      }
    }

    // 3. News Initiales
    final newsBox = Hive.box<News>('news');
    if (newsBox.isEmpty) {
      await newsBox.add(News(
        id: 'news_01',
        title: 'Responsable du Champ KSO',
        content: 'L’Apôtre NGOLO Emmanuel supervise les 22 districts du champ Kinshasa Sud-Ouest.',
        date: DateTime.now(),
        imageUrl: 'assets/branding/logo_ena.png',
      ));
    }
  }
}

