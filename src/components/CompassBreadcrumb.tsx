import React, { useMemo } from 'react';
import { EcclesiasticalEntity, EntityLevel } from '../types';
import { Compass, Users, Landmark, ChevronRight, User } from 'lucide-react';
import { motion } from 'motion/react';

interface CompassBreadcrumbProps {
  entities: EcclesiasticalEntity[];
  activeEntityId: string;
  onEntityChange: (id: string) => void;
}

export const CompassBreadcrumb: React.FC<CompassBreadcrumbProps> = ({
  entities,
  activeEntityId,
  onEntityChange
}) => {
  // Find current entity
  const currentEntity = useMemo(() => {
    return entities.find(e => e.id === activeEntityId) || entities[0];
  }, [entities, activeEntityId]);

  // Build breadcrumb trail from current entity to root
  const breadcrumbs = useMemo(() => {
    const trail: EcclesiasticalEntity[] = [];
    let current = currentEntity;
    
    while (current) {
      trail.unshift(current);
      if (current.parent_id) {
        const parent = entities.find(e => e.id === current.parent_id);
        if (parent) {
          current = parent;
        } else {
          break;
        }
      } else {
        break;
      }
    }
    return trail;
  }, [entities, currentEntity]);

  // Group entities by level for structured dropdown selection
  const levels: { label: string; level: EntityLevel }[] = [
    { label: 'Internationale', level: 'INTERNATIONAL' },
    { label: 'Territoriale', level: 'TERRITORIAL' },
    { label: 'Région', level: 'REGION' },
    { label: 'Champ Apostolique', level: 'CHAMP' },
    { label: 'District', level: 'DISTRICT' },
    { label: 'Communauté', level: 'COMMUNITY' }
  ];

  // For each level, determine what is selected in the current path
  const selectionsAtLevels = useMemo(() => {
    const map: Record<EntityLevel, EcclesiasticalEntity | undefined> = {
      INTERNATIONAL: undefined,
      TERRITORIAL: undefined,
      REGION: undefined,
      CHAMP: undefined,
      DISTRICT: undefined,
      COMMUNITY: undefined
    };
    breadcrumbs.forEach(b => {
      map[b.level] = b;
    });
    return map;
  }, [breadcrumbs]);

  // Get options for each level dropdown
  const getOptionsForLevel = (level: EntityLevel, index: number) => {
    if (level === 'INTERNATIONAL') {
      return entities.filter(e => e.level === 'INTERNATIONAL');
    }
    
    // For subsequent levels, options are children of the entity selected at the previous level
    const prevLevel = levels[index - 1].level;
    const selectedParent = selectionsAtLevels[prevLevel];
    if (!selectedParent) return [];
    
    return entities.filter(e => e.parent_id === selectedParent.id && e.level === level);
  };

  const getLevelColor = (level: EntityLevel) => {
    switch (level) {
      case 'INTERNATIONAL': return 'bg-amber-100 text-amber-800 border-amber-200';
      case 'TERRITORIAL': return 'bg-indigo-100 text-indigo-800 border-indigo-200';
      case 'REGION': return 'bg-sky-100 text-sky-800 border-sky-200';
      case 'CHAMP': return 'bg-teal-100 text-teal-800 border-teal-200';
      case 'DISTRICT': return 'bg-purple-100 text-purple-800 border-purple-200';
      case 'COMMUNITY': return 'bg-emerald-100 text-emerald-800 border-emerald-200';
    }
  };

  return (
    <div id="compass-nav-card" className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 mb-6">
      {/* Upper Compass & Breadcrumb trail */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-100 pb-4 mb-4">
        <div className="flex items-center gap-3">
          <div className="p-2.5 bg-brand-blue/10 text-brand-blue rounded-lg">
            <Compass className="h-6 w-6 animate-spin-slow" />
          </div>
          <div>
            <h2 className="text-sm font-semibold text-slate-500 uppercase tracking-wider">Boussole de Scope (Fil d'Ariane)</h2>
            <div className="flex flex-wrap items-center gap-1.5 mt-1 text-sm font-medium">
              {breadcrumbs.map((b, i) => (
                <React.Fragment key={b.id}>
                  {i > 0 && <ChevronRight className="h-4 w-4 text-slate-400 shrink-0" />}
                  <button
                    onClick={() => onEntityChange(b.id)}
                    className={`hover:text-brand-blue hover:underline transition-colors ${
                      b.id === activeEntityId ? 'text-brand-blue font-bold' : 'text-slate-600'
                    }`}
                  >
                    {b.name}
                  </button>
                </React.Fragment>
              ))}
            </div>
          </div>
        </div>

        {/* Current Info pill */}
        <div className="flex items-center gap-2 self-start md:self-auto">
          <span className={`text-xs px-2.5 py-1 rounded-full font-bold border ${getLevelColor(currentEntity.level)}`}>
            {currentEntity.level}
          </span>
          <span className="text-xs bg-slate-100 text-slate-600 border border-slate-200 px-2.5 py-1 rounded-full font-semibold">
            {currentEntity.code}
          </span>
        </div>
      </div>

      {/* Selectors for all 6 hierarchical levels */}
      <div className="grid grid-cols-2 md:grid-cols-6 gap-3 mb-4">
        {levels.map((item, index) => {
          const selected = selectionsAtLevels[item.level];
          const options = getOptionsForLevel(item.level, index);
          const isDisabled = index > 0 && !selectionsAtLevels[levels[index - 1].level];

          return (
            <div key={item.level} className="flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-slate-500">{item.label}</label>
              <select
                disabled={isDisabled || options.length === 0}
                value={selected?.id || ''}
                onChange={(e) => {
                  if (e.target.value) {
                    onEntityChange(e.target.value);
                  }
                }}
                className={`text-xs rounded-lg border p-2 bg-slate-50 hover:bg-slate-100/50 outline-none transition-all ${
                  selected ? 'border-brand-blue/50 text-brand-blue font-medium bg-brand-blue/5' : 'border-slate-200 text-slate-600'
                } disabled:opacity-50 disabled:cursor-not-allowed`}
              >
                <option value="" disabled>Sélectionner...</option>
                {options.map((opt) => (
                  <option key={opt.id} value={opt.id}>
                    {opt.name}
                  </option>
                ))}
              </select>
            </div>
          );
        })}
      </div>

      {/* Active scope details details panel */}
      <motion.div
        layout
        initial={{ opacity: 0, y: 5 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-slate-50 rounded-lg p-4 border border-slate-100 grid grid-cols-1 md:grid-cols-3 gap-4"
      >
        <div className="flex items-center gap-3">
          <User className="h-5 w-5 text-slate-400 shrink-0" />
          <div>
            <p className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Responsable / Clergé</p>
            <p className="text-sm font-semibold text-slate-700">{currentEntity.responsible || "À désigner"}</p>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <Landmark className="h-5 w-5 text-slate-400 shrink-0" />
          <div>
            <p className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Siège / Adresse</p>
            <p className="text-sm font-semibold text-slate-700">{currentEntity.siege || "Non spécifié"}</p>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <Users className="h-5 w-5 text-slate-400 shrink-0" />
          <div>
            <p className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Fidèles Estimés / Communautés</p>
            <p className="text-sm font-semibold text-slate-700">
              {currentEntity.members_count?.toLocaleString() || 0} membres {currentEntity.communities_count ? `(${currentEntity.communities_count} églises)` : ''}
            </p>
          </div>
        </div>
      </motion.div>
    </div>
  );
};
