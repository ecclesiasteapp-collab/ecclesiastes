import { EcclesiasticalEntity, MemberProfile, FinanceTransaction, MonthlyReport, CalendarEvent } from './types';

export const INITIAL_ENTITIES: EcclesiasticalEntity[] = [
  {
    id: "international_root",
    name: "Église Néo-Apostolique Internationale",
    code: "INTER",
    level: "INTERNATIONAL",
    responsible: "Apôtre-Patriarche Jean-Luc Schneider",
    members_count: 9000000,
    communities_count: 60000,
    siege: "Zurich, Suisse"
  },
  {
    id: "terr_rdc_ouest",
    name: "Église Territoriale RDC Ouest",
    code: "RDC-OUEST",
    level: "TERRITORIAL",
    parent_id: "international_root",
    responsible: "Apôtre de District Élie Tatien Mukinda",
    members_count: 2400000,
    communities_count: 12000,
    siege: "Kinshasa, Limete"
  },
  {
    id: "reg_ouest",
    name: "Région Apostolique Ouest",
    code: "REG-OUEST",
    level: "REGION",
    parent_id: "terr_rdc_ouest",
    responsible: "Apôtre de District Adjoint",
    members_count: 850000,
    communities_count: 4500,
    siege: "Kinshasa, Gombe"
  },
  {
    id: "champ_kso",
    name: "Champ Apostolique KSO",
    code: "KSO",
    level: "CHAMP",
    parent_id: "reg_ouest",
    responsible: "Apôtre Emmanuel Ngolo woto",
    members_count: 45000,
    communities_count: 150,
    siege: "Kinshasa, Lemba"
  },
  {
    id: "KSO_01",
    name: "District Lemba (KSO 01)",
    code: "KSO_01",
    level: "DISTRICT",
    parent_id: "champ_kso",
    responsible: "Ancien Théophile Buweka",
    members_count: 1200,
    communities_count: 5,
    siege: "Lemba"
  },
  {
    id: "KSO_02",
    name: "District Limete (KSO 02)",
    code: "KSO_02",
    level: "DISTRICT",
    parent_id: "champ_kso",
    responsible: "Prêtre Christian Kikaba",
    members_count: 1000,
    communities_count: 4,
    siege: "Limete"
  },
  {
    id: "KSO_03",
    name: "District Ngaba (KSO 03)",
    code: "KSO_03",
    level: "DISTRICT",
    parent_id: "champ_kso",
    responsible: "Ancien Responsable Ngaba",
    members_count: 1500,
    communities_count: 6,
    siege: "Ngaba"
  },
  // Communities under Lemba
  {
    id: "comm_lemba_centre",
    name: "Lemba Centre",
    code: "COMM-LEM-CTR",
    level: "COMMUNITY",
    parent_id: "KSO_01",
    responsible: "Berger Lemba Centre",
    members_count: 450,
    communities_count: 1,
    siege: "Lemba Sous-Région"
  },
  {
    id: "comm_lemba_est",
    name: "Lemba Est",
    code: "COMM-LEM-EST",
    level: "COMMUNITY",
    parent_id: "KSO_01",
    responsible: "Prêtre Lemba Est",
    members_count: 350,
    communities_count: 1,
    siege: "Lemba Echangeur"
  },
  {
    id: "comm_lemba_sud",
    name: "Lemba Sud",
    code: "COMM-LEM-SUD",
    level: "COMMUNITY",
    parent_id: "KSO_01",
    responsible: "Evangéliste Lemba Sud",
    members_count: 400,
    communities_count: 1,
    siege: "Lemba Righini"
  },
  // Communities under Limete
  {
    id: "comm_limete_central",
    name: "Limete Central",
    code: "COMM-LIM-CTR",
    level: "COMMUNITY",
    parent_id: "KSO_02",
    responsible: "Berger Limete Central",
    members_count: 600,
    communities_count: 1,
    siege: "Limete 7e Rue"
  },
  {
    id: "comm_limete_industriel",
    name: "Limete Industriel",
    code: "COMM-LIM-IND",
    level: "COMMUNITY",
    parent_id: "KSO_02",
    responsible: "Prêtre Limete Industriel",
    members_count: 400,
    communities_count: 1,
    siege: "Limete Industriel"
  }
];

export const INITIAL_MEMBERS: MemberProfile[] = [
  {
    id: "mem_01",
    firstName: "Emmanuel",
    lastName: "Ngolo woto",
    phone: "+243 812 345 678",
    gender: "M",
    rank: "Apôtre",
    isConfirmed: true,
    birthDate: "1968-04-12",
    entryDate: "1990-10-15",
    entityId: "champ_kso"
  },
  {
    id: "mem_02",
    firstName: "Théophile",
    lastName: "Buweka",
    phone: "+243 897 654 321",
    gender: "M",
    rank: "Ancien de District",
    isConfirmed: true,
    birthDate: "1972-08-24",
    entryDate: "1995-12-01",
    entityId: "KSO_01"
  },
  {
    id: "mem_03",
    firstName: "Christian",
    lastName: "Kikaba",
    phone: "+243 824 567 890",
    gender: "M",
    rank: "Prêtre",
    isConfirmed: true,
    birthDate: "1980-11-05",
    entryDate: "2005-06-18",
    entityId: "KSO_02"
  },
  {
    id: "mem_04",
    firstName: "Jean-Luc",
    lastName: "Mbuyi",
    phone: "+243 815 111 222",
    gender: "M",
    rank: "Berger",
    isConfirmed: true,
    birthDate: "1975-02-14",
    entryDate: "1998-09-20",
    entityId: "comm_lemba_centre"
  },
  {
    id: "mem_05",
    firstName: "Marie",
    lastName: "Kabasele",
    phone: "+243 891 223 344",
    gender: "F",
    rank: "Membre",
    isConfirmed: true,
    birthDate: "1988-06-30",
    entryDate: "2010-04-05",
    entityId: "comm_lemba_centre"
  },
  {
    id: "mem_06",
    firstName: "Simon",
    lastName: "Kimbangu",
    phone: "+243 813 334 455",
    gender: "M",
    rank: "Diacre",
    isConfirmed: true,
    birthDate: "1992-01-15",
    entryDate: "2015-05-10",
    entityId: "comm_lemba_est"
  }
];

export const INITIAL_TRANSACTIONS: FinanceTransaction[] = [
  // Community Lemba Centre
  {
    id: "tx_01",
    type: "OFFERING",
    amount: 1500,
    date: "2026-06-05",
    description: "Offrandes du service divin de Pentecôte",
    entityId: "comm_lemba_centre"
  },
  {
    id: "tx_02",
    type: "DONATION",
    amount: 500,
    date: "2026-06-12",
    description: "Don spécial pour travaux de toiture",
    entityId: "comm_lemba_centre"
  },
  {
    id: "tx_03",
    type: "EXPENSE",
    amount: 300,
    date: "2026-06-18",
    description: "Achat carburant pour le générateur de Lemba Centre",
    entityId: "comm_lemba_centre"
  },
  // Community Lemba Est
  {
    id: "tx_04",
    type: "OFFERING",
    amount: 1200,
    date: "2026-06-05",
    description: "Offrandes hebdomadaires Lemba Est",
    entityId: "comm_lemba_est"
  },
  {
    id: "tx_05",
    type: "EXPENSE",
    amount: 250,
    date: "2026-06-14",
    description: "Réparation sonos et micros",
    entityId: "comm_lemba_est"
  },
  // Community Limete Central
  {
    id: "tx_06",
    type: "OFFERING",
    amount: 2800,
    date: "2026-06-05",
    description: "Offrande d'action de grâces Limete Central",
    entityId: "comm_limete_central"
  },
  {
    id: "tx_07",
    type: "EXPENSE",
    amount: 450,
    date: "2026-06-20",
    description: "Entretien climatisation du bureau pastoral",
    entityId: "comm_limete_central"
  }
];

export const INITIAL_REPORTS: MonthlyReport[] = [
  {
    id: "rep_01",
    entityId: "comm_lemba_centre",
    month: "2026-05",
    status: "VALIDATED",
    kpis: {
      attendance: 420,
      activeMembers: 450,
      servicesCount: 8,
      offeringsAmount: 4800
    },
    remarks: "Excellent mois. Forte présence des enfants d'Ecodim à la fête de l'Ascension.",
    signedBy: "Jean-Luc Mbuyi (Berger)",
    dateSigned: "2026-05-31"
  },
  {
    id: "rep_02",
    entityId: "comm_lemba_est",
    month: "2026-05",
    status: "SUBMITTED",
    kpis: {
      attendance: 310,
      activeMembers: 350,
      servicesCount: 8,
      offeringsAmount: 3900
    },
    remarks: "Rapport soumis à l'Ancien de District pour validation. Climatisation réparée.",
    signedBy: "Prêtre Lemba Est"
  },
  {
    id: "rep_03",
    entityId: "comm_lemba_centre",
    month: "2026-06",
    status: "DRAFT",
    kpis: {
      attendance: 435,
      activeMembers: 450,
      servicesCount: 9,
      offeringsAmount: 5200
    },
    remarks: "En attente des signatures de la commission Jeunesse."
  }
];

export const INITIAL_NEWS = [
  {
    id: "news_1",
    title: "Visite de l'Apôtre de District Élie Tatien Mukinda à Lemba",
    date: "2026-07-01",
    summary: "Un grand service divin solennel sera célébré par l'Apôtre de District le dimanche 12 juillet à la communauté de Lemba Centre. Tous les fidèles du district sont chaleureusement invités.",
    image: "/assets/images/annonces/Epiclèse.jpg",
    category: "Visite Pastorale"
  },
  {
    id: "news_2",
    title: "Séminaire de Formation Ecodim - Lemba (KSO 01)",
    date: "2026-06-28",
    summary: "La commission pédagogique organise une session d'harmonisation et de formation continue pour tous les moniteurs et monitrices d'Ecodim. Lieu : Lemba Centre.",
    image: "/assets/images/annonces/IMG-20260103-WA0006.jpg",
    category: "Pédagogie"
  },
  {
    id: "news_3",
    title: "Lancement des travaux d'extension de Limete Central",
    date: "2026-06-20",
    summary: "Grâce à vos offrandes de construction spéciales, les travaux de pose de la nouvelle toiture débuteront le lundi 6 juillet. Suivez l'avancement en temps réel sur le Hub ERP.",
    image: "/assets/images/annonces/IMG-20260119-WA0014.jpg",
    category: "Infrastructures"
  }
];

export const BIBLE_BOOKS_MOCK = [
  { book: "Genèse", chapter: 1, verse: 1, text: "Au commencement, Dieu créa les cieux et la terre." },
  { book: "Psaumes", chapter: 23, verse: 1, text: "L'Éternel est mon berger: je ne manquerai de rien." },
  { book: "Psaumes", chapter: 23, verse: 2, text: "Il me fait reposer dans de verts pâturages, Il me dirige près des eaux paisibles." },
  { book: "Psaumes", chapter: 23, verse: 3, text: "Il restaure mon âme, Il me conduit dans les sentiers de la justice, À cause de son nom." },
  { book: "Psaumes", chapter: 23, verse: 4, text: "Quand je marche dans la vallée de l'ombre de la mort, Je ne crains aucun mal, car tu es avec moi: Ta houlette et ton bâton me rassurent." },
  { book: "Jean", chapter: 3, verse: 16, text: "Car Dieu a tant aimé le monde qu'il a donné son Fils unique, afin que quiconque croit en lui ne périsse point, mais qu'il ait la vie éternelle." },
  { book: "Matthieu", chapter: 5, verse: 3, text: "Heureux les pauvres en esprit, car le royaume des cieux est à eux!" },
  { book: "Matthieu", chapter: 5, verse: 4, text: "Heureux les affligés, car ils seront consolés!" },
  { book: "Romains", chapter: 8, verse: 28, text: "Nous savons, du reste, que toutes choses concourent au bien de ceux qui aiment Dieu, de ceux qui sont appelés selon son dessein." }
];

export const INITIAL_EVENTS: CalendarEvent[] = [
  {
    id: "evt_1",
    title: "Culte solennel d'action de grâces",
    type: "WORSHIP",
    date: "2026-07-12",
    time: "10:00",
    location: "Lemba Centre - Sanctuaire principal",
    description: "Culte divin avec célébration de la Sainte-Cène présidé par l'Apôtre Emmanuel Ngolo. Prestation spéciale du grand chœur de district.",
    entityId: "comm_lemba_centre",
    officiant: "Apôtre Emmanuel Ngolo",
    availabilities: {
      "mem_1": "AVAILABLE",
      "mem_2": "AVAILABLE",
      "mem_3": "TENTATIVE"
    }
  },
  {
    id: "evt_2",
    title: "Conseil des Ministres du District KSO 01",
    type: "MEETING",
    date: "2026-07-15",
    time: "18:00",
    location: "Lemba Centre - Salle de conférence",
    description: "Réunion mensuelle de concertation, d'alignement pastoral et de planification liturgique pour tous les ministres ordonnés du district.",
    entityId: "KSO_01",
    officiant: "Ancien Théophile Buweka",
    availabilities: {
      "mem_4": "AVAILABLE",
      "mem_5": "UNAVAILABLE"
    }
  },
  {
    id: "evt_3",
    title: "Répétition Générale de la Chorale",
    type: "CHOIR",
    date: "2026-07-17",
    time: "17:30",
    location: "Lemba Centre - Nef",
    description: "Répétition intensive pour la préparation du répertoire de chants de la visite pastorale. Présence requise de tous les choristes du district.",
    entityId: "comm_lemba_centre",
    officiant: "Berger Lemba Centre",
    availabilities: {
      "mem_1": "AVAILABLE",
      "mem_3": "AVAILABLE"
    }
  },
  {
    id: "evt_4",
    title: "Journée de Fraternité et de Partage des Jeunes",
    type: "YOUTH",
    date: "2026-07-18",
    time: "14:00",
    location: "Limete Central - Grand Hall",
    description: "Échange interactif autour de la foi active, suivi d'activités récréatives et de chants. Goûter fraternel offert.",
    entityId: "comm_limete_central",
    officiant: "Prêtre Christian Kikaba",
    availabilities: {
      "mem_2": "AVAILABLE",
      "mem_4": "TENTATIVE"
    }
  },
  {
    id: "evt_5",
    title: "Atelier pédagogique pour les Moniteurs Ecodim",
    type: "SEMINAR",
    date: "2026-07-16",
    time: "15:00",
    location: "Lemba Est - Salle Ecodim",
    description: "Mise à niveau des méthodes d'enseignement pour l'école du dimanche et harmonisation des supports didactiques pour l'année 2026.",
    entityId: "comm_lemba_est",
    officiant: "Prêtre Lemba Est",
    availabilities: {
      "mem_5": "AVAILABLE"
    }
  }
];

