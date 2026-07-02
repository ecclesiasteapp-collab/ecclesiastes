import 'package:hive/hive.dart';

part 'territory_config.g.dart';

@HiveType(typeId: 61)
class TerritoryConfig extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String officialName;
  @HiveField(2) String shortName;
  @HiveField(3) String logoAssetPath;
  @HiveField(4) String defaultCurrency;
  @HiveField(5) String primaryLanguage;
  
  @HiveField(6) String labelLevel5; // ex: Internationale
  @HiveField(7) String labelLevel4; // ex: Territoriale
  @HiveField(8) String labelLevel3; // ex: Champ
  @HiveField(9) String labelLevel2; // ex: District
  @HiveField(10) String labelLevel1; // ex: Communauté

  TerritoryConfig({
    required this.id,
    required this.officialName,
    required this.shortName,
    required this.logoAssetPath,
    required this.defaultCurrency,
    required this.primaryLanguage,
    this.labelLevel5 = 'Église Internationale',
    this.labelLevel4 = 'Église Territoriale',
    this.labelLevel3 = 'Champ d\'Apôtre',
    this.labelLevel2 = 'District',
    this.labelLevel1 = 'Communauté',
  });
}

