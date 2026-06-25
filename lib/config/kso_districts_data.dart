// lib/config/kso_districts_data.dart

class KsoDistrict {
  final int id;
  final String name;
  final int communitiesCount;
  final int membersCount;
  final List<String> responsables; 

  const KsoDistrict({
    required this.id,
    required this.name,
    required this.communitiesCount,
    required this.membersCount,
    this.responsables = const [],
  });
}

class KsoChampData {
  static const String apotreResponsable = 'Apôtre NGOLO Emmanuel';
  static const String dateSynoptique = '07 Avril 2025';
  
  static const int totalDistricts = 22;
  static const int totalCommunities = 180;
  static const int totalMembers = 16084;
  static const int totalMinisters = 566; 

  static const List<KsoDistrict> districts = [
    KsoDistrict(id: 1, name: 'Bileko', communitiesCount: 6, membersCount: 485, responsables: ['BANGAWE', 'MBONGO']),
    KsoDistrict(id: 2, name: 'Binza', communitiesCount: 11, membersCount: 520, responsables: ['KIBUTILA & BAYOKA', 'NSOBA & MATONDO']),
    KsoDistrict(id: 3, name: 'Djelo Binza', communitiesCount: 7, membersCount: 713, responsables: ['ZABUNGANA', 'MAYITUKA']),
    KsoDistrict(id: 4, name: 'Eben Ezer', communitiesCount: 10, membersCount: 670, responsables: ['NGOIE', 'NZAKIMUENA']),
    KsoDistrict(id: 5, name: 'Kanga Motema', communitiesCount: 8, membersCount: 697, responsables: ['KASONGO', 'NGWAMA']),
    KsoDistrict(id: 6, name: 'Kerith', communitiesCount: 5, membersCount: 353, responsables: ['IBANDA', 'NKUNI']),
    KsoDistrict(id: 7, name: 'Kimbwala', communitiesCount: 5, membersCount: 947, responsables: ['KIBAMBE', 'NGANA']),
    KsoDistrict(id: 8, name: 'Lutendele', communitiesCount: 8, membersCount: 951, responsables: ['MUMBAYA', 'MAKENGO']),
    KsoDistrict(id: 9, name: 'Malueka', communitiesCount: 10, membersCount: 1330, responsables: ['KASAMBI', 'MBENKIE']),
    KsoDistrict(id: 10, name: 'Manenga', communitiesCount: 7, membersCount: 550, responsables: ['LUKOMBO', 'MUBELA']),
    KsoDistrict(id: 11, name: 'Mbudi', communitiesCount: 9, membersCount: 901, responsables: ['KINAVUIDI', 'NDAMBELE']),
    KsoDistrict(id: 12, name: 'Météo', communitiesCount: 10, membersCount: 480, responsables: ['NSIMUNDELE', 'KABONGO']),
    KsoDistrict(id: 13, name: 'Mfinda', communitiesCount: 8, membersCount: 470, responsables: ['KWAPA', 'MULUMBA']),
    KsoDistrict(id: 14, name: 'Mobatisi', communitiesCount: 9, membersCount: 775, responsables: ['MUKENDI', 'MANYAYI']),
    KsoDistrict(id: 15, name: 'Munganga', communitiesCount: 9, membersCount: 516, responsables: ['MAMBOTE', 'KIANGALA']),
    KsoDistrict(id: 16, name: 'Ngomba Kinkusa', communitiesCount: 9, membersCount: 900, responsables: ['BUWEKA', 'KITOKO']),
    KsoDistrict(id: 17, name: 'Ngombi', communitiesCount: 6, membersCount: 371, responsables: ['ZIKU']),
    KsoDistrict(id: 18, name: 'Pompage', communitiesCount: 11, membersCount: 953, responsables: ['LUBANA', 'KABAMBA']),
    KsoDistrict(id: 19, name: 'Sanga Mamba', communitiesCount: 12, membersCount: 907, responsables: ['KATUNGA', 'NKISI']),
    KsoDistrict(id: 20, name: 'Sarepta', communitiesCount: 6, membersCount: 965, responsables: ['OBOMA', 'KABEMBA']),
    KsoDistrict(id: 21, name: 'Tshikapa', communitiesCount: 7, membersCount: 715, responsables: ['LANDU', 'POKI']),
    KsoDistrict(id: 22, name: 'U.P.N', communitiesCount: 7, membersCount: 915, responsables: ['GIMAVU', 'SINDANI']),
  ];
}
