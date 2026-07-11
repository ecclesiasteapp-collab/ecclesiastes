import React, { useMemo } from 'react';
import { EcclesiasticalEntity, MemberProfile, FinanceTransaction, MonthlyReport } from '../types';
import { INITIAL_NEWS } from '../data';
import { Landmark, Users, ScrollText, Wallet, Calendar, ArrowRight, ShieldCheck, HeartHandshake, Sparkles, MessageSquareHeart, TrendingUp, BarChart2, ArrowUpRight, ArrowDownRight } from 'lucide-react';
import { motion } from 'motion/react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend, PieChart, Pie, Cell, BarChart, Bar } from 'recharts';

interface DashboardOverviewProps {
  entities: EcclesiasticalEntity[];
  activeEntityId: string;
  members: MemberProfile[];
  transactions: FinanceTransaction[];
  reports: MonthlyReport[];
  onTabChange: (tab: string) => void;
}

export const DashboardOverview: React.FC<DashboardOverviewProps> = ({
  entities,
  activeEntityId,
  members,
  transactions,
  reports,
  onTabChange
}) => {
  // Find current active entity
  const currentEntity = useMemo(() => {
    return entities.find(e => e.id === activeEntityId) || entities[0];
  }, [entities, activeEntityId]);

  // Descendants recursive calculation
  const descendantIds = useMemo(() => {
    const getDescendants = (id: string): string[] => {
      const list = [id];
      const children = entities.filter(e => e.parent_id === id);
      children.forEach(c => {
        list.push(...getDescendants(c.id));
      });
      return list;
    };
    return getDescendants(activeEntityId);
  }, [entities, activeEntityId]);

  // Filter scoped data
  const scopedMembers = useMemo(() => {
    return members.filter(m => descendantIds.includes(m.entityId));
  }, [members, descendantIds]);

  const scopedTransactions = useMemo(() => {
    return transactions.filter(t => descendantIds.includes(t.entityId));
  }, [transactions, descendantIds]);

  const scopedReports = useMemo(() => {
    return reports.filter(r => descendantIds.includes(r.entityId));
  }, [reports, descendantIds]);

  const stats = useMemo(() => {
    const membersCount = scopedMembers.length;
    const clergyCount = scopedMembers.filter(m => m.rank !== 'Membre').length;
    
    let offerings = 0;
    scopedTransactions.forEach(t => {
      if (t.type === 'OFFERING') offerings += t.amount;
    });

    const pendingReportsCount = scopedReports.filter(r => r.status === 'SUBMITTED').length;

    return { membersCount, clergyCount, offerings, pendingReportsCount };
  }, [scopedMembers, scopedTransactions, scopedReports]);

  // Dynamic Chart Data mapping historical reports + live transactions
  const chartData = useMemo(() => {
    const months = ["2026-01", "2026-02", "2026-03", "2026-04", "2026-05", "2026-06", "2026-07"];
    const dataMap = new Map<string, { offerings: number; donations: number; expenses: number }>();
    
    // Initialize base months for a complete calendar view
    months.forEach(m => {
      dataMap.set(m, { offerings: 0, donations: 0, expenses: 0 });
    });

    // Populate historical monthly reports data
    scopedReports.forEach(r => {
      const monthKey = r.month; // e.g. "2026-05"
      if (!dataMap.has(monthKey)) {
        dataMap.set(monthKey, { offerings: 0, donations: 0, expenses: 0 });
      }
      const current = dataMap.get(monthKey)!;
      current.offerings += r.kpis.offeringsAmount;
      // Historical expenses estimated at ~35% of offerings for a clean baseline
      current.expenses += Math.round(r.kpis.offeringsAmount * 0.35);
    });

    // Merge live/current transactions
    scopedTransactions.forEach(t => {
      if (!t.date) return;
      const monthKey = t.date.substring(0, 7); // "YYYY-MM"
      
      if (!dataMap.has(monthKey)) {
        dataMap.set(monthKey, { offerings: 0, donations: 0, expenses: 0 });
      }
      
      const current = dataMap.get(monthKey)!;
      if (t.type === 'OFFERING') {
        current.offerings += t.amount;
      } else if (t.type === 'DONATION') {
        current.donations += t.amount;
      } else if (t.type === 'EXPENSE') {
        current.expenses += t.amount;
      }
    });

    // Convert to sorted array with clean French labels
    return Array.from(dataMap.entries())
      .map(([month, vals]) => {
        const [year, monthNum] = month.split('-');
        const monthNames: Record<string, string> = {
          '01': 'Jan', '02': 'Fév', '03': 'Mar', '04': 'Avr',
          '05': 'Mai', '06': 'Juin', '07': 'Juil', '08': 'Août',
          '09': 'Sept', '10': 'Oct', '11': 'Nov', '12': 'Déc'
        };
        const label = `${monthNames[monthNum] || monthNum} ${year}`;
        
        return {
          month,
          label,
          "Offrandes": vals.offerings,
          "Dons Spéciaux": vals.donations,
          "Dépenses": vals.expenses,
          "Total Entrées": vals.offerings + vals.donations
        };
      })
      .sort((a, b) => a.month.localeCompare(b.month));
  }, [scopedTransactions, scopedReports]);

  // Compute month-over-month financial comparison
  const comparisonData = useMemo(() => {
    if (chartData.length < 2) return null;
    
    // Get the last two months that have data
    const prev = chartData[chartData.length - 2];
    const curr = chartData[chartData.length - 1];

    const prevRev = prev["Total Entrées"] || 0;
    const currRev = curr["Total Entrées"] || 0;
    const prevExp = prev["Dépenses"] || 0;
    const currExp = curr["Dépenses"] || 0;

    const revDiff = currRev - prevRev;
    const revPct = prevRev > 0 ? (revDiff / prevRev) * 100 : 0;

    const expDiff = currExp - prevExp;
    const expPct = prevExp > 0 ? (expDiff / prevExp) * 100 : 0;

    // Grouped by financial dimension so bars represent previous vs current side-by-side
    const barData = [
      {
        name: 'Revenus (Entrées)',
        [prev.label]: prevRev,
        [curr.label]: currRev,
      },
      {
        name: 'Dépenses',
        [prev.label]: prevExp,
        [curr.label]: currExp,
      }
    ];

    return {
      prevLabel: prev.label,
      currLabel: curr.label,
      prevRev,
      currRev,
      prevExp,
      currExp,
      revDiff,
      revPct,
      expDiff,
      expPct,
      barData
    };
  }, [chartData]);

  // Group members by their ministry/rank for Pie Chart
  const ministryData = useMemo(() => {
    const counts: Record<string, number> = {};
    scopedMembers.forEach(m => {
      const rankName = m.rank || 'Membre';
      counts[rankName] = (counts[rankName] || 0) + 1;
    });

    const colors: Record<string, string> = {
      'Apôtre': '#1B6B9E', // Brand blue
      'Ancien de District': '#0284C7', // Sky blue
      'Ancien': '#0369A1', // Darker sky blue
      'Berger': '#0EA5E9', // Light blue
      'Prêtre': '#06B6D4', // Cyan
      'Diacre': '#14B8A6', // Teal
      'Evangéliste': '#3B82F6', // Blue
      'Membre': '#94A3B8', // Slate grey
    };

    const defaultColors = ['#10B981', '#F59E0B', '#EF4444', '#8B5CF6', '#EC4899'];
    let defaultColorIndex = 0;

    return Object.entries(counts).map(([name, value]) => {
      const color = colors[name] || defaultColors[defaultColorIndex++ % defaultColors.length];
      return {
        name,
        value,
        color
      };
    }).sort((a, b) => b.value - a.value);
  }, [scopedMembers]);

  // Mock list of church commission groups to display in the grid
  const commissions = [
    { code: "ecodim", label: "Ecodim", color: "from-amber-400 to-orange-500", desc: "École du dimanche, apprentissage liturgique des enfants." },
    { code: "jeunesse", label: "Jeunesse", color: "from-blue-400 to-indigo-500", desc: "Regroupement mixte, chorales des jeunes, et kermesses." },
    { code: "musique", label: "Musique", color: "from-teal-400 to-emerald-500", desc: "Orchestre de district, direction des chœurs et répétitions." },
    { code: "mamans", label: "Mamans", color: "from-rose-400 to-pink-500", desc: "Action d'assistance fraternelle et préparation des fêtes." }
  ];

  return (
    <div id="dashboard-overview-module" className="space-y-6">
      {/* Scope Greeting card */}
      <div className="relative bg-gradient-to-r from-brand-blue to-[#2582BE] rounded-xl shadow-md p-6 text-white overflow-hidden">
        <div className="absolute right-0 bottom-0 opacity-10 translate-y-1/4 translate-x-1/10">
          <Landmark className="h-48 w-48 stroke-1" />
        </div>
        
        <div className="relative z-10 max-w-xl">
          <div className="flex items-center gap-2 mb-2 bg-white/10 px-2.5 py-1 rounded-full text-xs font-bold w-fit border border-white/20">
            <Sparkles className="h-3.5 w-3.5 text-amber-300 fill-amber-300" />
            Niveau de Scope : {currentEntity.level}
          </div>
          <h2 className="text-2xl font-bold tracking-tight">Bienvenue sur Ecclesiaste ERP</h2>
          <p className="text-white/85 text-sm mt-1.5 leading-relaxed">
            Actuellement connecté sur le scope <strong className="text-white font-bold">{currentEntity.name}</strong>.
            Tous les KPIs financiers, recensements de membres, rapports pastoraux et communications sont filtrés dynamiquement.
          </p>
        </div>
      </div>

      {/* Primary KPI Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <motion.div whileHover={{ y: -2 }} className="bg-white rounded-xl shadow-sm border border-slate-100 p-4 flex items-center justify-between">
          <div>
            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Membres Actifs (Base)</p>
            <p className="text-xl font-black text-slate-800 mt-1">{stats.membersCount} fidèles</p>
            <p className="text-[9px] text-slate-400 mt-0.5">Recensés localement</p>
          </div>
          <div className="p-2.5 bg-blue-50 text-brand-blue rounded-lg">
            <Users className="h-5 w-5" />
          </div>
        </motion.div>

        <motion.div whileHover={{ y: -2 }} className="bg-white rounded-xl shadow-sm border border-slate-100 p-4 flex items-center justify-between">
          <div>
            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Clergé de Service</p>
            <p className="text-xl font-black text-slate-800 mt-1">{stats.clergyCount} ministres</p>
            <p className="text-[9px] text-slate-400 mt-0.5">Ministères actifs</p>
          </div>
          <div className="p-2.5 bg-emerald-50 text-emerald-600 rounded-lg">
            <ShieldCheck className="h-5 w-5" />
          </div>
        </motion.div>

        <motion.div whileHover={{ y: -2 }} className="bg-white rounded-xl shadow-sm border border-slate-100 p-4 flex items-center justify-between">
          <div>
            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Trésorerie Offrandes</p>
            <p className="text-xl font-black text-slate-800 mt-1">${stats.offerings.toLocaleString()}</p>
            <p className="text-[9px] text-slate-400 mt-0.5">Cumul des caisses</p>
          </div>
          <div className="p-2.5 bg-indigo-50 text-indigo-600 rounded-lg">
            <Wallet className="h-5 w-5" />
          </div>
        </motion.div>

        <motion.div whileHover={{ y: -2 }} className="bg-white rounded-xl shadow-sm border border-slate-100 p-4 flex items-center justify-between">
          <div>
            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Rapports à Valider</p>
            <p className="text-xl font-black text-slate-800 mt-1">{stats.pendingReportsCount} à approuver</p>
            <p className="text-[9px] text-slate-400 mt-0.5">Status soumis</p>
          </div>
          <div className="p-2.5 bg-rose-50 text-rose-600 rounded-lg">
            <ScrollText className="h-5 w-5" />
          </div>
        </motion.div>
      </div>

      {/* Financial Comparison: MoM Performance */}
      {comparisonData && (
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5">
          <div className="pb-4 mb-4 border-b border-slate-100">
            <h3 className="font-bold text-slate-800 text-sm flex items-center gap-1.5">
              <BarChart2 className="h-4 w-4 text-brand-blue" />
              Comparatif Financier Mensuel ({comparisonData.prevLabel} vs {comparisonData.currLabel})
            </h3>
            <p className="text-[11px] text-slate-500 mt-0.5">
              Analyse comparative directe des performances de revenus (offrandes & dons) et de dépenses par rapport au mois précédent.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Metric Deltas Breakdown */}
            <div className="md:col-span-1 flex flex-col justify-center space-y-4">
              {/* Revenue MoM Card */}
              <div className="p-4 bg-slate-50 border border-slate-100 rounded-xl space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-[10px] font-bold text-slate-500 uppercase tracking-wider">Total Revenus (Entrées)</span>
                  <span className={`inline-flex items-center gap-0.5 text-[10px] font-bold px-2 py-0.5 rounded-full ${
                    comparisonData.revDiff >= 0 
                      ? 'bg-emerald-50 text-emerald-700 border border-emerald-100' 
                      : 'bg-rose-50 text-rose-700 border border-rose-100'
                  }`}>
                    {comparisonData.revDiff >= 0 ? <ArrowUpRight className="h-3 w-3" /> : <ArrowDownRight className="h-3 w-3" />}
                    {Math.abs(comparisonData.revPct).toFixed(1)}%
                  </span>
                </div>
                <div className="flex items-baseline gap-2">
                  <span className="text-xl font-black text-slate-800">${comparisonData.currRev.toLocaleString()}</span>
                  <span className="text-[10px] text-slate-400">vs ${comparisonData.prevRev.toLocaleString()} ({comparisonData.prevLabel})</span>
                </div>
                <p className="text-[9px] text-slate-400">
                  {comparisonData.revDiff >= 0 
                    ? `Augmentation de $${comparisonData.revDiff.toLocaleString()} de la générosité des fidèles.` 
                    : `Baisse de $${Math.abs(comparisonData.revDiff).toLocaleString()} par rapport au mois dernier.`}
                </p>
              </div>

              {/* Expense MoM Card */}
              <div className="p-4 bg-slate-50 border border-slate-100 rounded-xl space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-[10px] font-bold text-slate-500 uppercase tracking-wider">Dépenses Consolidees</span>
                  <span className={`inline-flex items-center gap-0.5 text-[10px] font-bold px-2 py-0.5 rounded-full ${
                    comparisonData.expDiff <= 0 
                      ? 'bg-emerald-50 text-emerald-700 border border-emerald-100' 
                      : 'bg-amber-50 text-amber-700 border border-amber-100'
                  }`}>
                    {comparisonData.expDiff <= 0 ? <ArrowDownRight className="h-3 w-3" /> : <ArrowUpRight className="h-3 w-3" />}
                    {Math.abs(comparisonData.expPct).toFixed(1)}%
                  </span>
                </div>
                <div className="flex items-baseline gap-2">
                  <span className="text-xl font-black text-slate-800">${comparisonData.currExp.toLocaleString()}</span>
                  <span className="text-[10px] text-slate-400">vs ${comparisonData.prevExp.toLocaleString()} ({comparisonData.prevLabel})</span>
                </div>
                <p className="text-[9px] text-slate-400">
                  {comparisonData.expDiff <= 0 
                    ? `Excellente maîtrise budgétaire avec une réduction de $${Math.abs(comparisonData.expDiff).toLocaleString()}.` 
                    : `Augmentation de $${comparisonData.expDiff.toLocaleString()} des dépenses opérationnelles.`}
                </p>
              </div>
            </div>

            {/* Side-by-side Bar Chart */}
            <div className="md:col-span-2 h-64 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart
                  data={comparisonData.barData}
                  margin={{ top: 10, right: 10, left: -20, bottom: 0 }}
                >
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F1F5F9" />
                  <XAxis 
                    dataKey="name" 
                    tickLine={false} 
                    axisLine={false}
                    tick={{ fontSize: 10, fill: '#64748B', fontWeight: 600 }}
                  />
                  <YAxis 
                    tickLine={false} 
                    axisLine={false}
                    tickFormatter={(value) => `$${value.toLocaleString()}`}
                    tick={{ fontSize: 10, fill: '#64748B', fontWeight: 500 }}
                  />
                  <Tooltip 
                    contentStyle={{ 
                      backgroundColor: '#FFFFFF', 
                      borderColor: '#E2E8F0', 
                      borderRadius: '12px',
                      boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)',
                      fontSize: '11px',
                      color: '#1E293B',
                      fontFamily: 'Inter, sans-serif'
                    }}
                    formatter={(value: any) => [`$${Number(value).toLocaleString()}`]}
                  />
                  <Legend 
                    verticalAlign="top" 
                    height={36} 
                    iconType="circle"
                    iconSize={8}
                    wrapperStyle={{ fontSize: '11px', fontWeight: 600, color: '#475569' }}
                  />
                  <Bar dataKey={comparisonData.prevLabel} fill="#94A3B8" radius={[4, 4, 0, 0]} maxBarSize={50} />
                  <Bar dataKey={comparisonData.currLabel} fill="#1B6B9E" radius={[4, 4, 0, 0]} maxBarSize={50} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>
      )}

      {/* Dynamic Visualizations Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Evolution Financière Chart Card */}
        <div className="lg:col-span-2 bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col justify-between">
          <div>
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pb-4 mb-4 border-b border-slate-100">
              <div>
                <h3 className="font-bold text-slate-800 text-sm flex items-center gap-1.5">
                  <TrendingUp className="h-4 w-4 text-brand-blue" />
                  Évolution Mensuelle de la Trésorerie
                </h3>
                <p className="text-[11px] text-slate-500 mt-0.5">
                  Suivi consolidé récursif des offrandes, dons et dépenses pour l'entité active : <strong className="text-brand-blue font-bold">{currentEntity.name}</strong> ({currentEntity.level})
                </p>
              </div>
              <div className="text-right sm:text-right text-[10px] font-bold text-brand-blue bg-brand-blue/5 py-1 px-3 rounded-lg border border-brand-blue/10 w-fit">
                Ajustement Scope Actif
              </div>
            </div>

            <div className="h-72 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart
                  data={chartData}
                  margin={{ top: 10, right: 10, left: -20, bottom: 0 }}
                >
                  <defs>
                    <linearGradient id="colorEntrees" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#1B6B9E" stopOpacity={0.25}/>
                      <stop offset="95%" stopColor="#1B6B9E" stopOpacity={0.01}/>
                    </linearGradient>
                    <linearGradient id="colorExpenses" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#EF4444" stopOpacity={0.25}/>
                      <stop offset="95%" stopColor="#EF4444" stopOpacity={0.01}/>
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F1F5F9" />
                  <XAxis 
                    dataKey="label" 
                    tickLine={false} 
                    axisLine={false}
                    tick={{ fontSize: 10, fill: '#64748B', fontWeight: 500 }}
                  />
                  <YAxis 
                    tickLine={false} 
                    axisLine={false}
                    tickFormatter={(value) => `$${value.toLocaleString()}`}
                    tick={{ fontSize: 10, fill: '#64748B', fontWeight: 500 }}
                  />
                  <Tooltip 
                    contentStyle={{ 
                      backgroundColor: '#FFFFFF', 
                      borderColor: '#E2E8F0', 
                      borderRadius: '12px',
                      boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)',
                      fontSize: '11px',
                      color: '#1E293B',
                      fontFamily: 'Inter, sans-serif'
                    }}
                    formatter={(value: any) => [`$${Number(value).toLocaleString()}`]}
                  />
                  <Legend 
                    verticalAlign="top" 
                    height={36} 
                    iconType="circle"
                    iconSize={8}
                    wrapperStyle={{ fontSize: '11px', fontWeight: 600, color: '#475569' }}
                  />
                  <Area 
                    type="monotone" 
                    dataKey="Total Entrées" 
                    stroke="#1B6B9E" 
                    strokeWidth={2}
                    fillOpacity={1} 
                    fill="url(#colorEntrees)" 
                  />
                  <Area 
                    type="monotone" 
                    dataKey="Dépenses" 
                    stroke="#EF4444" 
                    strokeWidth={2}
                    fillOpacity={1} 
                    fill="url(#colorExpenses)" 
                  />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>

        {/* Répartition des membres par ministère Pie Chart Card */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col justify-between">
          <div>
            <div className="pb-4 mb-4 border-b border-slate-100">
              <h3 className="font-bold text-slate-800 text-sm flex items-center gap-1.5">
                <Users className="h-4 w-4 text-brand-blue" />
                Répartition par Ministère
              </h3>
              <p className="text-[11px] text-slate-500 mt-0.5">
                Composition par fonction ecclésiastique
              </p>
            </div>

            {ministryData.length === 0 ? (
              <div className="h-56 flex items-center justify-center text-center">
                <p className="text-xs text-slate-400">Aucune donnée disponible pour ce scope.</p>
              </div>
            ) : (
              <>
                <div className="relative h-48 w-full flex items-center justify-center">
                  <div className="absolute flex flex-col items-center justify-center text-center">
                    <span className="text-2xl font-black text-slate-800">{scopedMembers.length}</span>
                    <span className="text-[10px] uppercase font-bold text-slate-400 tracking-wider">Fidèles</span>
                  </div>
                  <ResponsiveContainer width="100%" height="100%">
                    <PieChart>
                      <Pie
                        data={ministryData}
                        cx="50%"
                        cy="50%"
                        innerRadius={55}
                        outerRadius={75}
                        paddingAngle={3}
                        dataKey="value"
                      >
                        {ministryData.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={entry.color} />
                        ))}
                      </Pie>
                      <Tooltip 
                        formatter={(value: any) => [`${value} membre(s)`, 'Effectif']}
                        contentStyle={{ 
                          backgroundColor: '#FFFFFF', 
                          borderColor: '#E2E8F0', 
                          borderRadius: '12px',
                          boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)',
                          fontSize: '11px',
                          fontFamily: 'Inter, sans-serif'
                        }}
                      />
                    </PieChart>
                  </ResponsiveContainer>
                </div>

                <div className="grid grid-cols-2 gap-2 mt-4 max-h-32 overflow-y-auto pr-1">
                  {ministryData.map((m, idx) => (
                    <div key={`${m.name}_${idx}`} className="flex items-center gap-1.5 text-[11px] text-slate-600">
                      <span className="h-2 w-2 rounded-full shrink-0" style={{ backgroundColor: m.color }} />
                      <span className="truncate" title={m.name}>{m.name}</span>
                      <span className="font-bold text-slate-800 ml-auto">({m.value})</span>
                    </div>
                  ))}
                </div>
              </>
            )}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* News & Announcements Feed Column */}
        <div className="lg:col-span-2 space-y-4">
          <div className="flex items-center justify-between pb-2 border-b border-slate-100">
            <h3 className="font-bold text-slate-800 text-sm flex items-center gap-1.5">
              <Sparkles className="h-4 w-4 text-brand-blue" />
              Annonces & Nouvelles de l'Église
            </h3>
            <span className="text-[10px] font-bold text-brand-blue bg-brand-blue/5 py-1 px-2.5 rounded-full">Dernière mise à jour : Juillet 2026</span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {INITIAL_NEWS.map((item) => (
              <div key={item.id} className="bg-white rounded-xl border border-slate-100 overflow-hidden flex flex-col justify-between hover:shadow-sm transition-shadow">
                <div>
                  <div className="relative h-40 bg-slate-100 flex items-center justify-center overflow-hidden">
                    {/* Placeholder visual color container with icon since images are local and inside assets */}
                    <div className="absolute inset-0 bg-gradient-to-tr from-brand-blue/20 to-indigo-600/10" />
                    <Landmark className="h-12 w-12 text-brand-blue/40" />
                    <div className="absolute top-3 left-3 bg-brand-blue text-white text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">
                      {item.category}
                    </div>
                  </div>
                  
                  <div className="p-4">
                    <span className="text-[10px] font-semibold text-slate-400 flex items-center gap-1">
                      <Calendar className="h-3.5 w-3.5" />
                      {item.date}
                    </span>
                    <h4 className="font-bold text-slate-800 text-sm mt-1.5 leading-snug">{item.title}</h4>
                    <p className="text-xs text-slate-500 mt-1.5 leading-relaxed line-clamp-3">{item.summary}</p>
                  </div>
                </div>

                <div className="p-4 pt-0 border-t border-slate-50 mt-2">
                  <button
                    onClick={() => onTabChange('bible')}
                    className="text-xs font-semibold text-brand-blue hover:text-brand-blue/80 flex items-center gap-1 cursor-pointer"
                  >
                    Lire les écritures associées
                    <ArrowRight className="h-3.5 w-3.5" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Commissions & Action Center Column */}
        <div className="space-y-4">
          <div className="pb-2 border-b border-slate-100">
            <h3 className="font-bold text-slate-800 text-sm flex items-center gap-1.5">
              <HeartHandshake className="h-4 w-4 text-emerald-500" />
              Commissions Actives de Communauté
            </h3>
          </div>

          <div className="space-y-3">
            {commissions.map((c) => (
              <div key={c.code} className="bg-white rounded-xl p-4 border border-slate-100 hover:shadow-sm transition-shadow flex gap-3">
                <div className={`h-1.5 w-1.5 rounded-full bg-gradient-to-r ${c.color} shrink-0 mt-2`} />
                <div className="space-y-1">
                  <h5 className="font-bold text-slate-800 text-xs">{c.label}</h5>
                  <p className="text-[11px] text-slate-500 leading-relaxed">{c.desc}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="bg-slate-50 border border-slate-100 rounded-xl p-4 flex gap-3">
            <MessageSquareHeart className="h-5 w-5 text-brand-blue shrink-0 mt-0.5" />
            <div className="space-y-1">
              <h5 className="font-bold text-slate-800 text-xs">Joseph d’Arimathée</h5>
              <p className="text-[11px] text-slate-500 leading-relaxed">
                Les Piliers et l'assistance technique pour les événements d'assistance sanitaire et sécuritaire.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
