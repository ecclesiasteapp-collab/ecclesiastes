import React, { useState, useMemo } from 'react';
import { EcclesiasticalEntity, FinanceTransaction, TransactionType } from '../types';
import { PlusCircle, Wallet, ArrowUpRight, ArrowDownRight, TrendingUp, Calendar, FileText, CheckCircle, Download } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, AreaChart, Area } from 'recharts';
import { useToast } from './Toast';

interface FinanceConsolidationHubProps {
  entities: EcclesiasticalEntity[];
  activeEntityId: string;
  transactions: FinanceTransaction[];
  onAddTransaction: (tx: Omit<FinanceTransaction, 'id'>) => void;
}

export const FinanceConsolidationHub: React.FC<FinanceConsolidationHubProps> = ({
  entities,
  activeEntityId,
  transactions,
  onAddTransaction
}) => {
  const { showToast } = useToast();
  const [showAddForm, setShowAddForm] = useState(false);
  const [newTxType, setNewTxType] = useState<TransactionType>('OFFERING');
  const [newTxAmount, setNewTxAmount] = useState('');
  const [newTxDate, setNewTxDate] = useState(new Date().toISOString().split('T')[0]);
  const [newTxDesc, setNewTxDesc] = useState('');

  // Find active entity
  const activeEntity = useMemo(() => {
    return entities.find(e => e.id === activeEntityId) || entities[0];
  }, [entities, activeEntityId]);

  // Recursively find all descendant ids of the active entity
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

  // Filter transactions belonging to active entity or any descendant (Consolidated scope)
  const consolidatedTransactions = useMemo(() => {
    return transactions.filter(t => descendantIds.includes(t.entityId));
  }, [transactions, descendantIds]);

  // Financial aggregates
  const stats = useMemo(() => {
    let offerings = 0;
    let donations = 0;
    let expenses = 0;

    consolidatedTransactions.forEach(t => {
      if (t.type === 'OFFERING') offerings += t.amount;
      else if (t.type === 'DONATION') donations += t.amount;
      else if (t.type === 'EXPENSE') expenses += t.amount;
    });

    const income = offerings + donations;
    const balance = income - expenses;

    return { offerings, donations, expenses, income, balance };
  }, [consolidatedTransactions]);

  // Prepare chart data by entity for comparison
  const chartDataByEntity = useMemo(() => {
    // If we are at the community level, we just display the transaction log or history over days
    // Otherwise, we show the aggregation by immediate child entities!
    const immediateChildren = entities.filter(e => e.parent_id === activeEntityId);
    
    if (immediateChildren.length === 0) {
      // Community level - show over the last few days
      const days: Record<string, { date: string; Offrandes: number; Dons: number; Dépenses: number }> = {};
      consolidatedTransactions.forEach(t => {
        if (!days[t.date]) {
          days[t.date] = { date: t.date, Offrandes: 0, Dons: 0, Dépenses: 0 };
        }
        if (t.type === 'OFFERING') days[t.date].Offrandes += t.amount;
        else if (t.type === 'DONATION') days[t.date].Dons += t.amount;
        else if (t.type === 'EXPENSE') days[t.date].Dépenses += t.amount;
      });
      return Object.values(days).sort((a, b) => a.date.localeCompare(b.date)).slice(-7);
    }

    // High levels - aggregate by immediate child
    return immediateChildren.map(child => {
      const childDescendants = (() => {
        const getDescendants = (id: string): string[] => {
          const list = [id];
          const children = entities.filter(e => e.parent_id === id);
          children.forEach(c => {
            list.push(...getDescendants(c.id));
          });
          return list;
        };
        return getDescendants(child.id);
      })();

      let off = 0;
      let don = 0;
      let exp = 0;

      transactions.forEach(t => {
        if (childDescendants.includes(t.entityId)) {
          if (t.type === 'OFFERING') off += t.amount;
          else if (t.type === 'DONATION') don += t.amount;
          else if (t.type === 'EXPENSE') exp += t.amount;
        }
      });

      return {
        name: child.name.length > 15 ? child.name.substring(0, 15) + '...' : child.name,
        Offrandes: off,
        Dons: don,
        Dépenses: exp,
      };
    });
  }, [entities, activeEntityId, transactions, consolidatedTransactions]);

  const handleAddSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const amount = parseFloat(newTxAmount);
    if (isNaN(amount) || amount <= 0 || !newTxDesc.trim()) return;

    onAddTransaction({
      type: newTxType,
      amount,
      date: newTxDate,
      description: newTxDesc,
      entityId: activeEntityId
    });

    const typeLabels: Record<TransactionType, string> = {
      OFFERING: 'Offrande',
      DONATION: 'Donation',
      EXPENSE: 'Dépense'
    };
    showToast(`Transaction de type ${typeLabels[newTxType]} d'un montant de $${amount.toLocaleString()} enregistrée avec succès.`, 'success');

    setNewTxAmount('');
    setNewTxDesc('');
    setShowAddForm(false);
  };

  const getEntityName = (id: string) => {
    return entities.find(e => e.id === id)?.name || id;
  };

  const handleExportCSV = () => {
    if (consolidatedTransactions.length === 0) {
      showToast("Aucune transaction à exporter dans le scope actif.", "error");
      return;
    }

    const typeLabels: Record<TransactionType, string> = {
      OFFERING: 'Offrande',
      DONATION: 'Don Special',
      EXPENSE: 'Depense'
    };

    // CSV headers
    const headers = ['ID', 'Date', 'Juridiction d\'Origine', 'Type', 'Description', 'Montant ($)', 'Statut'];
    
    // Process rows
    const rows = consolidatedTransactions.map(tx => [
      tx.id,
      tx.date,
      getEntityName(tx.entityId),
      typeLabels[tx.type] || tx.type,
      `"${tx.description.replace(/"/g, '""')}"`,
      tx.amount,
      'Valide (Consolide)'
    ]);

    const csvContent = [
      headers.join(','),
      ...rows.map(row => row.join(','))
    ].join('\n');

    // Create file and trigger browser download with UTF-8 BOM
    const blob = new Blob([new Uint8Array([0xEF, 0xBB, 0xBF]), csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    
    const safeEntityName = activeEntity.name.toLowerCase().replace(/[^a-z0-9]/g, '_');
    link.setAttribute('href', url);
    link.setAttribute('download', `ecclesiaste_transactions_${safeEntityName}_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showToast(`Export de ${consolidatedTransactions.length} transactions reussi !`, 'success');
  };

  return (
    <div id="finance-consolidation-hub" className="space-y-6">
      {/* Financial KPIs row */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <motion.div whileHover={{ y: -2 }} className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex items-center justify-between">
          <div>
            <p className="text-xs font-semibold text-slate-500 uppercase">Offrandes Consolidées</p>
            <p className="text-2xl font-bold text-slate-900 mt-1">${stats.offerings.toLocaleString()}</p>
            <p className="text-[10px] text-slate-400 mt-1">Saisie locale & d'ancêtres</p>
          </div>
          <div className="p-3 bg-blue-50 text-blue-600 rounded-lg">
            <Wallet className="h-6 w-6" />
          </div>
        </motion.div>

        <motion.div whileHover={{ y: -2 }} className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex items-center justify-between">
          <div>
            <p className="text-xs font-semibold text-slate-500 uppercase">Dons Projets / Spéciaux</p>
            <p className="text-2xl font-bold text-slate-900 mt-1">${stats.donations.toLocaleString()}</p>
            <p className="text-[10px] text-slate-400 mt-1">Fonds ciblés de construction</p>
          </div>
          <div className="p-3 bg-emerald-50 text-emerald-600 rounded-lg">
            <ArrowUpRight className="h-6 w-6" />
          </div>
        </motion.div>

        <motion.div whileHover={{ y: -2 }} className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex items-center justify-between">
          <div>
            <p className="text-xs font-semibold text-slate-500 uppercase">Dépenses et Sorties</p>
            <p className="text-2xl font-bold text-slate-900 mt-1">${stats.expenses.toLocaleString()}</p>
            <p className="text-[10px] text-slate-400 mt-1">Carburant, entretien, œuvres</p>
          </div>
          <div className="p-3 bg-rose-50 text-rose-600 rounded-lg">
            <ArrowDownRight className="h-6 w-6" />
          </div>
        </motion.div>

        <motion.div whileHover={{ y: -2 }} className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex items-center justify-between">
          <div>
            <p className="text-xs font-semibold text-slate-500 uppercase">Solde Net Restant</p>
            <p className={`text-2xl font-bold mt-1 ${stats.balance >= 0 ? 'text-emerald-600' : 'text-rose-600'}`}>
              ${stats.balance.toLocaleString()}
            </p>
            <p className="text-[10px] text-slate-400 mt-1">Trésorerie disponible</p>
          </div>
          <div className={`p-3 rounded-lg ${stats.balance >= 0 ? 'bg-emerald-50 text-emerald-600' : 'bg-rose-50 text-rose-600'}`}>
            <TrendingUp className="h-6 w-6" />
          </div>
        </motion.div>
      </div>

      {/* Main section: Chart & Adding transactions */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Chart Column */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 lg:col-span-2">
          <div className="flex items-center justify-between pb-4 mb-4 border-b border-slate-100">
            <div>
              <h3 className="font-bold text-slate-800 text-base">Graphique Analytique de Trésorerie</h3>
              <p className="text-xs text-slate-500 mt-0.5">
                {entities.filter(e => e.parent_id === activeEntityId).length > 0 
                  ? 'Comparatif consolidé des sous-entités de cette juridiction' 
                  : 'Évolution quotidienne du solde communautaire'}
              </p>
            </div>
          </div>

          <div className="h-[280px] w-full">
            {chartDataByEntity.length === 0 ? (
              <div className="h-full flex flex-col items-center justify-center text-slate-400">
                <p className="text-sm">Aucune transaction enregistrée pour alimenter le graphique</p>
              </div>
            ) : (
              <ResponsiveContainer width="100%" height="100%">
                {entities.filter(e => e.parent_id === activeEntityId).length > 0 ? (
                  <BarChart data={chartDataByEntity} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} />
                    <XAxis dataKey="name" tick={{ fontSize: 11 }} />
                    <YAxis tick={{ fontSize: 11 }} />
                    <Tooltip formatter={(value) => `$${value}`} />
                    <Legend wrapperStyle={{ fontSize: 12 }} />
                    <Bar dataKey="Offrandes" fill="#1B6B9E" radius={[4, 4, 0, 0]} />
                    <Bar dataKey="Dons" fill="#10B981" radius={[4, 4, 0, 0]} />
                    <Bar dataKey="Dépenses" fill="#F43F5E" radius={[4, 4, 0, 0]} />
                  </BarChart>
                ) : (
                  <AreaChart data={chartDataByEntity} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                    <defs>
                      <linearGradient id="colorOffrandes" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#1B6B9E" stopOpacity={0.8}/>
                        <stop offset="95%" stopColor="#1B6B9E" stopOpacity={0}/>
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} />
                    <XAxis dataKey="date" tick={{ fontSize: 11 }} />
                    <YAxis tick={{ fontSize: 11 }} />
                    <Tooltip formatter={(value) => `$${value}`} />
                    <Area type="monotone" dataKey="Offrandes" stroke="#1B6B9E" fillOpacity={1} fill="url(#colorOffrandes)" />
                  </AreaChart>
                )}
              </ResponsiveContainer>
            )}
          </div>
        </div>

        {/* Form and ledger action Column */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between pb-4 mb-4 border-b border-slate-100">
              <h3 className="font-bold text-slate-800 text-base">Actions de Caisse</h3>
              {activeEntity.level === 'COMMUNITY' || activeEntity.level === 'DISTRICT' ? (
                <button
                  onClick={() => setShowAddForm(!showAddForm)}
                  className="flex items-center gap-1.5 text-xs bg-brand-blue hover:bg-brand-blue/90 text-white font-semibold py-1.5 px-3 rounded-lg transition-colors cursor-pointer"
                >
                  <PlusCircle className="h-4 w-4" />
                  Saisir
                </button>
              ) : (
                <span className="text-[10px] text-slate-400 font-medium">Consolidation Seule</span>
              )}
            </div>

            <AnimatePresence mode="wait">
              {showAddForm ? (
                <motion.form
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  onSubmit={handleAddSubmit}
                  className="space-y-3.5 mb-4"
                >
                  <div className="grid grid-cols-3 gap-2">
                    {(['OFFERING', 'DONATION', 'EXPENSE'] as TransactionType[]).map((t) => (
                      <button
                        key={t}
                        type="button"
                        onClick={() => setNewTxType(t)}
                        className={`text-[10px] py-1.5 px-2 rounded-lg font-bold border transition-all ${
                          newTxType === t
                            ? t === 'OFFERING' ? 'bg-blue-50 border-blue-300 text-blue-700'
                              : t === 'DONATION' ? 'bg-emerald-50 border-emerald-300 text-emerald-700'
                              : 'bg-rose-50 border-rose-300 text-rose-700'
                            : 'bg-slate-50 border-slate-200 text-slate-500'
                        }`}
                      >
                        {t === 'OFFERING' ? 'Offrande' : t === 'DONATION' ? 'Don' : 'Dépense'}
                      </button>
                    ))}
                  </div>

                  <div>
                    <label className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block mb-1">Montant ($)</label>
                    <input
                      type="number"
                      required
                      min="1"
                      step="any"
                      value={newTxAmount}
                      onChange={(e) => setNewTxAmount(e.target.value)}
                      placeholder="Ex: 250"
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>

                  <div>
                    <label className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block mb-1">Date d'opération</label>
                    <input
                      type="date"
                      required
                      value={newTxDate}
                      onChange={(e) => setNewTxDate(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>

                  <div>
                    <label className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block mb-1">Libellé / Justificatif</label>
                    <input
                      type="text"
                      required
                      value={newTxDesc}
                      onChange={(e) => setNewTxDesc(e.target.value)}
                      placeholder="Ex: Offrandes service divin"
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>

                  <div className="flex gap-2">
                    <button
                      type="submit"
                      className="flex-1 text-xs bg-brand-blue hover:bg-brand-blue/90 text-white font-bold py-2 px-4 rounded-lg transition-colors cursor-pointer"
                    >
                      Enregistrer
                    </button>
                    <button
                      type="button"
                      onClick={() => setShowAddForm(false)}
                      className="text-xs bg-slate-100 hover:bg-slate-200 text-slate-600 font-bold py-2 px-4 rounded-lg transition-colors cursor-pointer"
                    >
                      Annuler
                    </button>
                  </div>
                </motion.form>
              ) : (
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className="bg-slate-50 rounded-lg p-4 border border-dashed border-slate-200 text-center text-slate-500"
                >
                  <p className="text-xs">Saisissez les offrandes, les dons spéciaux ou les charges directes de cette juridiction active.</p>
                  <p className="text-[10px] text-slate-400 mt-2">Le grand livre consolide récursivement les données.</p>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          <div className="border-t border-slate-100 pt-4 mt-4">
            <div className="flex items-center justify-between text-xs text-slate-500 font-semibold mb-2">
              <span>Niveau de juridiction</span>
              <span className="text-brand-blue uppercase">{activeEntity.level}</span>
            </div>
            <div className="text-[10px] text-slate-400 italic">
              *Toutes les devises de l'application sont centralisées en Dollars USD ($) pour les besoins d'agrégation d'Afrique Centrale.
            </div>
          </div>
        </div>
      </div>

      {/* Consolidation Ledger list */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5">
        <div className="pb-4 mb-4 border-b border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div>
            <h3 className="font-bold text-slate-800 text-base">Grand Livre des Opérations Consolidées</h3>
            <p className="text-xs text-slate-500 mt-0.5">Flux financiers agrégés depuis {activeEntity.name}</p>
          </div>
          <div className="flex items-center gap-2.5 self-start sm:self-auto">
            {consolidatedTransactions.length > 0 && (
              <button
                onClick={handleExportCSV}
                className="flex items-center gap-1.5 text-xs bg-slate-50 hover:bg-slate-100 text-slate-700 font-semibold py-1.5 px-3 rounded-lg border border-slate-200 transition-colors cursor-pointer"
                title="Exporter les transactions au format CSV pour Excel/comptabilité"
              >
                <Download className="h-4 w-4 text-slate-500" />
                Exporter en CSV
              </button>
            )}
            <span className="text-xs font-semibold text-brand-blue bg-brand-blue/5 border border-brand-blue/20 px-2.5 py-1.5 rounded-lg shrink-0">
              {consolidatedTransactions.length} transaction(s)
            </span>
          </div>
        </div>

        {consolidatedTransactions.length === 0 ? (
          <div className="text-center py-10 text-slate-400">
            <FileText className="h-10 w-10 mx-auto stroke-1" />
            <p className="text-xs mt-2">Aucune transaction répertoriée dans le scope actif.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-slate-100 text-slate-400 font-bold uppercase tracking-wider">
                  <th className="py-3 px-2">Date</th>
                  <th className="py-3 px-2">Juridiction Origine</th>
                  <th className="py-3 px-2">Type</th>
                  <th className="py-3 px-2">Détails / Description</th>
                  <th className="py-3 px-2 text-right">Montant</th>
                  <th className="py-3 px-2 text-center">Statut</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50 text-slate-700 font-medium">
                {consolidatedTransactions.map((tx) => (
                  <tr key={tx.id} className="hover:bg-slate-50/50 transition-colors">
                    <td className="py-3 px-2 flex items-center gap-1.5 text-slate-500 font-mono">
                      <Calendar className="h-3.5 w-3.5" />
                      {tx.date}
                    </td>
                    <td className="py-3 px-2">
                      <span className="text-slate-900 font-semibold">{getEntityName(tx.entityId)}</span>
                    </td>
                    <td className="py-3 px-2">
                      <span className={`text-[10px] px-2 py-0.5 font-bold rounded-full ${
                        tx.type === 'OFFERING' ? 'bg-blue-50 text-blue-700 border border-blue-200'
                          : tx.type === 'DONATION' ? 'bg-emerald-50 text-emerald-700 border border-emerald-200'
                          : 'bg-rose-50 text-rose-700 border border-rose-200'
                      }`}>
                        {tx.type === 'OFFERING' ? 'Offrande' : tx.type === 'DONATION' ? 'Don Spécial' : 'Dépense'}
                      </span>
                    </td>
                    <td className="py-3 px-2 text-slate-600">{tx.description}</td>
                    <td className={`py-3 px-2 text-right font-bold text-sm ${tx.type === 'EXPENSE' ? 'text-rose-600' : 'text-emerald-600'}`}>
                      {tx.type === 'EXPENSE' ? '-' : '+'}${tx.amount.toLocaleString()}
                    </td>
                    <td className="py-3 px-2 text-center">
                      <span className="inline-flex items-center gap-1 text-[10px] text-emerald-600 bg-emerald-50 border border-emerald-200 py-0.5 px-2 rounded-full font-bold">
                        <CheckCircle className="h-3 w-3" />
                        Validé (Consolidé)
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};
