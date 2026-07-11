import React, { useState } from 'react';
import { Landmark, ShieldAlert, Info } from 'lucide-react';
import { motion } from 'motion/react';

interface GithubLoginProps {
  onLoginSuccess: (userData: {
    username: string;
    role: string;
    ministry: string;
    level: string;
    entityId: string;
  }) => void;
}

export const GithubLogin: React.FC<GithubLoginProps> = ({ onLoginSuccess }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [level, setLevel] = useState('CHAMP');
  const [role, setRole] = useState('Responsable');
  const [ministry, setMinistry] = useState('Apôtre');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [showHelp, setShowHelp] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    // Simple robust validation
    if (!username.trim()) {
      setError("L'identifiant ou l'adresse e-mail ne peut pas être vide.");
      return;
    }
    if (password.length < 4) {
      setError("Le mot de passe doit contenir au moins 4 caractères.");
      return;
    }

    setLoading(true);

    // Simulation of GitHub-style high-speed authentication loading state
    setTimeout(() => {
      setLoading(false);
      
      // Determine corresponding entityId based on selected level
      let defaultEntityId = 'champ_kso'; // Default
      if (level === 'INTERNATIONAL') defaultEntityId = 'international_root';
      else if (level === 'TERRITORIAL') defaultEntityId = 'terr_rdc_ouest';
      else if (level === 'REGION') defaultEntityId = 'reg_ouest';
      else if (level === 'CHAMP') defaultEntityId = 'champ_kso';
      else if (level === 'DISTRICT') defaultEntityId = 'KSO_01';
      else if (level === 'COMMUNITY') defaultEntityId = 'comm_bethel';

      // Format custom display name based on username input
      let displayName = username.split('@')[0];
      displayName = displayName
        .split(/[._-]/)
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');

      onLoginSuccess({
        username: displayName,
        role: role,
        ministry: ministry,
        level: level,
        entityId: defaultEntityId
      });
    }, 1200);
  };

  return (
    <div className="min-h-screen flex flex-col justify-between bg-[#f6f8fa] dark:bg-[#0d1117] font-sans transition-colors duration-200 github-login-container">
      
      {/* Top micro spacer to push everything down naturally */}
      <div />

      {/* Centered GitHub Login Box container */}
      <div className="w-full max-w-[340px] mx-auto px-4 py-8">
        
        {/* GitHub Header Emblem */}
        <div className="flex flex-col items-center mb-6">
          <motion.div 
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ duration: 0.3 }}
            className="h-12 w-12 rounded-full bg-[#24292f] dark:bg-[#1f242c] flex items-center justify-center text-white shadow-sm cursor-pointer hover:opacity-90 border border-slate-200 dark:border-slate-800"
          >
            <Landmark className="h-6 w-6 text-white" />
          </motion.div>
          
          <h2 className="text-2xl font-light tracking-tight text-[#24292f] dark:text-[#f0f6fc] mt-6 text-center">
            Se connecter à Ecclesiaste
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1.5 font-medium">
            Administration & Consolidation Multi-Niveau
          </p>
        </div>

        {/* Dynamic Help Center Info Alert */}
        {showHelp && (
          <motion.div 
            initial={{ opacity: 0, y: -8 }}
            animate={{ opacity: 1, y: 0 }}
            className="mb-4 p-3 bg-blue-50 dark:bg-blue-950/40 border border-blue-200 dark:border-blue-900 rounded-lg text-xs text-blue-800 dark:text-blue-300 space-y-1.5"
          >
            <div className="flex items-center gap-1.5 font-bold">
              <Info className="h-3.5 w-3.5" />
              <span>Aide à la connexion</span>
            </div>
            <p className="leading-relaxed text-[11px]">
              Saisissez n'importe quel identifiant et mot de passe (ex: <code className="bg-slate-200/60 dark:bg-slate-800 px-1 py-0.5 rounded font-mono">nestor</code>).
              Sélectionnez ensuite votre niveau de scope et rôles ecclésiastiques pour personnaliser votre session.
            </p>
          </motion.div>
        )}

        {/* Main Error Indicator if any */}
        {error && (
          <motion.div 
            initial={{ opacity: 0, y: -5 }}
            animate={{ opacity: 1, y: 0 }}
            className="mb-4 p-3 bg-[#ffebe9] dark:bg-red-950/40 border border-[#ffc1bd] dark:border-red-900 text-red-900 dark:text-red-300 rounded-lg text-xs flex gap-2.5 items-start"
          >
            <ShieldAlert className="h-4 w-4 shrink-0 mt-0.5 text-red-600" />
            <div>
              <p className="font-semibold">Erreur de saisie</p>
              <p className="text-[11px] leading-relaxed mt-0.5">{error}</p>
            </div>
          </motion.div>
        )}

        {/* GitHub-style login card */}
        <motion.div 
          initial={{ y: 15, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.35, delay: 0.05 }}
          className="bg-white dark:bg-[#161b22] border border-[#d8dee4] dark:border-[#21262d] rounded-lg p-5 shadow-sm github-login-card"
        >
          <form onSubmit={handleSubmit} className="space-y-4">
            
            {/* Input 1: Username / Email */}
            <div>
              <label className="block text-xs font-semibold text-[#24292f] dark:text-[#c9d1d9] mb-1.5 text-left">
                Identifiant ou adresse e-mail
              </label>
              <input
                type="text"
                required
                autoFocus
                placeholder="Ex: nestor.mbuyi@ecclesiaste.org"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                disabled={loading}
                className="w-full text-xs rounded-lg border border-slate-200 px-3 py-2 outline-none focus:border-brand-blue/50 bg-white font-medium github-login-input"
              />
            </div>

            {/* Input 2: Password */}
            <div>
              <div className="flex items-center justify-between mb-1.5">
                <label className="text-xs font-semibold text-[#24292f] dark:text-[#c9d1d9]">
                  Mot de passe
                </label>
                <a 
                  href="#forgot" 
                  onClick={(e) => {
                    e.preventDefault();
                    setError("Pour réinitialiser votre accès, veuillez contacter le secrétariat territorial.");
                  }}
                  className="text-[11px] text-[#0969da] dark:text-[#58a6ff] hover:underline font-medium"
                >
                  Mot de passe oublié ?
                </a>
              </div>
              <input
                type="password"
                placeholder="••••••••"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                disabled={loading}
                className="w-full text-xs rounded-lg border border-slate-200 px-3 py-2 outline-none focus:border-brand-blue/50 bg-white font-medium github-login-input"
              />
            </div>

            {/* Dynamic Context 1: Niveau de Scope (Hierarchy) */}
            <div>
              <label className="block text-xs font-semibold text-[#24292f] dark:text-[#c9d1d9] mb-1.5 text-left">
                Niveau de Scope Initial
              </label>
              <select
                value={level}
                onChange={(e) => setLevel(e.target.value)}
                disabled={loading}
                className="w-full text-xs rounded-md border border-[#d0d7de] dark:border-[#30363d] p-2 outline-none focus:border-[#0969da] bg-white dark:bg-[#0d1117] text-[#24292f] dark:text-[#c9d1d9] font-medium github-login-select"
              >
                <option value="INTERNATIONAL">🌍 Internationale (ENA)</option>
                <option value="TERRITORIAL">🇨🇩 Territoriale (RDC Ouest)</option>
                <option value="REGION">🏛️ Région (Kinshasa)</option>
                <option value="CHAMP">⚡ Champ Apostolique (KSO)</option>
                <option value="DISTRICT">🏘️ District (KSO 01 Lemba)</option>
                <option value="COMMUNITY">⛪ Communauté (Béthel)</option>
              </select>
            </div>

            {/* Dynamic Context 2: Rôle / Fonction (Role) */}
            <div>
              <label className="block text-xs font-semibold text-[#24292f] dark:text-[#c9d1d9] mb-1.5 text-left">
                Rôle de Service
              </label>
              <select
                value={role}
                onChange={(e) => setRole(e.target.value)}
                disabled={loading}
                className="w-full text-xs rounded-md border border-[#d0d7de] dark:border-[#30363d] p-2 outline-none focus:border-[#0969da] bg-white dark:bg-[#0d1117] text-[#24292f] dark:text-[#c9d1d9] font-medium github-login-select"
              >
                <option value="Administrateur">Administrateur Technique</option>
                <option value="Responsable">Responsable Pastoral</option>
                <option value="Secrétaire">Secrétaire d'Entité</option>
                <option value="Trésorier">Trésorier de Caisse</option>
                <option value="Membre">Fidèle / Membre d'Assemblée</option>
              </select>
            </div>

            {/* Dynamic Context 3: Ministère Liturgique (Ministry) */}
            <div>
              <label className="block text-xs font-semibold text-[#24292f] dark:text-[#c9d1d9] mb-1.5 text-left">
                Ministère
              </label>
              <select
                value={ministry}
                onChange={(e) => setMinistry(e.target.value)}
                disabled={loading}
                className="w-full text-xs rounded-md border border-[#d0d7de] dark:border-[#30363d] p-2 outline-none focus:border-[#0969da] bg-white dark:bg-[#0d1117] text-[#24292f] dark:text-[#c9d1d9] font-medium github-login-select"
              >
                <option value="Apôtre">Apôtre (Ap.)</option>
                <option value="Évêque">Évêque (Év.)</option>
                <option value="Ancien">Ancien (Anc.)</option>
                <option value="Évangéliste">Évangéliste (Év.)</option>
                <option value="Berger">Berger (Bg.)</option>
                <option value="Prêtre">Prêtre (Pr.)</option>
                <option value="Diacre">Diacre (Dc.)</option>
                <option value="Aucun">Aucun (Fidèle)</option>
              </select>
            </div>

            {/* High-polish Green "Sign in" Submit Button */}
            <button
              type="submit"
              disabled={loading}
              className="w-full mt-2 bg-[#2da44e] text-white hover:bg-[#2c974b] disabled:bg-[#2da44e]/50 border border-[rgba(27,31,36,0.15)] font-semibold rounded-md py-2 px-4 text-center text-sm shadow-sm cursor-pointer transition-colors duration-150 flex items-center justify-center gap-2"
            >
              {loading ? (
                <>
                  <span className="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                  Connexion en cours...
                </>
              ) : (
                "Se connecter"
              )}
            </button>
          </form>
        </motion.div>

        {/* Sub-card below with sign up prompt */}
        <div className="border border-[#d8dee4] dark:border-[#21262d] rounded-lg p-4 text-center text-xs mt-4 text-[#24292f] dark:text-[#f0f6fc] font-medium">
          Nouveau sur Ecclesiaste ?{" "}
          <button 
            type="button"
            onClick={() => setShowHelp(p => !p)}
            className="text-[#0969da] dark:text-[#58a6ff] hover:underline font-bold inline-flex items-center gap-0.5 cursor-pointer bg-transparent"
          >
            Demander un accès.
          </button>
        </div>
      </div>

      {/* GitHub centered footer links */}
      <footer className="w-full text-center py-8 text-[11px] text-[#57606a] dark:text-[#8b949e] border-t border-slate-200/50 dark:border-slate-800 bg-[#f6f8fa]/50 dark:bg-[#0d1117]/80">
        <div className="flex flex-wrap justify-center gap-x-4 gap-y-1 max-w-sm mx-auto px-4">
          <a href="#terms" className="hover:text-[#0969da] dark:hover:text-[#58a6ff] hover:underline transition-colors">Conditions</a>
          <a href="#privacy" className="hover:text-[#0969da] dark:hover:text-[#58a6ff] hover:underline transition-colors">Confidentialité</a>
          <a href="#security" className="hover:text-[#0969da] dark:hover:text-[#58a6ff] hover:underline transition-colors">Sécurité</a>
          <a href="#contact" onClick={() => setShowHelp(true)} className="hover:text-[#0969da] dark:hover:text-[#58a6ff] hover:underline transition-colors">Support technique</a>
        </div>
        <p className="mt-2 text-[10px] text-slate-400 dark:text-slate-600 font-medium font-mono">
          Ecclesiaste ERP © 2026 - RDC OUEST
        </p>
      </footer>

    </div>
  );
};
