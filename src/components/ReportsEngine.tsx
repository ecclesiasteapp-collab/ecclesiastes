import React, { useState, useMemo } from 'react';
import { EcclesiasticalEntity, MonthlyReport, ReportStatus } from '../types';
import { ClipboardList, PlusCircle, CheckCircle2, Send, Save, AlertCircle, Calendar, UserCheck, FileSignature, Download, FileText } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { useToast } from './Toast';

interface ReportsEngineProps {
  entities: EcclesiasticalEntity[];
  activeEntityId: string;
  reports: MonthlyReport[];
  onAddReport: (report: Omit<MonthlyReport, 'id'>) => void;
  onUpdateReportStatus: (id: string, status: ReportStatus, signedBy?: string) => void;
}

export const ReportsEngine: React.FC<ReportsEngineProps> = ({
  entities,
  activeEntityId,
  reports,
  onAddReport,
  onUpdateReportStatus
}) => {
  const { showToast } = useToast();
  const [showForm, setShowForm] = useState(false);
  const [month, setMonth] = useState('2026-06');
  const [attendance, setAttendance] = useState('');
  const [activeMembers, setActiveMembers] = useState('');
  const [servicesCount, setServicesCount] = useState('8');
  const [offeringsAmount, setOfferingsAmount] = useState('');
  const [remarks, setRemarks] = useState('');
  const [signatureName, setSignatureName] = useState('');

  // Find current entity
  const currentEntity = useMemo(() => {
    return entities.find(e => e.id === activeEntityId) || entities[0];
  }, [entities, activeEntityId]);

  // Filter reports of active entity
  const filteredReports = useMemo(() => {
    return reports.filter(r => r.entityId === activeEntityId);
  }, [reports, activeEntityId]);

  const handleCreate = (e: React.FormEvent, submitImmediately: boolean) => {
    e.preventDefault();
    const att = parseInt(attendance);
    const mems = parseInt(activeMembers);
    const sc = parseInt(servicesCount);
    const off = parseFloat(offeringsAmount);

    if (isNaN(att) || isNaN(mems) || isNaN(sc) || isNaN(off)) return;

    onAddReport({
      entityId: activeEntityId,
      month,
      status: submitImmediately ? 'SUBMITTED' : 'DRAFT',
      kpis: {
        attendance: att,
        activeMembers: mems,
        servicesCount: sc,
        offeringsAmount: off
      },
      remarks: remarks.trim(),
      signedBy: signatureName ? `${signatureName} (${currentEntity.responsible || 'Responsable'})` : undefined,
      dateSigned: signatureName ? new Date().toISOString().split('T')[0] : undefined
    });

    if (submitImmediately) {
      showToast(`Le rapport pour le mois ${month} a été soumis avec succès.`, 'success');
    } else {
      showToast(`Le rapport pour le mois ${month} a été enregistré en tant que brouillon.`, 'info');
    }

    // Reset Form
    setAttendance('');
    setActiveMembers('');
    setServicesCount('8');
    setOfferingsAmount('');
    setRemarks('');
    setSignatureName('');
    setShowForm(false);
  };

  const handleUpdateStatus = (id: string, status: ReportStatus, reportMonth: string, signedBy?: string) => {
    onUpdateReportStatus(id, status, signedBy);
    if (status === 'SUBMITTED') {
      showToast(`Le rapport du mois ${reportMonth} a été soumis pour validation.`, 'success');
    } else if (status === 'VALIDATED') {
      showToast(`Le rapport du mois ${reportMonth} a été validé par le Clergé.`, 'success');
    }
  };

  const handleExportSingleCSV = (report: MonthlyReport) => {
    const headers = ['Indicateur', 'Valeur', 'Description'];
    const rows = [
      ['Mois / Periode', report.month, 'Mois concerne'],
      ['Entite Ecclesiastique', currentEntity.name, `${currentEntity.level} - Chef-lieu: ${currentEntity.responsible || 'Non specifie'}`],
      ['Presences Cumulees', report.kpis.attendance.toString(), 'Assiduite totale sur le mois'],
      ['Membres Actifs (Fideles)', report.kpis.activeMembers.toString(), 'Fideles actifs enregistres'],
      ['Cultes Celebres (Services)', report.kpis.servicesCount.toString(), 'Nombre de services divins celebres'],
      ['Offrandes Declarees', `$${report.kpis.offeringsAmount.toLocaleString()}`, 'Total des offrandes de la caisse locale'],
      ['Statut du Rapport', report.status === 'VALIDATED' ? 'Valide par le Clerge' : report.status === 'SUBMITTED' ? 'Soumis' : 'Brouillon', 'Etat d\'approbation'],
      ['Remarques & Faits Saillants', `"${(report.remarks || '').replace(/"/g, '""')}"`, 'Commentaires pastoraux'],
      ['Signataire', report.signedBy || 'Non signe', 'Signature numerique officielle'],
      ['Date de Signature', report.dateSigned || 'Non signe', 'Date de la signature']
    ];

    const csvContent = [
      headers.join(','),
      ...rows.map(row => row.join(','))
    ].join('\n');

    const blob = new Blob([new Uint8Array([0xEF, 0xBB, 0xBF]), csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    const safeMonth = report.month.replace('-', '_');
    const safeEntityName = currentEntity.name.toLowerCase().replace(/[^a-z0-9]/g, '_');
    
    link.setAttribute('href', url);
    link.setAttribute('download', `rapport_${safeEntityName}_${safeMonth}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    showToast(`Rapport CSV pour ${report.month} exporte avec succes.`, 'success');
  };

  const handleExportPDF = (report: MonthlyReport) => {
    const iframe = document.createElement('iframe');
    iframe.style.position = 'fixed';
    iframe.style.right = '0';
    iframe.style.bottom = '0';
    iframe.style.width = '0';
    iframe.style.height = '0';
    iframe.style.border = '0';
    document.body.appendChild(iframe);

    const doc = iframe.contentDocument || iframe.contentWindow?.document;
    if (!doc) {
      showToast("Impossible d'initialiser le moteur d'impression PDF.", "error");
      return;
    }

    const statusLabel = {
      DRAFT: 'BROUILLON (NON SOUMIS)',
      SUBMITTED: 'SOUMIS (EN ATTENTE DE VALIDATION)',
      VALIDATED: 'VALIDE OFFICIELLEMENT'
    }[report.status];

    const statusColor = {
      DRAFT: '#64748B',
      SUBMITTED: '#1D4ED8',
      VALIDATED: '#047857'
    }[report.status];

    const htmlContent = `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>Rapport Mensuel - ${report.month} - ${currentEntity.name}</title>
          <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
            body {
              font-family: 'Inter', sans-serif;
              color: #1E293B;
              margin: 0;
              padding: 40px;
              background-color: #ffffff;
              line-height: 1.5;
            }
            .header-container {
              display: flex;
              align-items: center;
              justify-content: space-between;
              border-bottom: 3px solid #1B6B9E;
              padding-bottom: 20px;
              margin-bottom: 30px;
            }
            .logo-placeholder {
              width: 60px;
              height: 60px;
              background-color: #1B6B9E;
              border-radius: 50%;
              display: flex;
              align-items: center;
              justify-content: center;
              color: white;
              font-weight: 800;
              font-size: 20px;
            }
            .church-title {
              text-align: right;
            }
            .church-title h1 {
              font-size: 22px;
              font-weight: 800;
              color: #1B6B9E;
              margin: 0;
              text-transform: uppercase;
              letter-spacing: 0.5px;
            }
            .church-title p {
              font-size: 11px;
              color: #64748B;
              font-weight: 600;
              margin: 4px 0 0 0;
              text-transform: uppercase;
              letter-spacing: 1px;
            }
            .report-title-box {
              text-align: center;
              margin-bottom: 35px;
            }
            .report-title-box h2 {
              font-size: 18px;
              font-weight: 700;
              color: #0F172A;
              margin: 0;
              text-transform: uppercase;
            }
            .report-title-box .badge {
              display: inline-block;
              margin-top: 10px;
              padding: 5px 14px;
              font-size: 11px;
              font-weight: 700;
              color: white;
              border-radius: 9999px;
              text-transform: uppercase;
              letter-spacing: 0.5px;
            }
            .section-title {
              font-size: 13px;
              font-weight: 700;
              text-transform: uppercase;
              color: #1B6B9E;
              border-bottom: 1px solid #E2E8F0;
              padding-bottom: 6px;
              margin-bottom: 15px;
              margin-top: 25px;
              letter-spacing: 0.5px;
            }
            .info-grid {
              display: grid;
              grid-template-cols: repeat(2, 1fr);
              gap: 15px;
              margin-bottom: 25px;
            }
            .info-item {
              font-size: 12px;
            }
            .info-item span.label {
              font-weight: 600;
              color: #64748B;
              display: block;
              font-size: 10px;
              text-transform: uppercase;
              margin-bottom: 2px;
            }
            .info-item span.value {
              font-weight: 700;
              color: #1E293B;
              font-size: 13px;
            }
            .kpis-table {
              width: 100%;
              border-collapse: collapse;
              margin-bottom: 30px;
            }
            .kpis-table th {
              background-color: #1B6B9E;
              color: white;
              font-weight: 700;
              text-transform: uppercase;
              font-size: 11px;
              text-align: left;
              padding: 12px 16px;
              border: 1px solid #1B6B9E;
            }
            .kpis-table td {
              padding: 12px 16px;
              font-size: 12px;
              border: 1px solid #E2E8F0;
            }
            .kpis-table tr:nth-child(even) {
              background-color: #F8FAFC;
            }
            .kpis-table .kpi-val {
              font-weight: 700;
              font-size: 13px;
              color: #0F172A;
            }
            .remarks-box {
              background-color: #F8FAFC;
              border: 1px solid #E2E8F0;
              border-radius: 8px;
              padding: 15px;
              font-size: 12px;
              line-height: 1.6;
              color: #334155;
              min-height: 80px;
              margin-bottom: 40px;
            }
            .signature-section {
              display: grid;
              grid-template-cols: repeat(2, 1fr);
              gap: 40px;
              margin-top: 50px;
              page-break-inside: avoid;
            }
            .signature-card {
              border: 1px dashed #CBD5E1;
              border-radius: 8px;
              padding: 20px;
              text-align: center;
              min-height: 140px;
              display: flex;
              flex-direction: column;
              justify-content: space-between;
            }
            .signature-title {
              font-size: 11px;
              font-weight: 700;
              text-transform: uppercase;
              color: #64748B;
              margin-bottom: 10px;
            }
            .signature-name {
              font-size: 13px;
              font-weight: 700;
              color: #0F172A;
              margin-top: auto;
            }
            .signature-date {
              font-size: 10px;
              color: #94A3B8;
              margin-top: 4px;
            }
            .stamp-box {
              border: 1px dashed #1B6B9E;
              border-radius: 8px;
              padding: 20px;
              text-align: center;
              min-height: 140px;
              color: #1B6B9E;
              font-size: 11px;
              font-weight: 700;
              text-transform: uppercase;
              display: flex;
              align-items: center;
              justify-content: center;
            }
            .footer-note {
              margin-top: 60px;
              text-align: center;
              font-size: 10px;
              color: #94A3B8;
              border-top: 1px solid #F1F5F9;
              padding-top: 15px;
              text-transform: uppercase;
              letter-spacing: 0.5px;
            }
            @media print {
              body {
                padding: 20px;
              }
              button {
                display: none;
              }
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-placeholder">ENA</div>
            <div class="church-title">
              <h1>Eglise Neo-Apostolique</h1>
              <p>Administration Ecclesiastique locale</p>
            </div>
          </div>

          <div class="report-title-box">
            <h2>Rapport d'Activite Officiel</h2>
            <div class="badge" style="background-color: ${statusColor};">${statusLabel}</div>
          </div>

          <div class="section-title">Informations de la Juridiction</div>
          <div class="info-grid">
            <div class="info-item">
              <span class="label">Periode d'activite</span>
              <span class="value">${report.month}</span>
            </div>
            <div class="info-item">
              <span class="label">Juridiction Ecclesiastique</span>
              <span class="value">${currentEntity.name} (${currentEntity.level})</span>
            </div>
            <div class="info-item">
              <span class="label">Ministere Responsable</span>
              <span class="value">${currentEntity.responsible || 'Non designe'}</span>
            </div>
            <div class="info-item">
              <span class="label">ID Unique du Document</span>
              <span class="value" style="font-family: monospace; font-size: 11px;">doc_${report.id}</span>
            </div>
          </div>

          <div class="section-title">Indicateurs de Performance Evangelique & Financiere</div>
          <table class="kpis-table">
            <thead>
              <tr>
                <th style="width: 50%;">Indicateur</th>
                <th style="width: 25%; text-align: right;">Valeur Declaree</th>
                <th style="width: 25%;">Unite / Description</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><strong>Presences cumulees</strong></td>
                <td style="text-align: right;" class="kpi-val">${report.kpis.attendance.toLocaleString()}</td>
                <td>Personnes (Assiduite globale)</td>
              </tr>
              <tr>
                <td><strong>Fideles Actifs (Inscrits)</strong></td>
                <td style="text-align: right;" class="kpi-val">${report.kpis.activeMembers.toLocaleString()}</td>
                <td>Membres enregistres</td>
              </tr>
              <tr>
                <td><strong>Cultes Celebres (Services Divins)</strong></td>
                <td style="text-align: right;" class="kpi-val">${report.kpis.servicesCount}</td>
                <td>Services religieux</td>
              </tr>
              <tr>
                <td><strong>Offrandes Declarees</strong></td>
                <td style="text-align: right; color: #047857;" class="kpi-val">$${report.kpis.offeringsAmount.toLocaleString()}</td>
                <td>USD (Caisse de l'Eglise)</td>
              </tr>
            </tbody>
          </table>

          <div class="section-title">Faits Saillants, Progres & Observations</div>
          <div class="remarks-box">
            ${report.remarks ? report.remarks.replace(/\n/g, '<br>') : 'Aucun fait saillant ou remarque a signaler pour cette periode.'}
          </div>

          <div class="signature-section">
            <div class="signature-card">
              <div class="signature-title">Signature Numerique Officielle</div>
              ${report.signedBy ? `
                <div style="font-family: 'Courier New', monospace; font-size: 12px; font-weight: 700; border: 1px solid #E2E8F0; padding: 6px; background-color: #F8FAFC; border-radius: 4px; margin-bottom: 10px;">
                  [SIGNATURE NUMERIQUE ACCEPTEE]
                </div>
                <div class="signature-name">${report.signedBy}</div>
                <div class="signature-date">Certifie le ${report.dateSigned || report.month}</div>
              ` : `
                <div style="color: #94A3B8; font-size: 12px; font-style: italic; margin-top: auto; margin-bottom: auto;">
                  En attente de signature numerique
                </div>
              `}
            </div>
            <div class="stamp-box">
              Emplacement Cachet de la Communaute
            </div>
          </div>

          <div class="footer-note">
            Genere automatiquement par Ecclesiaste Web - Systeme de Gestion Pastorale & Administrations de l'Eglise
          </div>
        </body>
      </html>
    `;

    doc.open();
    doc.write(htmlContent);
    doc.close();

    setTimeout(() => {
      iframe.contentWindow?.focus();
      iframe.contentWindow?.print();
      setTimeout(() => {
        document.body.removeChild(iframe);
      }, 5000);
    }, 500);

    showToast(`Rapport PDF officiel de ${report.month} genere pour impression.`, 'success');
  };

  const getStatusBadge = (status: ReportStatus) => {
    switch (status) {
      case 'DRAFT':
        return <span className="text-xs font-bold px-2.5 py-1 rounded-full bg-slate-100 text-slate-600 border border-slate-200">Brouillon</span>;
      case 'SUBMITTED':
        return <span className="text-xs font-bold px-2.5 py-1 rounded-full bg-blue-100 text-blue-800 border border-blue-200">Soumis</span>;
      case 'VALIDATED':
        return <span className="text-xs font-bold px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-800 border border-emerald-200">Validé</span>;
    }
  };

  return (
    <div id="reports-engine" className="space-y-6">
      {/* Upper info card */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h3 className="font-bold text-slate-800 text-base">Rapports d'Activité Mensuels</h3>
          <p className="text-xs text-slate-500 mt-1">
            Gérez et soumettez les données pastorales, administratives et comptables pour <strong className="text-brand-blue">{currentEntity.name}</strong>.
          </p>
        </div>
        
        {currentEntity.level === 'COMMUNITY' || currentEntity.level === 'DISTRICT' ? (
          <button
            onClick={() => setShowForm(!showForm)}
            className="flex items-center gap-1.5 text-xs bg-brand-blue hover:bg-brand-blue/90 text-white font-bold py-2.5 px-4 rounded-lg transition-all cursor-pointer"
          >
            <PlusCircle className="h-4 w-4" />
            Nouveau Rapport
          </button>
        ) : (
          <div className="text-xs text-amber-600 font-semibold bg-amber-50 border border-amber-200 py-2 px-3 rounded-lg flex items-center gap-1.5">
            <AlertCircle className="h-4 w-4 shrink-0" />
            Les rapports s'établissent au niveau District ou Communauté.
          </div>
        )}
      </div>

      <AnimatePresence mode="wait">
        {showForm && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="bg-white rounded-xl shadow-sm border border-slate-100 p-6"
          >
            <h4 className="font-bold text-slate-800 text-base border-b border-slate-100 pb-3 mb-4">Éditer un Rapport Mensuel</h4>
            
            <form onSubmit={(e) => handleCreate(e, false)} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Période Mensuelle</label>
                  <select
                    value={month}
                    onChange={(e) => setMonth(e.target.value)}
                    className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                  >
                    <option value="2026-05">Mai 2026</option>
                    <option value="2026-06">Juin 2026</option>
                    <option value="2026-07">Juillet 2026</option>
                  </select>
                </div>

                <div>
                  <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Fidèles Actifs</label>
                  <input
                    type="number"
                    required
                    value={activeMembers}
                    onChange={(e) => setActiveMembers(e.target.value)}
                    placeholder="Fidèles enregistrés"
                    className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                  />
                </div>

                <div>
                  <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Nombre de Cultes</label>
                  <input
                    type="number"
                    required
                    value={servicesCount}
                    onChange={(e) => setServicesCount(e.target.value)}
                    placeholder="Cultes célébrés"
                    className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Présence Cumulée (Assiduité)</label>
                  <input
                    type="number"
                    required
                    value={attendance}
                    onChange={(e) => setAttendance(e.target.value)}
                    placeholder="Total cumulé des cultes du mois"
                    className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                  />
                </div>

                <div>
                  <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Offrandes Récoltées ($)</label>
                  <input
                    type="number"
                    required
                    value={offeringsAmount}
                    onChange={(e) => setOfferingsAmount(e.target.value)}
                    placeholder="Trésorerie d'offrandes récoltée"
                    className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                  />
                </div>
              </div>

              <div>
                <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Remarques, Besoins, Réalisations</label>
                <textarea
                  value={remarks}
                  onChange={(e) => setRemarks(e.target.value)}
                  placeholder="Écrivez les réalisations marquantes (baptêmes, travaux, séminaires) ou les besoins logistiques majeurs..."
                  rows={3}
                  className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                />
              </div>

              <div className="border-t border-slate-100 pt-4 flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div className="flex items-center gap-2.5 max-w-md">
                  <FileSignature className="h-5 w-5 text-slate-400 shrink-0" />
                  <input
                    type="text"
                    required
                    value={signatureName}
                    onChange={(e) => setSignatureName(e.target.value)}
                    placeholder="Nom du signataire (ex: Prêtre Kikaba)"
                    className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                  />
                </div>

                <div className="flex gap-2.5">
                  <button
                    type="submit"
                    className="flex items-center gap-1 text-xs bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold py-2.5 px-4 rounded-lg transition-colors cursor-pointer"
                  >
                    <Save className="h-4 w-4" />
                    Enregistrer Brouillon
                  </button>
                  <button
                    type="button"
                    onClick={(e) => handleCreate(e, true)}
                    className="flex items-center gap-1 text-xs bg-brand-blue hover:bg-brand-blue/90 text-white font-bold py-2.5 px-4 rounded-lg transition-colors cursor-pointer"
                  >
                    <Send className="h-4 w-4" />
                    Soumettre Directement
                  </button>
                  <button
                    type="button"
                    onClick={() => setShowForm(false)}
                    className="text-xs bg-slate-50 hover:bg-slate-100 text-slate-600 font-bold py-2.5 px-4 rounded-lg transition-colors cursor-pointer"
                  >
                    Annuler
                  </button>
                </div>
              </div>
            </form>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Reports Listing */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5">
        <h4 className="font-bold text-slate-800 text-base pb-3 mb-4 border-b border-slate-100">Historique des Rapports</h4>
        
        {filteredReports.length === 0 ? (
          <div className="text-center py-12 text-slate-400">
            <ClipboardList className="h-12 w-12 mx-auto stroke-1" />
            <p className="text-xs mt-3">Aucun rapport enregistré pour {currentEntity.name}.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {filteredReports.map((report) => (
              <div key={report.id} className="border border-slate-100 rounded-xl p-5 hover:border-slate-200 hover:shadow-sm transition-all bg-slate-50/20">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-100 pb-3 mb-4">
                  <div className="flex items-center gap-2">
                    <Calendar className="h-4 w-4 text-slate-400" />
                    <span className="font-bold text-slate-800 text-sm">{report.month}</span>
                    <span className="text-xs text-slate-400">|</span>
                    <span className="text-xs text-slate-500 font-semibold uppercase">{currentEntity.name}</span>
                  </div>
                  <div className="flex items-center gap-2 flex-wrap">
                    {getStatusBadge(report.status)}
                    
                    {report.status === 'DRAFT' && (
                      <button
                        onClick={() => handleUpdateStatus(report.id, 'SUBMITTED', report.month)}
                        className="text-xs font-bold bg-blue-50 hover:bg-blue-100 text-blue-700 py-1 px-3 border border-blue-200 rounded-lg transition-all flex items-center gap-1 cursor-pointer"
                      >
                        <Send className="h-3.5 w-3.5" />
                        Soumettre
                      </button>
                    )}
                    
                    {report.status === 'SUBMITTED' && (
                      <button
                        onClick={() => handleUpdateStatus(report.id, 'VALIDATED', report.month, currentEntity.responsible || 'Validateur')}
                        className="text-xs font-bold bg-emerald-50 hover:bg-emerald-100 text-emerald-700 py-1 px-3 border border-emerald-200 rounded-lg transition-all flex items-center gap-1 cursor-pointer"
                      >
                        <CheckCircle2 className="h-3.5 w-3.5" />
                        Valider (Clergé)
                      </button>
                    )}

                    <button
                      onClick={() => handleExportSingleCSV(report)}
                      className="text-xs font-bold bg-slate-100 hover:bg-slate-200 text-slate-700 py-1 px-2.5 border border-slate-200 rounded-lg transition-all flex items-center gap-1 cursor-pointer"
                      title="Exporter les données du rapport au format CSV"
                    >
                      <Download className="h-3.5 w-3.5 text-slate-500" />
                      <span>CSV</span>
                    </button>

                    <button
                      onClick={() => handleExportPDF(report)}
                      className="text-xs font-bold bg-brand-blue/5 hover:bg-brand-blue/10 text-brand-blue py-1 px-2.5 border border-brand-blue/20 rounded-lg transition-all flex items-center gap-1 cursor-pointer"
                      title="Générer un PDF officiel récapitulatif pour impression / signature"
                    >
                      <FileText className="h-3.5 w-3.5 text-brand-blue" />
                      <span>PDF Officiel</span>
                    </button>
                  </div>
                </div>

                {/* KPIs grid */}
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
                  <div className="bg-white rounded-lg p-3 border border-slate-100">
                    <p className="text-[10px] text-slate-400 font-bold uppercase">Présences cumulées</p>
                    <p className="text-base font-bold text-slate-800 mt-1">{report.kpis.attendance.toLocaleString()}</p>
                    <p className="text-[9px] text-slate-400 mt-0.5">Assiduité totale</p>
                  </div>

                  <div className="bg-white rounded-lg p-3 border border-slate-100">
                    <p className="text-[10px] text-slate-400 font-bold uppercase">Membres Actifs</p>
                    <p className="text-base font-bold text-slate-800 mt-1">{report.kpis.activeMembers.toLocaleString()}</p>
                    <p className="text-[9px] text-slate-400 mt-0.5">Fidèles inscrits</p>
                  </div>

                  <div className="bg-white rounded-lg p-3 border border-slate-100">
                    <p className="text-[10px] text-slate-400 font-bold uppercase">Cultes Célébrés</p>
                    <p className="text-base font-bold text-slate-800 mt-1">{report.kpis.servicesCount}</p>
                    <p className="text-[9px] text-slate-400 mt-0.5">Services divins</p>
                  </div>

                  <div className="bg-white rounded-lg p-3 border border-slate-100">
                    <p className="text-[10px] text-slate-400 font-bold uppercase">Offrandes Déclarées</p>
                    <p className="text-base font-bold text-emerald-600 mt-1">${report.kpis.offeringsAmount.toLocaleString()}</p>
                    <p className="text-[9px] text-slate-400 mt-0.5">Caisse locale</p>
                  </div>
                </div>

                {/* Remarks and signature */}
                <div className="space-y-2.5">
                  {report.remarks && (
                    <div className="text-xs text-slate-600 bg-white p-3 rounded-lg border border-slate-100 leading-relaxed">
                      <strong className="text-slate-800 block mb-0.5">Faits saillants & Remarques :</strong>
                      {report.remarks}
                    </div>
                  )}

                  {report.signedBy && (
                    <div className="flex items-center gap-1.5 text-xs text-slate-500 font-medium">
                      <UserCheck className="h-4 w-4 text-emerald-500" />
                      Signé numériquement par : <span className="font-bold text-slate-700">{report.signedBy}</span>
                      {report.dateSigned && <span className="text-[10px] text-slate-400">le {report.dateSigned}</span>}
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
