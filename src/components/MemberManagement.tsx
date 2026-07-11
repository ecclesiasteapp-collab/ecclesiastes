import React, { useState, useMemo } from 'react';
import { EcclesiasticalEntity, MemberProfile } from '../types';
import { Users, UserPlus, Search, ShieldCheck, Phone, Check, ChevronRight, X } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { useToast } from './Toast';

interface MemberManagementProps {
  entities: EcclesiasticalEntity[];
  activeEntityId: string;
  members: MemberProfile[];
  onAddMember: (member: Omit<MemberProfile, 'id'>) => void;
}

export const MemberManagement: React.FC<MemberManagementProps> = ({
  entities,
  activeEntityId,
  members,
  onAddMember
}) => {
  const { showToast } = useToast();
  const [showStepper, setShowStepper] = useState(false);
  const [step, setStep] = useState(1);
  const [searchTerm, setSearchTerm] = useState('');

  // Form Fields State
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [phone, setPhone] = useState('');
  const [gender, setGender] = useState<'M' | 'F'>('M');
  const [birthDate, setBirthDate] = useState('1990-01-01');
  const [rank, setRank] = useState('Membre');
  const [isConfirmed, setIsConfirmed] = useState(true);
  const [entryDate, setEntryDate] = useState(new Date().toISOString().split('T')[0]);
  const [selectedEntityId, setSelectedEntityId] = useState(activeEntityId);

  // Find current active entity
  const currentEntity = useMemo(() => {
    return entities.find(e => e.id === activeEntityId) || entities[0];
  }, [entities, activeEntityId]);

  // Recursively find all descendant ids of the active entity to filter members
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

  // Filter members belonging to active entity or any descendant (Hierarchical scoping)
  const filteredMembers = useMemo(() => {
    return members.filter(m => {
      const matchesScope = descendantIds.includes(m.entityId);
      const matchesSearch = 
        `${m.firstName} ${m.lastName}`.toLowerCase().includes(searchTerm.toLowerCase()) ||
        m.phone.includes(searchTerm) ||
        m.rank.toLowerCase().includes(searchTerm.toLowerCase());
      return matchesScope && matchesSearch;
    });
  }, [members, descendantIds, searchTerm]);

  // Get only districts and communities for the member assignment selector
  const eligibleEntities = useMemo(() => {
    return entities.filter(e => e.level === 'COMMUNITY' || e.level === 'DISTRICT');
  }, [entities]);

  const handleNextStep = () => {
    if (step < 3) setStep(step + 1);
  };

  const handlePrevStep = () => {
    if (step > 1) setStep(step - 1);
  };

  const handleRegister = (e: React.FormEvent) => {
    e.preventDefault();
    if (!firstName.trim() || !lastName.trim() || !phone.trim()) return;

    onAddMember({
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phone: phone.trim(),
      gender,
      birthDate,
      rank,
      isConfirmed,
      entryDate,
      entityId: selectedEntityId
    });

    showToast(`Membre ${firstName.trim()} ${lastName.trim()} inscrit avec succès.`, 'success');

    // Reset Stepper
    setFirstName('');
    setLastName('');
    setPhone('');
    setGender('M');
    setBirthDate('1990-01-01');
    setRank('Membre');
    setIsConfirmed(true);
    setEntryDate(new Date().toISOString().split('T')[0]);
    setSelectedEntityId(activeEntityId);
    setStep(1);
    setShowStepper(false);
  };

  const getEntityName = (id: string) => {
    return entities.find(e => e.id === id)?.name || id;
  };

  return (
    <div id="member-management" className="space-y-6">
      {/* Top Banner */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h3 className="font-bold text-slate-800 text-base">Fichier des Membres de l'Église</h3>
          <p className="text-xs text-slate-500 mt-1">
            Recensement et cartographie hiérarchique des fidèles et du clergé sous la juridiction de <strong className="text-brand-blue">{currentEntity.name}</strong>.
          </p>
        </div>

        <button
          onClick={() => {
            setSelectedEntityId(activeEntityId);
            setShowStepper(!showStepper);
          }}
          className="flex items-center gap-1.5 text-xs bg-brand-blue hover:bg-brand-blue/90 text-white font-bold py-2.5 px-4 rounded-lg transition-all cursor-pointer"
        >
          <UserPlus className="h-4 w-4" />
          Inscrire un Membre
        </button>
      </div>

      <AnimatePresence mode="wait">
        {showStepper && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="bg-white rounded-xl shadow-sm border border-slate-100 p-6"
          >
            {/* Step indicators */}
            <div className="flex items-center justify-center max-w-xl mx-auto mb-8">
              <div className="flex items-center w-full">
                <div className={`flex items-center justify-center h-8 w-8 rounded-full font-bold text-xs shrink-0 transition-all ${
                  step >= 1 ? 'bg-brand-blue text-white' : 'bg-slate-100 text-slate-500'
                }`}>
                  {step > 1 ? <Check className="h-4 w-4" /> : '1'}
                </div>
                <div className={`h-1 w-full transition-all ${step >= 2 ? 'bg-brand-blue' : 'bg-slate-100'}`} />
                <div className={`flex items-center justify-center h-8 w-8 rounded-full font-bold text-xs shrink-0 transition-all ${
                  step >= 2 ? 'bg-brand-blue text-white' : 'bg-slate-100 text-slate-500'
                }`}>
                  {step > 2 ? <Check className="h-4 w-4" /> : '2'}
                </div>
                <div className={`h-1 w-full transition-all ${step >= 3 ? 'bg-brand-blue' : 'bg-slate-100'}`} />
                <div className={`flex items-center justify-center h-8 w-8 rounded-full font-bold text-xs shrink-0 transition-all ${
                  step >= 3 ? 'bg-brand-blue text-white' : 'bg-slate-100 text-slate-500'
                }`}>
                  3
                </div>
              </div>
            </div>

            <form onSubmit={handleRegister} className="space-y-4 max-w-2xl mx-auto">
              {/* STEP 1: Civil Identity */}
              {step === 1 && (
                <motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} className="space-y-4">
                  <h4 className="font-bold text-slate-800 text-sm border-b border-slate-50 pb-2">Étape 1 : Identité Civile</h4>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="text-xs font-semibold text-slate-500 block mb-1">Nom de famille</label>
                      <input
                        type="text"
                        required
                        value={lastName}
                        onChange={(e) => setLastName(e.target.value)}
                        placeholder="Ex: Kabasele"
                        className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                      />
                    </div>

                    <div>
                      <label className="text-xs font-semibold text-slate-500 block mb-1">Prénom</label>
                      <input
                        type="text"
                        required
                        value={firstName}
                        onChange={(e) => setFirstName(e.target.value)}
                        placeholder="Ex: Marie"
                        className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                      <label className="text-xs font-semibold text-slate-500 block mb-1">Genre</label>
                      <select
                        value={gender}
                        onChange={(e) => setGender(e.target.value as 'M' | 'F')}
                        className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                      >
                        <option value="M">Masculin</option>
                        <option value="F">Féminin</option>
                      </select>
                    </div>

                    <div>
                      <label className="text-xs font-semibold text-slate-500 block mb-1">Date de Naissance</label>
                      <input
                        type="date"
                        required
                        value={birthDate}
                        onChange={(e) => setBirthDate(e.target.value)}
                        className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                      />
                    </div>

                    <div>
                      <label className="text-xs font-semibold text-slate-500 block mb-1">N° Téléphone</label>
                      <input
                        type="tel"
                        required
                        value={phone}
                        onChange={(e) => setPhone(e.target.value)}
                        placeholder="Ex: +243 812 345 678"
                        className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                      />
                    </div>
                  </div>
                </motion.div>
              )}

              {/* STEP 2: Ecclesiastical Identity */}
              {step === 2 && (
                <motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} className="space-y-4">
                  <h4 className="font-bold text-slate-800 text-sm border-b border-slate-50 pb-2">Étape 2 : Profil Ecclésiastique</h4>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="text-xs font-semibold text-slate-500 block mb-1">Ministère / Rang</label>
                      <select
                        value={rank}
                        onChange={(e) => setRank(e.target.value)}
                        className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                      >
                        <option value="Membre">Membre Ordinaire</option>
                        <option value="Diacre">Diacre</option>
                        <option value="Prêtre">Prêtre</option>
                        <option value="Berger">Berger</option>
                        <option value="Evangéliste">Evangéliste</option>
                        <option value="Ancien de District">Ancien de District</option>
                        <option value="Apôtre">Apôtre</option>
                      </select>
                    </div>

                    <div>
                      <label className="text-xs font-semibold text-slate-500 block mb-1">Date de confirmation / d'entrée</label>
                      <input
                        type="date"
                        required
                        value={entryDate}
                        onChange={(e) => setEntryDate(e.target.value)}
                        className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                      />
                    </div>
                  </div>

                  <div className="flex items-center gap-3 bg-slate-50 border border-slate-100 p-3.5 rounded-lg mt-2">
                    <input
                      type="checkbox"
                      id="isConfirmed"
                      checked={isConfirmed}
                      onChange={(e) => setIsConfirmed(e.target.checked)}
                      className="h-4 w-4 text-brand-blue border-slate-300 rounded focus:ring-brand-blue"
                    />
                    <label htmlFor="isConfirmed" className="text-xs text-slate-600 font-medium select-none">
                      Le fidèle est pleinement confirmé et scellé par le Saint-Esprit (Sacramentel)
                    </label>
                  </div>
                </motion.div>
              )}

              {/* STEP 3: Mapping Assignment */}
              {step === 3 && (
                <motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} className="space-y-4">
                  <h4 className="font-bold text-slate-800 text-sm border-b border-slate-50 pb-2">Étape 3 : Affectation Hiérarchique</h4>
                  
                  <div>
                    <label className="text-xs font-semibold text-slate-500 block mb-1.5">Communauté ou District d'attache</label>
                    <select
                      value={selectedEntityId}
                      onChange={(e) => setSelectedEntityId(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    >
                      {eligibleEntities.map((ent) => (
                        <option key={ent.id} value={ent.id}>
                          [{ent.level}] {ent.name} ({ent.code})
                        </option>
                      ))}
                    </select>
                  </div>

                  <div className="p-4 bg-blue-50/50 border border-blue-100 rounded-lg text-xs text-slate-600 space-y-1">
                    <p className="font-bold text-brand-blue">Vérification de l'Affectation :</p>
                    <p>Le nouveau membre sera rattaché à <strong>{getEntityName(selectedEntityId)}</strong>.</p>
                    <p>Les rapports pastoraux de district agrégeront automatiquement cette inscription dans la boussole active.</p>
                  </div>
                </motion.div>
              )}

              {/* Stepper Buttons */}
              <div className="border-t border-slate-100 pt-4 flex justify-between gap-3">
                <button
                  type="button"
                  disabled={step === 1}
                  onClick={handlePrevStep}
                  className="text-xs bg-slate-100 hover:bg-slate-200 disabled:opacity-40 disabled:cursor-not-allowed text-slate-600 font-bold py-2.5 px-5 rounded-lg transition-colors cursor-pointer"
                >
                  Précédent
                </button>

                <div className="flex gap-2.5">
                  {step < 3 ? (
                    <button
                      type="button"
                      onClick={handleNextStep}
                      className="flex items-center gap-1 text-xs bg-brand-blue hover:bg-brand-blue/90 text-white font-bold py-2.5 px-5 rounded-lg transition-colors cursor-pointer"
                    >
                      Suivant
                      <ChevronRight className="h-4 w-4" />
                    </button>
                  ) : (
                    <button
                      type="submit"
                      className="text-xs bg-brand-blue hover:bg-brand-blue/90 text-white font-bold py-2.5 px-5 rounded-lg transition-colors cursor-pointer"
                    >
                      Inscrire Définitivement
                    </button>
                  )}
                  
                  <button
                    type="button"
                    onClick={() => setShowStepper(false)}
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

      {/* Members Directory List */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-4 mb-4 border-b border-slate-100">
          <div>
            <div className="flex items-center gap-2">
              <h3 className="font-bold text-slate-800 text-base">Annuaire des Fidèles</h3>
              <span className="text-[10px] font-bold bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full">
                {filteredMembers.length} / {members.filter(m => descendantIds.includes(m.entityId)).length}
              </span>
            </div>
            <p className="text-xs text-slate-500 mt-0.5">Membres et clergé recensés dans le scope</p>
          </div>
 
          {/* Search Input */}
          <div className="relative max-w-xs w-full">
            <Search className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Rechercher par nom, prénom ou fonction..."
              className="w-full text-xs rounded-lg border border-slate-200 pl-9 pr-8 py-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
            />
            {searchTerm && (
              <button
                onClick={() => setSearchTerm('')}
                className="absolute right-3 top-2.5 text-slate-400 hover:text-slate-600 transition-colors"
                title="Effacer la recherche"
              >
                <X className="h-4 w-4" />
              </button>
            )}
          </div>
        </div>

        {filteredMembers.length === 0 ? (
          <div className="text-center py-12 text-slate-400">
            <Users className="h-12 w-12 mx-auto stroke-1" />
            <p className="text-xs mt-3">Aucun membre ne correspond aux critères.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-slate-100 text-slate-400 font-bold uppercase tracking-wider">
                  <th className="py-3 px-2">Membre</th>
                  <th className="py-3 px-2">Téléphone</th>
                  <th className="py-3 px-2">Genre</th>
                  <th className="py-3 px-2">Date Naiss.</th>
                  <th className="py-3 px-2">Communauté / District</th>
                  <th className="py-3 px-2">Ministère</th>
                  <th className="py-3 px-2 text-center">Scellement</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50 text-slate-700 font-medium">
                {filteredMembers.map((m) => (
                  <tr key={m.id} className="hover:bg-slate-50/50 transition-colors">
                    <td className="py-3 px-2">
                      <div className="flex items-center gap-2.5">
                        <div className="h-8 w-8 rounded-full bg-slate-100 flex items-center justify-center text-slate-600 font-bold uppercase border border-slate-200 shrink-0">
                          {m.firstName[0]}{m.lastName[0]}
                        </div>
                        <div>
                          <p className="font-bold text-slate-900">{m.lastName} {m.firstName}</p>
                          <p className="text-[10px] text-slate-400 font-mono">Inscrit le {m.entryDate}</p>
                        </div>
                      </div>
                    </td>
                    <td className="py-3 px-2 text-slate-500 flex items-center gap-1.5 font-mono">
                      <Phone className="h-3.5 w-3.5" />
                      {m.phone}
                    </td>
                    <td className="py-3 px-2 text-slate-600 font-bold">{m.gender}</td>
                    <td className="py-3 px-2 text-slate-500 font-mono">{m.birthDate}</td>
                    <td className="py-3 px-2 text-slate-900 font-semibold">{getEntityName(m.entityId)}</td>
                    <td className="py-3 px-2">
                      <span className={`text-[10px] py-1 px-2.5 rounded-full font-bold border ${
                        ['Apôtre', 'Ancien de District'].includes(m.rank)
                          ? 'bg-amber-50 text-amber-800 border-amber-200'
                          : ['Berger', 'Evangéliste', 'Prêtre'].includes(m.rank)
                            ? 'bg-blue-50 text-blue-800 border-blue-200'
                            : 'bg-slate-50 text-slate-700 border-slate-200'
                      }`}>
                        {m.rank}
                      </span>
                    </td>
                    <td className="py-3 px-2 text-center">
                      {m.isConfirmed ? (
                        <span className="inline-flex items-center gap-1 text-[10px] text-emerald-600 bg-emerald-50 border border-emerald-200 py-0.5 px-2 rounded-full font-bold">
                          <ShieldCheck className="h-3.5 w-3.5" />
                          Scellé
                        </span>
                      ) : (
                        <span className="inline-flex items-center gap-1 text-[10px] text-slate-500 bg-slate-50 border border-slate-200 py-0.5 px-2 rounded-full font-bold">
                          Non scellé
                        </span>
                      )}
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
