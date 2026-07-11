import React, { useState } from 'react';
import { AppSettings } from '../types';
import { Settings, Volume2, Shield, RotateCcw, Sliders, Check } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { useToast } from './Toast';

interface SettingsPageProps {
  settings: AppSettings;
  onSettingsChange: (settings: AppSettings) => void;
}

export const SettingsPage: React.FC<SettingsPageProps> = ({
  settings,
  onSettingsChange
}) => {
  const { showToast } = useToast();
  const [copiedBackup, setCopiedBackup] = useState(false);
  const [successMsg, setSuccessMsg] = useState(false);

  const updateSetting = <K extends keyof AppSettings>(key: K, value: AppSettings[K]) => {
    const updated = { ...settings, [key]: value };
    onSettingsChange(updated);
    
    // Label map for clearer toast notifications in French
    const labels: Record<string, string> = {
      language: 'Langue de l\'interface mise à jour',
      theme: 'Thème visuel mis à jour',
      accessibilityScale: 'Taille de police mise à jour',
      contrastHigh: value ? 'Contraste élevé activé' : 'Contraste élevé désactivé',
      notificationsPush: value ? 'Alertes pastorales push activées' : 'Alertes pastorales push désactivées',
      notificationsEmail: value ? 'Rapports par email activés' : 'Rapports par email désactivés',
      securityBiometrics: value ? 'Verrouillage biométrique activé' : 'Verrouillage biométrique désactivé',
      backupAuto: value ? 'Sauvegarde automatique cloud activée' : 'Sauvegarde automatique cloud désactivée'
    };
    
    const toastLabel = labels[key as string] || 'Paramètre mis à jour';
    showToast(toastLabel, 'success');
    
    setSuccessMsg(true);
    setTimeout(() => setSuccessMsg(false), 2000);
  };

  const triggerManualBackup = () => {
    // Generate manual backup string
    const backupData = {
      timestamp: new Date().toISOString(),
      activeSettings: settings,
      device: "Ecclesiaste Web (AIS)"
    };
    navigator.clipboard.writeText(JSON.stringify(backupData, null, 2));
    
    showToast('Sauvegarde JSON copiée dans le presse-papiers avec succès.', 'info');
    
    setCopiedBackup(true);
    setTimeout(() => setCopiedBackup(false), 2000);
  };

  return (
    <div id="settings-page-enhanced" className="space-y-6">
      {/* Upper header */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="p-2.5 bg-brand-blue/10 text-brand-blue rounded-lg">
            <Settings className="h-6 w-6" />
          </div>
          <div>
            <h3 className="font-bold text-slate-800 text-base">Paramètres Généraux</h3>
            <p className="text-xs text-slate-500 mt-1">
              Configurez l'internationalisation (Lingala / Français), l'accessibilité visuelle, et la sécurité biométrique.
            </p>
          </div>
        </div>

        <AnimatePresence>
          {successMsg && (
            <motion.span
              initial={{ opacity: 0, x: 10 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 10 }}
              className="text-xs font-semibold text-emerald-600 bg-emerald-50 border border-emerald-200 py-2 px-3 rounded-lg flex items-center gap-1.5"
            >
              <Check className="h-4 w-4" />
              Modifications sauvegardées !
            </motion.span>
          )}
        </AnimatePresence>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left column: Quick Preferences */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 space-y-4">
          <h4 className="font-bold text-slate-800 text-sm border-b border-slate-50 pb-2 flex items-center gap-1.5">
            <Sliders className="h-4 w-4 text-brand-blue" />
            Internationalisation & Thème
          </h4>

          {/* Language Selector */}
          <div>
            <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Langue de l'interface</label>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => updateSetting('language', 'fr')}
                className={`py-2 px-3 text-xs font-bold rounded-lg border transition-all ${
                  settings.language === 'fr'
                    ? 'bg-brand-blue text-white border-brand-blue'
                    : 'bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100'
                }`}
              >
                Français (FR)
              </button>
              <button
                type="button"
                onClick={() => updateSetting('language', 'ln')}
                className={`py-2 px-3 text-xs font-bold rounded-lg border transition-all ${
                  settings.language === 'ln'
                    ? 'bg-brand-blue text-white border-brand-blue'
                    : 'bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100'
                }`}
              >
                Lingala (LN)
              </button>
            </div>
          </div>

          {/* Theme Selector */}
          <div>
            <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Thème visuel</label>
            <div className="grid grid-cols-3 gap-1.5">
              <button
                type="button"
                onClick={() => updateSetting('theme', 'light')}
                className={`py-2 px-1 text-[10px] font-bold rounded-lg border transition-all text-center ${
                  settings.theme === 'light'
                    ? 'border-brand-blue text-brand-blue bg-brand-blue/5 font-extrabold'
                    : 'bg-slate-50 text-slate-500 border-slate-200 hover:bg-slate-100'
                }`}
              >
                Bleu Institutionnel
              </button>
              <button
                type="button"
                onClick={() => updateSetting('theme', 'dark')}
                className={`py-2 px-1 text-[10px] font-bold rounded-lg border transition-all text-center ${
                  settings.theme === 'dark'
                    ? 'border-brand-blue text-brand-blue bg-brand-blue/5 font-extrabold'
                    : 'bg-slate-50 text-slate-500 border-slate-200 hover:bg-slate-100'
                }`}
              >
                Sombre (Twilight)
              </button>
              <button
                type="button"
                onClick={() => updateSetting('theme', 'system')}
                className={`py-2 px-1 text-[10px] font-bold rounded-lg border transition-all text-center ${
                  settings.theme === 'system'
                    ? 'border-brand-blue text-brand-blue bg-brand-blue/5 font-extrabold'
                    : 'bg-slate-50 text-slate-500 border-slate-200 hover:bg-slate-100'
                }`}
              >
                Système (Auto)
              </button>
            </div>
          </div>

          {/* Compact Info note */}
          <div className="p-3 bg-blue-50/50 rounded-lg text-[11px] text-slate-500 leading-relaxed border border-blue-100">
            Le Lingala (langue de la RDC) est pré-configuré pour l'affichage de l'annuaire de culte et les chants d'Ecodim.
          </div>
        </div>

        {/* Center column: Accessibility & Alerts */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 space-y-4">
          <h4 className="font-bold text-slate-800 text-sm border-b border-slate-50 pb-2 flex items-center gap-1.5">
            <Volume2 className="h-4 w-4 text-emerald-500" />
            Accessibilité & Audio
          </h4>

          {/* Font Scale selector */}
          <div>
            <label className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-1.5">Taille de police (Zoom)</label>
            <div className="grid grid-cols-4 gap-1.5">
              {(['small', 'medium', 'large', 'xlarge'] as const).map((sz) => (
                <button
                  key={sz}
                  type="button"
                  onClick={() => updateSetting('accessibilityScale', sz)}
                  className={`py-2 text-[10px] font-bold rounded-lg border uppercase tracking-wider transition-all ${
                    settings.accessibilityScale === sz
                      ? 'bg-slate-800 text-white border-slate-800'
                      : 'bg-slate-50 text-slate-500 border-slate-200 hover:bg-slate-100'
                  }`}
                >
                  {sz === 'small' ? 'Fin' : sz === 'medium' ? 'Std' : sz === 'large' ? 'Grand' : 'Max'}
                </button>
              ))}
            </div>
          </div>

          {/* Contrast and alert Toggles */}
          <div className="space-y-3.5">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs font-semibold text-slate-700">Contraste Élevé</p>
                <p className="text-[10px] text-slate-400">Pour une meilleure lecture liturgique</p>
              </div>
              <input
                type="checkbox"
                checked={settings.contrastHigh}
                onChange={(e) => updateSetting('contrastHigh', e.target.checked)}
                className="h-4 w-4 text-brand-blue border-slate-300 rounded focus:ring-brand-blue"
              />
            </div>

            <div className="flex items-center justify-between border-t border-slate-50 pt-3">
              <div>
                <p className="text-xs font-semibold text-slate-700">Alertes Pastorales Push</p>
                <p className="text-[10px] text-slate-400">Notifications de visites de l'Apôtre</p>
              </div>
              <input
                type="checkbox"
                checked={settings.notificationsPush}
                onChange={(e) => updateSetting('notificationsPush', e.target.checked)}
                className="h-4 w-4 text-brand-blue border-slate-300 rounded focus:ring-brand-blue"
              />
            </div>

            <div className="flex items-center justify-between border-t border-slate-50 pt-3">
              <div>
                <p className="text-xs font-semibold text-slate-700">Rapports par Email</p>
                <p className="text-[10px] text-slate-400">Envoi de rapports PDF consolidés</p>
              </div>
              <input
                type="checkbox"
                checked={settings.notificationsEmail}
                onChange={(e) => updateSetting('notificationsEmail', e.target.checked)}
                className="h-4 w-4 text-brand-blue border-slate-300 rounded focus:ring-brand-blue"
              />
            </div>
          </div>
        </div>

        {/* Right column: Security & Backup */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 space-y-4">
          <h4 className="font-bold text-slate-800 text-sm border-b border-slate-50 pb-2 flex items-center gap-1.5">
            <Shield className="h-4 w-4 text-rose-500" />
            Sécurité & Sauvegardes NoSQL
          </h4>

          {/* Biometrics Simulation */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-slate-700">Verrouillage Biométrique (Mobile)</p>
              <p className="text-[10px] text-slate-400">Empreinte digitale pour ouvrir l'app</p>
            </div>
            <input
              type="checkbox"
              checked={settings.securityBiometrics}
              onChange={(e) => updateSetting('securityBiometrics', e.target.checked)}
              className="h-4 w-4 text-brand-blue border-slate-300 rounded focus:ring-brand-blue"
            />
          </div>

          {/* Auto Backup Toggle */}
          <div className="flex items-center justify-between border-t border-slate-50 pt-3">
            <div>
              <p className="text-xs font-semibold text-slate-700">Sauvegarde Cloud Automatique</p>
              <p className="text-[10px] text-slate-400">Sauvegarde automatique toutes les 24h</p>
            </div>
            <input
              type="checkbox"
              checked={settings.backupAuto}
              onChange={(e) => updateSetting('backupAuto', e.target.checked)}
              className="h-4 w-4 text-brand-blue border-slate-300 rounded focus:ring-brand-blue"
            />
          </div>

          {/* Manual Backup trigger Button */}
          <div className="border-t border-slate-50 pt-4 mt-2">
            <button
              type="button"
              onClick={triggerManualBackup}
              className="w-full text-xs bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200 font-bold py-2.5 px-4 rounded-lg transition-colors cursor-pointer flex items-center justify-center gap-2"
            >
              {copiedBackup ? (
                <>
                  <Check className="h-4 w-4 text-emerald-500" />
                  <span className="text-emerald-600">JSON copié dans le presse-papier !</span>
                </>
              ) : (
                <>
                  <RotateCcw className="h-4 w-4 text-slate-500" />
                  Générer une Sauvegarde Manuelle
                </>
              )}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
