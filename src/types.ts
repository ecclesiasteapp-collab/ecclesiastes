export type EntityLevel = 'INTERNATIONAL' | 'TERRITORIAL' | 'REGION' | 'CHAMP' | 'DISTRICT' | 'COMMUNITY';

export interface EcclesiasticalEntity {
  id: string;
  name: string;
  code: string;
  level: EntityLevel;
  parent_id?: string;
  responsible?: string;
  communities_count?: number;
  members_count?: number;
  siege?: string;
}

export interface MemberProfile {
  id: string;
  firstName: string;
  lastName: string;
  phone: string;
  gender: 'M' | 'F';
  rank: string; // e.g. Ancien, Diacre, Prêtre, Berger, Evangéliste, Apôtre
  isConfirmed: boolean;
  birthDate: string;
  entryDate: string;
  entityId: string; // Active community or district
}

export type TransactionType = 'OFFERING' | 'DONATION' | 'EXPENSE';

export interface FinanceTransaction {
  id: string;
  type: TransactionType;
  amount: number;
  date: string;
  description: string;
  entityId: string; // The entity that registered it
  isConsolidated?: boolean;
}

export type ReportStatus = 'DRAFT' | 'SUBMITTED' | 'VALIDATED';

export interface MonthlyReport {
  id: string;
  entityId: string;
  month: string; // e.g. "2026-06"
  status: ReportStatus;
  kpis: {
    attendance: number;
    activeMembers: number;
    servicesCount: number;
    offeringsAmount: number;
  };
  remarks: string;
  signedBy?: string;
  dateSigned?: string;
}

export interface BibleVerse {
  book: string;
  chapter: number;
  verse: number;
  text: string;
  note?: string;
}

export type EventType = 'WORSHIP' | 'MEETING' | 'YOUTH' | 'CHOIR' | 'SEMINAR';

export type AvailabilityStatus = 'AVAILABLE' | 'UNAVAILABLE' | 'TENTATIVE';

export interface CalendarEvent {
  id: string;
  title: string;
  type: EventType;
  date: string; // YYYY-MM-DD
  time: string; // HH:MM
  location: string;
  description: string;
  entityId: string; // Hosting entity
  officiant: string; // Celebrant / Officiant
  availabilities?: Record<string, AvailabilityStatus>; // memberId -> Availability
}

export interface AppSettings {
  language: 'fr' | 'ln';
  theme: 'light' | 'dark' | 'system';
  accessibilityScale: 'small' | 'medium' | 'large' | 'xlarge';
  contrastHigh: boolean;
  notificationsPush: boolean;
  notificationsEmail: boolean;
  backupAuto: boolean;
  securityBiometrics: boolean;
}
