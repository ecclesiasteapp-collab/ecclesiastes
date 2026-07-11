import { useState, useEffect, useMemo } from 'react';
import { 
  INITIAL_ENTITIES, 
  INITIAL_MEMBERS, 
  INITIAL_TRANSACTIONS, 
  INITIAL_REPORTS,
  INITIAL_EVENTS
} from './data';
import { 
  EcclesiasticalEntity, 
  MemberProfile, 
  FinanceTransaction, 
  MonthlyReport, 
  AppSettings,
  ReportStatus,
  CalendarEvent
} from './types';

// Import our components
import { CompassBreadcrumb } from './components/CompassBreadcrumb';
import { DashboardOverview } from './components/DashboardOverview';
import { FinanceConsolidationHub } from './components/FinanceConsolidationHub';
import { ReportsEngine } from './components/ReportsEngine';
import { MemberManagement } from './components/MemberManagement';
import { BibleLibrary } from './components/BibleLibrary';
import { CalendarModule } from './components/CalendarModule';
import { SettingsPage } from './components/SettingsPage';
import { GithubLogin } from './components/GithubLogin';
import { useToast } from './components/Toast';

// Import Icons
import { 
  LayoutDashboard, 
  Wallet, 
  ScrollText, 
  Users, 
  BookOpen, 
  Settings as SettingsIcon,
  Landmark,
  User,
  ArrowUpRight,
  Wifi,
  WifiOff,
  CalendarDays
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

// Tiny translation dictionary for high-fidelity Lingala (l10n) representation
const TRANSLATIONS = {
  fr: {
    dashboard: "Tableau de Bord",
    finance: "Finances & ERP",
    reports: "Rapports Mensuels",
    members: "Fichier des Membres",
    calendar: "Calendrier & Cultes",
    bible: "Bibliothèque TOB",
    settings: "Paramètres",
    logoSubtitle: "Administration Écclésiastique",
    activeScope: "Périmètre Actif",
    help: "Support & Guide",
    loggedAs: "Rôle : Clergé connecté",
    credits: "Développé pour l'Église Néo-Apostolique"
  },
  ln: {
    dashboard: "Mesa ya Mosala",
    finance: "Mbongo & ERP",
    reports: "Lapolo ya Sanza",
    members: "Kaye ya Bandimi",
    calendar: "Manaka ya Mayangani",
    bible: "Biblia TOB",
    settings: "Bongisi",
    logoSubtitle: "Boyangeli ya Ndako-Nzambe",
    activeScope: "Etando ya Mosala",
    help: "Lisalisi & Litambwisi",
    loggedAs: "Mosala : Molobeli ya Nzambe",
    credits: "Esalemi mpona Ndako-Nzambe Néo-Apostolique"
  }
};

export default function App() {
  const { showToast } = useToast();
  
  // Track offline status for local caching strategy indicator
  const [isOnline, setIsOnline] = useState<boolean>(navigator.onLine);

  useEffect(() => {
    const handleOnline = () => {
      setIsOnline(true);
      showToast("Connexion internet rétablie. Mode en ligne actif.", "success");
    };
    const handleOffline = () => {
      setIsOnline(false);
      showToast("Connexion internet perdue. Mode hors ligne actif (données membres et rapports disponibles localement).", "info");
    };

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, [showToast]);

  // --- STATE PERSISTENCE IN LOCAL STORAGE ---
  const [entities, setEntities] = useState<EcclesiasticalEntity[]>(() => {
    const saved = localStorage.getItem('ecclesiaste_entities');
    return saved ? JSON.parse(saved) : INITIAL_ENTITIES;
  });

  const [activeEntityId, setActiveEntityId] = useState<string>(() => {
    const saved = localStorage.getItem('ecclesiaste_active_entity_id');
    return saved ? saved : 'champ_kso'; // Default scope is Champ KSO (Emmanuel Ngolo)
  });

  const [members, setMembers] = useState<MemberProfile[]>(() => {
    const saved = localStorage.getItem('ecclesiaste_members');
    return saved ? JSON.parse(saved) : INITIAL_MEMBERS;
  });

  const [transactions, setTransactions] = useState<FinanceTransaction[]>(() => {
    const saved = localStorage.getItem('ecclesiaste_transactions');
    return saved ? JSON.parse(saved) : INITIAL_TRANSACTIONS;
  });

  const [reports, setReports] = useState<MonthlyReport[]>(() => {
    const saved = localStorage.getItem('ecclesiaste_reports');
    return saved ? JSON.parse(saved) : INITIAL_REPORTS;
  });

  const [events, setEvents] = useState<CalendarEvent[]>(() => {
    const saved = localStorage.getItem('ecclesiaste_events');
    return saved ? JSON.parse(saved) : INITIAL_EVENTS;
  });

  const [settings, setSettings] = useState<AppSettings>(() => {
    const saved = localStorage.getItem('ecclesiaste_settings');
    if (saved) return JSON.parse(saved);
    return {
      language: 'fr',
      theme: 'light',
      accessibilityScale: 'medium',
      contrastHigh: false,
      notificationsPush: true,
      notificationsEmail: true,
      backupAuto: true,
      securityBiometrics: false
    };
  });

  const [systemPrefersDark, setSystemPrefersDark] = useState(() => {
    if (typeof window !== 'undefined' && window.matchMedia) {
      return window.matchMedia('(prefers-color-scheme: dark)').matches;
    }
    return false;
  });

  useEffect(() => {
    if (typeof window === 'undefined' || !window.matchMedia) return;
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    const listener = (e: MediaQueryListEvent) => {
      setSystemPrefersDark(e.matches);
    };
    if (mediaQuery.addEventListener) {
      mediaQuery.addEventListener('change', listener);
      return () => mediaQuery.removeEventListener('change', listener);
    } else if (mediaQuery.addListener) {
      mediaQuery.addListener(listener);
      return () => mediaQuery.removeListener(listener);
    }
  }, []);

  const isDarkActive = useMemo(() => {
    if (settings.theme === 'system') {
      return systemPrefersDark;
    }
    return settings.theme === 'dark';
  }, [settings.theme, systemPrefersDark]);

  const [isLoggedIn, setIsLoggedIn] = useState<boolean>(() => {
    const saved = localStorage.getItem('ecclesiaste_is_logged_in');
    return saved ? JSON.parse(saved) : false;
  });

  const [sessionUser, setSessionUser] = useState<{
    name: string;
    role: string;
    ministry: string;
    level: string;
  }>(() => {
    const saved = localStorage.getItem('ecclesiaste_session_user');
    return saved ? JSON.parse(saved) : {
      name: "Emmanuel Ngolo",
      role: "Responsable",
      ministry: "Apôtre",
      level: "CHAMP"
    };
  });

  const [activeTab, setActiveTab] = useState<string>('dashboard');

  // Sync state with localStorage
  useEffect(() => {
    localStorage.setItem('ecclesiaste_is_logged_in', JSON.stringify(isLoggedIn));
  }, [isLoggedIn]);

  useEffect(() => {
    localStorage.setItem('ecclesiaste_session_user', JSON.stringify(sessionUser));
  }, [sessionUser]);

  useEffect(() => {
    localStorage.setItem('ecclesiaste_entities', JSON.stringify(entities));
  }, [entities]);

  useEffect(() => {
    localStorage.setItem('ecclesiaste_active_entity_id', activeEntityId);
  }, [activeEntityId]);

  useEffect(() => {
    localStorage.setItem('ecclesiaste_members', JSON.stringify(members));
  }, [members]);

  useEffect(() => {
    localStorage.setItem('ecclesiaste_transactions', JSON.stringify(transactions));
  }, [transactions]);

  useEffect(() => {
    localStorage.setItem('ecclesiaste_reports', JSON.stringify(reports));
  }, [reports]);

  useEffect(() => {
    localStorage.setItem('ecclesiaste_settings', JSON.stringify(settings));
  }, [settings]);

  useEffect(() => {
    localStorage.setItem('ecclesiaste_events', JSON.stringify(events));
  }, [events]);

  const handleAddEvent = (newEvent: Omit<CalendarEvent, 'id'>) => {
    const eventWithId: CalendarEvent = {
      ...newEvent,
      id: `evt_${Date.now()}`
    };
    setEvents(prev => [eventWithId, ...prev]);
  };

  const handleUpdateEvent = (updatedEvent: CalendarEvent) => {
    setEvents(prev => prev.map(e => e.id === updatedEvent.id ? updatedEvent : e));
  };

  const t = TRANSLATIONS[settings.language];

  // Hierarchical scoping helper to resolve descendant entities
  const activeDescendantIds = useMemo(() => {
    const getDescendants = (id: string): string[] => {
      const children = entities.filter(e => e.parent_id === id);
      return [id, ...children.flatMap(c => getDescendants(c.id))];
    };
    return getDescendants(activeEntityId);
  }, [entities, activeEntityId]);

  // Compute reports pending signature (status DRAFT or SUBMITTED) under active entity & sub-entities
  const pendingReportsCount = useMemo(() => {
    return reports.filter(r => 
      activeDescendantIds.includes(r.entityId) && 
      (r.status === 'DRAFT' || r.status === 'SUBMITTED')
    ).length;
  }, [reports, activeDescendantIds]);

  // Compute upcoming events (today or in the future) under active entity & sub-entities
  const upcomingEventsCount = useMemo(() => {
    const todayStr = new Date().toISOString().split('T')[0];
    return events.filter(evt => 
      activeDescendantIds.includes(evt.entityId) && 
      evt.date >= todayStr
    ).length;
  }, [events, activeDescendantIds]);

  // Global modifiers / state mutators
  const handleAddTransaction = (newTx: Omit<FinanceTransaction, 'id'>) => {
    const txWithId: FinanceTransaction = {
      ...newTx,
      id: `tx_${Date.now()}`
    };
    setTransactions(prev => [txWithId, ...prev]);
  };

  const handleAddReport = (newReport: Omit<MonthlyReport, 'id'>) => {
    const reportWithId: MonthlyReport = {
      ...newReport,
      id: `rep_${Date.now()}`
    };
    setReports(prev => [reportWithId, ...prev]);
  };

  const handleUpdateReportStatus = (id: string, status: ReportStatus, signedBy?: string) => {
    setReports(prev => prev.map(r => {
      if (r.id === id) {
        return {
          ...r,
          status,
          signedBy: signedBy ? signedBy : r.signedBy,
          dateSigned: signedBy ? new Date().toISOString().split('T')[0] : r.dateSigned
        };
      }
      return r;
    }));
  };

  const handleAddMember = (newMem: Omit<MemberProfile, 'id'>) => {
    const memberWithId: MemberProfile = {
      ...newMem,
      id: `mem_${Date.now()}`
    };
    setMembers(prev => [memberWithId, ...prev]);
    
    // Update estimates count in entity schema
    setEntities(prev => prev.map(e => {
      if (e.id === newMem.entityId) {
        return {
          ...e,
          members_count: (e.members_count || 0) + 1
        };
      }
      return e;
    }));
  };

  const getFontSizeClass = () => {
    switch (settings.accessibilityScale) {
      case 'small': return 'text-xs';
      case 'large': return 'text-base';
      case 'xlarge': return 'text-lg';
      default: return 'text-sm';
    }
  };

  if (!isLoggedIn) {
    return (
      <div className={isDarkActive ? 'dark-theme-twilight' : ''}>
        <GithubLogin 
          onLoginSuccess={(data) => {
            setSessionUser({
              name: data.username || "Nestor Mbuyi",
              role: data.role,
              ministry: data.ministry,
              level: data.level
            });
            setActiveEntityId(data.entityId);
            setIsLoggedIn(true);
            showToast(`Connexion réussie. Bienvenue ${data.username || "Nestor Mbuyi"} !`, 'success');
          }}
        />
      </div>
    );
  }

  return (
    <div className={`min-h-screen flex flex-col md:flex-row bg-[#F8FAFC] text-[#1E293B] ${getFontSizeClass()} ${
      settings.contrastHigh ? 'contrast-125' : ''
    } ${isDarkActive ? 'dark-theme-twilight' : ''}`}>
      
      {/* --- SIDEBAR NAVIGATION (Desktop) --- */}
      <aside className="w-full md:w-64 bg-[#1B6B9E] text-white flex flex-col shrink-0 shadow-lg border-r border-[#15547C] z-30">
        {/* Header Branding */}
        <div className="p-5 border-b border-white/10 flex items-center gap-3">
          <div className="h-9 w-9 rounded-full bg-white flex items-center justify-center shadow-md">
            <Landmark className="h-5 w-5 text-brand-blue" />
          </div>
          <div>
            <h1 className="font-extrabold text-base tracking-wide uppercase leading-tight">Ecclesiaste</h1>
            <p className="text-[10px] text-white/70 font-semibold">{t.logoSubtitle}</p>
          </div>
        </div>

        {/* Navigation tabs */}
        <nav className="flex-1 p-4 space-y-1.5 overflow-y-auto">
          <button
            onClick={() => setActiveTab('dashboard')}
            className={`w-full flex items-center gap-3 text-xs font-bold py-3 px-3.5 rounded-lg transition-all cursor-pointer ${
              activeTab === 'dashboard' 
                ? 'bg-white text-brand-blue shadow-md' 
                : 'text-white/80 hover:bg-white/10 hover:text-white'
            }`}
          >
            <LayoutDashboard className="h-4.5 w-4.5" />
            {t.dashboard}
          </button>

          <button
            onClick={() => setActiveTab('finance')}
            className={`w-full flex items-center gap-3 text-xs font-bold py-3 px-3.5 rounded-lg transition-all cursor-pointer ${
              activeTab === 'finance' 
                ? 'bg-white text-brand-blue shadow-md' 
                : 'text-white/80 hover:bg-white/10 hover:text-white'
            }`}
          >
            <Wallet className="h-4.5 w-4.5" />
            {t.finance}
          </button>

          <button
            onClick={() => setActiveTab('reports')}
            className={`w-full flex items-center justify-between text-xs font-bold py-3 px-3.5 rounded-lg transition-all cursor-pointer ${
              activeTab === 'reports' 
                ? 'bg-white text-brand-blue shadow-md' 
                : 'text-white/80 hover:bg-white/10 hover:text-white'
            }`}
          >
            <div className="flex items-center gap-3">
              <ScrollText className="h-4.5 w-4.5" />
              {t.reports}
            </div>
            {pendingReportsCount > 0 && (
              <span className={`inline-flex items-center justify-center min-w-5 h-5 px-1.5 text-[9px] font-black rounded-full shadow-sm animate-pulse ${
                activeTab === 'reports' 
                  ? 'bg-amber-100 text-amber-800' 
                  : 'bg-amber-500 text-white'
              }`}>
                {pendingReportsCount}
              </span>
            )}
          </button>

          <button
            onClick={() => setActiveTab('members')}
            className={`w-full flex items-center gap-3 text-xs font-bold py-3 px-3.5 rounded-lg transition-all cursor-pointer ${
              activeTab === 'members' 
                ? 'bg-white text-brand-blue shadow-md' 
                : 'text-white/80 hover:bg-white/10 hover:text-white'
            }`}
          >
            <Users className="h-4.5 w-4.5" />
            {t.members}
          </button>

          <button
            onClick={() => setActiveTab('calendar')}
            className={`w-full flex items-center justify-between text-xs font-bold py-3 px-3.5 rounded-lg transition-all cursor-pointer ${
              activeTab === 'calendar' 
                ? 'bg-white text-brand-blue shadow-md' 
                : 'text-white/80 hover:bg-white/10 hover:text-white'
            }`}
          >
            <div className="flex items-center gap-3">
              <CalendarDays className="h-4.5 w-4.5" />
              {t.calendar}
            </div>
            {upcomingEventsCount > 0 && (
              <span className={`inline-flex items-center justify-center min-w-5 h-5 px-1.5 text-[9px] font-black rounded-full shadow-sm ${
                activeTab === 'calendar' 
                  ? 'bg-emerald-100 text-emerald-800' 
                  : 'bg-emerald-500 text-white'
              }`}>
                {upcomingEventsCount}
              </span>
            )}
          </button>

          <button
            onClick={() => setActiveTab('bible')}
            className={`w-full flex items-center gap-3 text-xs font-bold py-3 px-3.5 rounded-lg transition-all cursor-pointer ${
              activeTab === 'bible' 
                ? 'bg-white text-brand-blue shadow-md' 
                : 'text-white/80 hover:bg-white/10 hover:text-white'
            }`}
          >
            <BookOpen className="h-4.5 w-4.5" />
            {t.bible}
          </button>

          <button
            onClick={() => setActiveTab('settings')}
            className={`w-full flex items-center gap-3 text-xs font-bold py-3 px-3.5 rounded-lg transition-all cursor-pointer ${
              activeTab === 'settings' 
                ? 'bg-white text-brand-blue shadow-md' 
                : 'text-white/80 hover:bg-white/10 hover:text-white'
            }`}
          >
            <SettingsIcon className="h-4.5 w-4.5" />
            {t.settings}
          </button>
        </nav>

        {/* User context footer */}
        <div className="p-4 border-t border-white/10 bg-black/10 text-xs space-y-2.5">
          <div className="flex items-start gap-2">
            <User className="h-4.5 w-4.5 text-white/80 shrink-0 mt-0.5" />
            <div className="min-w-0">
              <p className="font-bold truncate" title={sessionUser.name}>
                {sessionUser.ministry !== 'Aucun' ? `${sessionUser.ministry === 'Apôtre' ? 'Ap.' : sessionUser.ministry === 'Ancien' ? 'Anc.' : sessionUser.ministry === 'Berger' ? 'Bg.' : sessionUser.ministry === 'Diacre' ? 'Dc.' : sessionUser.ministry} ` : ''}
                {sessionUser.name}
              </p>
              <p className="text-[10px] text-white/70 truncate">{sessionUser.role}</p>
            </div>
          </div>
          <div className="flex flex-col gap-1 border-t border-white/5 pt-1.5">
            <button
              onClick={() => {
                setIsLoggedIn(false);
                showToast("Vous avez été déconnecté avec succès.", "info");
              }}
              className="w-full text-left text-[10px] font-bold text-red-300 hover:text-red-200 transition-colors flex items-center gap-1.5 cursor-pointer bg-transparent py-0.5"
            >
              🚪 Se déconnecter (Login GitHub)
            </button>
            <p className="text-[9px] text-white/40 leading-normal">
              {t.credits}
            </p>
          </div>
        </div>
      </aside>

      {/* --- MAIN PAGE CONTENT --- */}
      <main className="flex-1 flex flex-col min-w-0 overflow-y-auto">
        
        {/* Top Navbar Header */}
        <header className="bg-white border-b border-slate-100 py-4 px-6 flex items-center justify-between shadow-sm shrink-0">
          <div className="flex flex-col sm:flex-row sm:items-center gap-3 text-slate-800 font-bold text-sm">
            <div className="flex items-center gap-2">
              <span className={`w-2.5 h-2.5 rounded-full ${isOnline ? 'bg-emerald-500' : 'bg-amber-500 animate-pulse'}`} />
              <span>RDC OUEST - KINSHASA</span>
            </div>
            {!isOnline ? (
              <span className="text-[10px] font-bold text-amber-600 bg-amber-50 border border-amber-200 px-2.5 py-1 rounded-full flex items-center gap-1 shrink-0 animate-pulse">
                <WifiOff className="h-3 w-3 text-amber-500" />
                Mode Hors ligne (Données Locales)
              </span>
            ) : (
              <span className="text-[10px] font-medium text-slate-400 bg-slate-50 border border-slate-100 px-2.5 py-1 rounded-full flex items-center gap-1 shrink-0">
                <Wifi className="h-3 w-3 text-slate-400" />
                En ligne (Synchronisé)
              </span>
            )}
          </div>

          <div className="flex items-center gap-4">
            {/* Quick stats totals */}
            <div className="hidden sm:flex items-center gap-2.5 bg-slate-50 border border-slate-100 py-1.5 px-3 rounded-full text-xs font-semibold">
              <span className="text-slate-400">Total Membres RDC:</span>
              <span className="text-brand-blue font-bold">2,400,000</span>
            </div>

            <a 
              href="https://nac.today" 
              target="_blank" 
              rel="noopener noreferrer" 
              className="text-xs bg-slate-100 hover:bg-slate-200 font-bold py-1.5 px-3.5 rounded-lg text-slate-600 transition-colors inline-flex items-center gap-1 shrink-0"
            >
              nac.today
              <ArrowUpRight className="h-3 w-3" />
            </a>
          </div>
        </header>

        {/* Scrollable container view */}
        <div className="p-6 max-w-7xl w-full mx-auto space-y-6">
          
          {/* COMPASS FIL D'ARIANE (Scope Compass) - ALWAYS VISIBLE AT THE TOP */}
          <CompassBreadcrumb 
            entities={entities} 
            activeEntityId={activeEntityId} 
            onEntityChange={setActiveEntityId} 
          />

          {/* DYNAMIC TAB COMPONENT SHELL */}
          <AnimatePresence mode="wait">
            <motion.div
              key={activeTab + activeEntityId}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.15 }}
            >
              {activeTab === 'dashboard' && (
                <DashboardOverview 
                  entities={entities}
                  activeEntityId={activeEntityId}
                  members={members}
                  transactions={transactions}
                  reports={reports}
                  onTabChange={setActiveTab}
                />
              )}

              {activeTab === 'finance' && (
                <FinanceConsolidationHub 
                  entities={entities}
                  activeEntityId={activeEntityId}
                  transactions={transactions}
                  onAddTransaction={handleAddTransaction}
                />
              )}

              {activeTab === 'reports' && (
                <ReportsEngine 
                  entities={entities}
                  activeEntityId={activeEntityId}
                  reports={reports}
                  onAddReport={handleAddReport}
                  onUpdateReportStatus={handleUpdateReportStatus}
                />
              )}

              {activeTab === 'members' && (
                <MemberManagement 
                  entities={entities}
                  activeEntityId={activeEntityId}
                  members={members}
                  onAddMember={handleAddMember}
                />
              )}

              {activeTab === 'calendar' && (
                <CalendarModule 
                  entities={entities}
                  activeEntityId={activeEntityId}
                  members={members}
                  events={events}
                  onAddEvent={handleAddEvent}
                  onUpdateEvent={handleUpdateEvent}
                />
              )}

              {activeTab === 'bible' && (
                <BibleLibrary />
              )}

              {activeTab === 'settings' && (
                <SettingsPage 
                  settings={settings}
                  onSettingsChange={setSettings}
                />
              )}
            </motion.div>
          </AnimatePresence>
        </div>
      </main>

      {/* Embedded CSS hack for twilight dark theme override directly inside React */}
      <style>{`
        .dark-theme-twilight {
          background-color: #0f172a !important;
          color: #f1f5f9 !important;
        }
        .dark-theme-twilight main {
          background-color: #0b0f19 !important;
        }
        .dark-theme-twilight header {
          background-color: #111827 !important;
          border-color: #1f2937 !important;
          color: #f1f5f9 !important;
        }
        .dark-theme-twilight header span {
          color: #e2e8f0 !important;
        }
        .dark-theme-twilight #compass-nav-card,
        .dark-theme-twilight #finance-consolidation-hub .bg-white,
        .dark-theme-twilight #member-management .bg-white,
        .dark-theme-twilight #reports-engine .bg-white,
        .dark-theme-twilight #dashboard-overview-module .bg-white,
        .dark-theme-twilight #bible-library-module .bg-white,
        .dark-theme-twilight #settings-page-enhanced .bg-white {
          background-color: #1e293b !important;
          border-color: #334155 !important;
          color: #e2e8f0 !important;
        }
        .dark-theme-twilight h2, 
        .dark-theme-twilight h3, 
        .dark-theme-twilight h4, 
        .dark-theme-twilight h5, 
        .dark-theme-twilight td, 
        .dark-theme-twilight th,
        .dark-theme-twilight input, 
        .dark-theme-twilight select, 
        .dark-theme-twilight textarea {
          color: #f8fafc !important;
        }
        .dark-theme-twilight select,
        .dark-theme-twilight input,
        .dark-theme-twilight textarea {
          background-color: #111827 !important;
          border-color: #334155 !important;
        }
        .dark-theme-twilight .bg-slate-50,
        .dark-theme-twilight .bg-slate-50\\/20 {
          background-color: #0f172a !important;
        }
        .dark-theme-twilight .text-slate-800,
        .dark-theme-twilight .text-slate-700,
        .dark-theme-twilight .text-slate-600,
        .dark-theme-twilight .text-slate-500 {
          color: #cbd5e1 !important;
        }
        .dark-theme-twilight .text-slate-900 {
          color: #f1f5f9 !important;
        }
        .dark-theme-twilight .border-slate-100,
        .dark-theme-twilight .border-slate-50,
        .dark-theme-twilight .divide-slate-50 {
          border-color: #334155 !important;
          divide-color: #334155 !important;
        }

        /* GitHub login dark theme overrides */
        .dark-theme-twilight .github-login-container {
          background-color: #0d1117 !important;
          color: #c9d1d9 !important;
        }
        .dark-theme-twilight .github-login-card {
          background-color: #161b22 !important;
          border-color: #30363d !important;
          color: #c9d1d9 !important;
        }
        .dark-theme-twilight .github-login-input,
        .dark-theme-twilight .github-login-select {
          background-color: #0d1117 !important;
          border-color: #30363d !important;
          color: #c9d1d9 !important;
        }
      `}</style>
    </div>
  );
}
