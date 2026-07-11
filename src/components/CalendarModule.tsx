import React, { useState, useMemo } from 'react';
import { EcclesiasticalEntity, MemberProfile, CalendarEvent, EventType, AvailabilityStatus } from '../types';
import { 
  Calendar, 
  Clock, 
  MapPin, 
  User, 
  PlusCircle, 
  Search, 
  Check, 
  X, 
  ChevronLeft, 
  ChevronRight, 
  Info, 
  Users, 
  AlertCircle, 
  CalendarDays,
  Sparkles,
  ClipboardCheck,
  Building
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { useToast } from './Toast';

interface CalendarModuleProps {
  entities: EcclesiasticalEntity[];
  activeEntityId: string;
  members: MemberProfile[];
  events: CalendarEvent[];
  onAddEvent: (newEvent: Omit<CalendarEvent, 'id'>) => void;
  onUpdateEvent: (updatedEvent: CalendarEvent) => void;
}

export function CalendarModule({
  entities,
  activeEntityId,
  members,
  events,
  onAddEvent,
  onUpdateEvent
}: CalendarModuleProps) {
  const { showToast } = useToast();

  // State Management
  const [currentDate, setCurrentDate] = useState<Date>(new Date(2026, 6, 9)); // Default to July 2026 based on metadata
  const [selectedEventId, setSelectedEventId] = useState<string | null>(events[0]?.id || null);
  const [searchTerm, setSearchTerm] = useState<string>('');
  const [selectedType, setSelectedType] = useState<string>('ALL');
  const [showAddForm, setShowAddForm] = useState<boolean>(false);
  const [viewMode, setViewMode] = useState<'calendar' | 'list'>('calendar');

  // New Event Form State
  const [newTitle, setNewTitle] = useState<string>('');
  const [newType, setNewType] = useState<EventType>('WORSHIP');
  const [newDate, setNewDate] = useState<string>('2026-07-12');
  const [newTime, setNewTime] = useState<string>('10:00');
  const [newLocation, setNewLocation] = useState<string>('');
  const [newOfficiant, setNewOfficiant] = useState<string>('');
  const [newDescription, setNewDescription] = useState<string>('');
  const [newEntityId, setNewEntityId] = useState<string>(activeEntityId);

  // Translate event types for labels
  const eventTypeLabels: Record<EventType, string> = {
    WORSHIP: 'Culte',
    MEETING: 'Réunion',
    YOUTH: 'Jeunesse',
    CHOIR: 'Chorale',
    SEMINAR: 'Séminaire'
  };

  const eventTypeColors: Record<EventType, { bg: string, text: string, border: string, dot: string }> = {
    WORSHIP: { bg: 'bg-emerald-50', text: 'text-emerald-700', border: 'border-emerald-200', dot: 'bg-emerald-500' },
    MEETING: { bg: 'bg-indigo-50', text: 'text-indigo-700', border: 'border-indigo-200', dot: 'bg-indigo-500' },
    YOUTH: { bg: 'bg-amber-50', text: 'text-amber-700', border: 'border-amber-200', dot: 'bg-amber-500' },
    CHOIR: { bg: 'bg-pink-50', text: 'text-pink-700', border: 'border-pink-200', dot: 'bg-pink-500' },
    SEMINAR: { bg: 'bg-sky-50', text: 'text-sky-700', border: 'border-sky-200', dot: 'bg-sky-500' }
  };

  // Find active entity metadata
  const activeEntity = useMemo(() => {
    return entities.find(e => e.id === activeEntityId) || entities[0];
  }, [entities, activeEntityId]);

  // Compute sub-entities hierarchically for scoping
  const descendantIds = useMemo(() => {
    const getDescendants = (id: string): string[] => {
      const children = entities.filter(e => e.parent_id === id);
      return [id, ...children.flatMap(c => getDescendants(c.id))];
    };
    return getDescendants(activeEntityId);
  }, [entities, activeEntityId]);

  // Filter events belonging to active entity or sub-entities
  const scopedEvents = useMemo(() => {
    return events.filter(evt => descendantIds.includes(evt.entityId));
  }, [events, descendantIds]);

  // Filter events by Search & Type Filters
  const filteredEvents = useMemo(() => {
    return scopedEvents.filter(evt => {
      const matchesType = selectedType === 'ALL' || evt.type === selectedType;
      const matchesSearch = 
        evt.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        evt.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
        evt.location.toLowerCase().includes(searchTerm.toLowerCase()) ||
        evt.officiant.toLowerCase().includes(searchTerm.toLowerCase());
      return matchesType && matchesSearch;
    });
  }, [scopedEvents, selectedType, searchTerm]);

  // Get members belonging strictly to active entity or its sub-entities for availability check
  const scopedMembers = useMemo(() => {
    return members.filter(m => descendantIds.includes(m.entityId));
  }, [members, descendantIds]);

  // Get selected event object
  const selectedEvent = useMemo(() => {
    return events.find(e => e.id === selectedEventId) || scopedEvents[0] || null;
  }, [events, selectedEventId, scopedEvents]);

  // Monthly Calendar Helper Calculations
  const calendarDays = useMemo(() => {
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();

    // First day of current month (0 is Sunday, 1 is Monday...)
    const firstDayIndex = new Date(year, month, 1).getDay();
    // Adjust Sunday to index 6 to start week on Monday
    const startOffset = firstDayIndex === 0 ? 6 : firstDayIndex - 1;

    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const daysInPrevMonth = new Date(year, month, 0).getDate();

    const result: { date: Date; isCurrentMonth: boolean; key: string }[] = [];

    // Fill previous month days
    for (let i = startOffset - 1; i >= 0; i--) {
      const day = daysInPrevMonth - i;
      result.push({
        date: new Date(year, month - 1, day),
        isCurrentMonth: false,
        key: `prev-${day}`
      });
    }

    // Fill current month days
    for (let i = 1; i <= daysInMonth; i++) {
      result.push({
        date: new Date(year, month, i),
        isCurrentMonth: true,
        key: `current-${i}`
      });
    }

    // Fill next month days to complete grid (multiples of 7)
    const remainingGrid = 42 - result.length;
    for (let i = 1; i <= remainingGrid; i++) {
      result.push({
        date: new Date(year, month + 1, i),
        isCurrentMonth: false,
        key: `next-${i}`
      });
    }

    return result;
  }, [currentDate]);

  // Check if a specific date has any scoped events
  const getEventsForDate = (date: Date) => {
    const yyyy = date.getFullYear();
    const mm = String(date.getMonth() + 1).padStart(2, '0');
    const dd = String(date.getDate()).padStart(2, '0');
    const dateStr = `${yyyy}-${mm}-${dd}`;
    return scopedEvents.filter(evt => evt.date === dateStr);
  };

  // Switch month
  const handlePrevMonth = () => {
    setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1));
  };

  const handleNextMonth = () => {
    setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1));
  };

  // Handle setting member availability
  const handleSetAvailability = (memberId: string, status: AvailabilityStatus) => {
    if (!selectedEvent) return;

    const updatedAvailabilities = {
      ...(selectedEvent.availabilities || {}),
      [memberId]: status
    };

    const updatedEvent: CalendarEvent = {
      ...selectedEvent,
      availabilities: updatedAvailabilities
    };

    onUpdateEvent(updatedEvent);
    showToast(`Disponibilité de la personne enregistrée !`, 'success');
  };

  // Submit new event form
  const handleSubmitEvent = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTitle.trim() || !newLocation.trim() || !newOfficiant.trim()) {
      showToast("Veuillez remplir tous les champs obligatoires.", "error");
      return;
    }

    onAddEvent({
      title: newTitle.trim(),
      type: newType,
      date: newDate,
      time: newTime,
      location: newLocation.trim(),
      description: newDescription.trim(),
      entityId: newEntityId,
      officiant: newOfficiant.trim(),
      availabilities: {}
    });

    // Reset Form
    setNewTitle('');
    setNewLocation('');
    setNewOfficiant('');
    setNewDescription('');
    setShowAddForm(false);
    showToast("Nouvel événement programmé avec succès !", "success");
  };

  // Get active entities descending from active for dropdown
  const allowedFormEntities = useMemo(() => {
    return entities.filter(e => descendantIds.includes(e.id));
  }, [entities, descendantIds]);

  // Group availabilities count for selected event
  const availabilityStats = useMemo(() => {
    if (!selectedEvent || !selectedEvent.availabilities) {
      return { available: 0, unavailable: 0, tentative: 0, unknown: scopedMembers.length };
    }

    let available = 0;
    let unavailable = 0;
    let tentative = 0;

    scopedMembers.forEach(m => {
      const status = selectedEvent.availabilities?.[m.id];
      if (status === 'AVAILABLE') available++;
      else if (status === 'UNAVAILABLE') unavailable++;
      else if (status === 'TENTATIVE') tentative++;
    });

    const totalResponded = available + unavailable + tentative;
    const unknown = Math.max(0, scopedMembers.length - totalResponded);

    return { available, unavailable, tentative, unknown };
  }, [selectedEvent, scopedMembers]);

  return (
    <div id="calendar-module" className="space-y-6">
      
      {/* Header Panel */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-800 flex items-center gap-2">
            <Calendar className="h-5 w-5 text-brand-blue" />
            Calendrier & Activités Ecclésiastiques
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Plannings des cultes, séminaires et réunions hebdomadaires pour le périmètre actif : <strong className="text-brand-blue">{activeEntity.name}</strong>
          </p>
        </div>

        <div className="flex items-center gap-2.5 shrink-0 self-start md:self-auto">
          {/* View toggle */}
          <div className="bg-slate-100 rounded-lg p-0.5 flex border border-slate-200">
            <button
              onClick={() => setViewMode('calendar')}
              className={`px-3 py-1 text-xs font-bold rounded-md transition-all ${
                viewMode === 'calendar' ? 'bg-white text-brand-blue shadow-sm' : 'text-slate-600 hover:text-slate-800'
              }`}
            >
              Vue Calendrier
            </button>
            <button
              onClick={() => setViewMode('list')}
              className={`px-3 py-1 text-xs font-bold rounded-md transition-all ${
                viewMode === 'list' ? 'bg-white text-brand-blue shadow-sm' : 'text-slate-600 hover:text-slate-800'
              }`}
            >
              Liste des Activités
            </button>
          </div>

          <button
            onClick={() => setShowAddForm(!showAddForm)}
            className="flex items-center gap-1.5 text-xs bg-brand-blue hover:bg-brand-blue-dark text-white font-bold py-2 px-3.5 rounded-lg shadow-sm transition-all cursor-pointer"
          >
            <PlusCircle className="h-4 w-4" />
            Planifier un Événement
          </button>
        </div>
      </div>

      {/* Add Event Form Modal/Drawer */}
      <AnimatePresence>
        {showAddForm && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="overflow-hidden"
          >
            <div className="bg-white rounded-xl border border-brand-blue/10 p-5 shadow-md">
              <div className="flex items-center justify-between pb-3 mb-4 border-b border-slate-100">
                <div className="flex items-center gap-2">
                  <Sparkles className="h-4 w-4 text-brand-blue" />
                  <h3 className="font-bold text-slate-800 text-sm">Nouvel Événement à Programmer</h3>
                </div>
                <button
                  onClick={() => setShowAddForm(false)}
                  className="text-slate-400 hover:text-slate-600 cursor-pointer"
                >
                  <X className="h-5 w-5" />
                </button>
              </div>

              <form onSubmit={handleSubmitEvent} className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  {/* Title */}
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-slate-600 block">Titre de l'événement *</label>
                    <input
                      type="text"
                      required
                      placeholder="Ex: Culte de Confirmation"
                      value={newTitle}
                      onChange={(e) => setNewTitle(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>

                  {/* Event Type */}
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-slate-600 block">Type d'activité</label>
                    <select
                      value={newType}
                      onChange={(e) => setNewType(e.target.value as EventType)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    >
                      {Object.entries(eventTypeLabels).map(([val, label]) => (
                        <option key={val} value={val}>{label}</option>
                      ))}
                    </select>
                  </div>

                  {/* Officiant */}
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-slate-600 block">Officiant / Responsable *</label>
                    <input
                      type="text"
                      required
                      placeholder="Ex: Apôtre Emmanuel Ngolo"
                      value={newOfficiant}
                      onChange={(e) => setNewOfficiant(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>

                  {/* Date */}
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-slate-600 block">Date de tenue *</label>
                    <input
                      type="date"
                      required
                      value={newDate}
                      onChange={(e) => setNewDate(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>

                  {/* Time */}
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-slate-600 block">Heure de début *</label>
                    <input
                      type="time"
                      required
                      value={newTime}
                      onChange={(e) => setNewTime(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>

                  {/* Scoped Entity hosting the event */}
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-slate-600 block">Juridiction Hôte</label>
                    <select
                      value={newEntityId}
                      onChange={(e) => setNewEntityId(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    >
                      {allowedFormEntities.map(ent => (
                        <option key={ent.id} value={ent.id}>{ent.name} ({ent.level})</option>
                      ))}
                    </select>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  {/* Location */}
                  <div className="md:col-span-1 space-y-1">
                    <label className="text-xs font-semibold text-slate-600 block">Lieu / Salle précise *</label>
                    <input
                      type="text"
                      required
                      placeholder="Ex: Sanctuaire principal"
                      value={newLocation}
                      onChange={(e) => setNewLocation(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>

                  {/* Description */}
                  <div className="md:col-span-2 space-y-1">
                    <label className="text-xs font-semibold text-slate-600 block">Description / Notes liturgiques</label>
                    <input
                      type="text"
                      placeholder="Précisions de tenue de l'activité, thèmes bibliques abordés, tenues d'office..."
                      value={newDescription}
                      onChange={(e) => setNewDescription(e.target.value)}
                      className="w-full text-xs rounded-lg border border-slate-200 p-2.5 outline-none focus:border-brand-blue/50 bg-slate-50"
                    />
                  </div>
                </div>

                <div className="flex justify-end gap-2 pt-2 border-t border-slate-100">
                  <button
                    type="button"
                    onClick={() => setShowAddForm(false)}
                    className="text-xs text-slate-500 hover:bg-slate-100 py-2 px-4 rounded-lg transition-colors cursor-pointer"
                  >
                    Annuler
                  </button>
                  <button
                    type="submit"
                    className="text-xs bg-brand-blue hover:bg-brand-blue-dark text-white font-bold py-2 px-5 rounded-lg shadow-sm transition-all cursor-pointer"
                  >
                    Valider et Enregistrer
                  </button>
                </div>
              </form>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Main Core Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Left Column: Calendar Grid or List View with Filters */}
        <div className="lg:col-span-2 space-y-5">
          
          {/* Quick Filter Bar */}
          <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-4 flex flex-col sm:flex-row items-center gap-3.5">
            <div className="relative flex-1 w-full">
              <Search className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
              <input
                type="text"
                placeholder="Rechercher par mot-clé, officiant, lieu..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full text-xs rounded-lg border border-slate-200 pl-9 pr-4 py-2 outline-none focus:border-brand-blue/50 bg-slate-50"
              />
            </div>

            <div className="flex items-center gap-2 w-full sm:w-auto overflow-x-auto shrink-0 pb-1 sm:pb-0">
              <span className="text-[10px] uppercase font-bold text-slate-400 shrink-0">Catégorie :</span>
              <button
                onClick={() => setSelectedType('ALL')}
                className={`px-2.5 py-1 text-[10px] font-bold rounded-full border shrink-0 transition-colors cursor-pointer ${
                  selectedType === 'ALL' 
                    ? 'bg-slate-800 text-white border-slate-800' 
                    : 'bg-white text-slate-600 border-slate-200 hover:bg-slate-50'
                }`}
              >
                Tous
              </button>
              {Object.entries(eventTypeLabels).map(([val, label]) => (
                <button
                  key={val}
                  onClick={() => setSelectedType(val)}
                  className={`px-2.5 py-1 text-[10px] font-bold rounded-full border shrink-0 transition-colors cursor-pointer ${
                    selectedType === val
                      ? 'bg-brand-blue text-white border-brand-blue shadow-sm'
                      : 'bg-white text-slate-600 border-slate-200 hover:bg-slate-50'
                  }`}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>

          {/* Calendar Rendering */}
          {viewMode === 'calendar' ? (
            <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5">
              {/* Calendar Month Header */}
              <div className="flex items-center justify-between pb-4 mb-4 border-b border-slate-100">
                <div className="flex items-center gap-2">
                  <CalendarDays className="h-5 w-5 text-brand-blue" />
                  <span className="font-extrabold text-slate-800 text-sm tracking-wide capitalize">
                    {currentDate.toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' })}
                  </span>
                </div>

                <div className="flex items-center gap-1">
                  <button
                    onClick={handlePrevMonth}
                    className="p-1.5 rounded-lg border border-slate-200 hover:bg-slate-50 text-slate-600 transition-colors cursor-pointer"
                  >
                    <ChevronLeft className="h-4 w-4" />
                  </button>
                  <button
                    onClick={() => setCurrentDate(new Date(2026, 6, 9))} // Back to default July 2026
                    className="text-[10px] font-bold border border-slate-200 py-1.5 px-3 rounded-lg hover:bg-slate-50 transition-all cursor-pointer"
                  >
                    Aujourd'hui
                  </button>
                  <button
                    onClick={handleNextMonth}
                    className="p-1.5 rounded-lg border border-slate-200 hover:bg-slate-50 text-slate-600 transition-colors cursor-pointer"
                  >
                    <ChevronRight className="h-4 w-4" />
                  </button>
                </div>
              </div>

              {/* Day headers */}
              <div className="grid grid-cols-7 gap-1.5 text-center mb-2">
                {['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'].map(day => (
                  <div key={day} className="text-[10px] uppercase font-bold text-slate-400 tracking-wider">
                    {day}
                  </div>
                ))}
              </div>

              {/* Grid Days */}
              <div className="grid grid-cols-7 gap-1.5">
                {calendarDays.map((dayObj) => {
                  const dayEvents = getEventsForDate(dayObj.date);
                  const isToday = dayObj.date.toDateString() === new Date(2026, 6, 9).toDateString(); // Simulated date
                  const isSelectedDay = selectedEvent && selectedEvent.date === dayObj.date.toISOString().split('T')[0];

                  return (
                    <div
                      key={dayObj.key}
                      onClick={() => {
                        if (dayEvents.length > 0) {
                          setSelectedEventId(dayEvents[0].id);
                        }
                      }}
                      className={`min-h-[70px] p-1.5 rounded-lg border flex flex-col justify-between transition-all relative ${
                        dayEvents.length > 0 ? 'cursor-pointer hover:border-brand-blue/50' : ''
                      } ${
                        dayObj.isCurrentMonth ? 'bg-white' : 'bg-slate-50/50 text-slate-300'
                      } ${
                        isToday ? 'ring-2 ring-brand-blue ring-offset-1 border-brand-blue' : 'border-slate-100'
                      } ${
                        isSelectedDay ? 'bg-brand-blue/5 border-brand-blue/30' : ''
                      }`}
                    >
                      <div className="flex items-center justify-between">
                        <span className={`text-xs font-bold ${
                          isToday ? 'text-brand-blue' : dayObj.isCurrentMonth ? 'text-slate-700' : 'text-slate-300'
                        }`}>
                          {dayObj.date.getDate()}
                        </span>
                        {isToday && (
                          <span className="h-1.5 w-1.5 rounded-full bg-brand-blue" />
                        )}
                      </div>

                      {/* Event dots/labels */}
                      <div className="space-y-1 mt-1">
                        {dayEvents.slice(0, 2).map(evt => (
                          <div
                            key={evt.id}
                            onClick={(e) => {
                              e.stopPropagation();
                              setSelectedEventId(evt.id);
                            }}
                            className={`text-[9px] font-bold px-1.5 py-0.5 rounded truncate flex items-center gap-1 ${
                              eventTypeColors[evt.type] ? `${eventTypeColors[evt.type].bg} ${eventTypeColors[evt.type].text}` : 'bg-slate-100 text-slate-700'
                            }`}
                            title={evt.title}
                          >
                            <span className={`h-1 w-1 rounded-full ${eventTypeColors[evt.type]?.dot || 'bg-slate-500'}`} />
                            {evt.title}
                          </div>
                        ))}
                        {dayEvents.length > 2 && (
                          <div className="text-[8px] font-bold text-slate-400 text-center">
                            +{dayEvents.length - 2} plus
                          </div>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          ) : (
            /* Upcoming Events List View */
            <div className="space-y-3.5">
              {filteredEvents.length === 0 ? (
                <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-10 text-center">
                  <CalendarDays className="h-8 w-8 text-slate-300 mx-auto mb-2" />
                  <p className="text-xs text-slate-400 font-bold">Aucune activité programmée correspondant aux critères de recherche.</p>
                </div>
              ) : (
                filteredEvents.map(evt => {
                  const isSelected = selectedEventId === evt.id;
                  const colors = eventTypeColors[evt.type];

                  return (
                    <div
                      key={evt.id}
                      onClick={() => setSelectedEventId(evt.id)}
                      className={`bg-white rounded-xl p-4 shadow-sm border transition-all cursor-pointer flex flex-col md:flex-row md:items-center justify-between gap-4 ${
                        isSelected ? 'border-brand-blue bg-brand-blue/[0.01] ring-1 ring-brand-blue/30' : 'border-slate-100 hover:border-slate-200'
                      }`}
                    >
                      <div className="flex items-start gap-4 flex-1 min-w-0">
                        {/* Event Icon/Badge */}
                        <div className={`p-3 rounded-xl border ${colors.bg} ${colors.text} ${colors.border} shrink-0`}>
                          <CalendarDays className="h-5 w-5" />
                        </div>

                        {/* Event texts */}
                        <div className="space-y-1.5 min-w-0">
                          <div className="flex items-center gap-2 flex-wrap">
                            <span className={`text-[9px] font-black uppercase px-2 py-0.5 rounded-full border shrink-0 ${colors.bg} ${colors.text} ${colors.border}`}>
                              {eventTypeLabels[evt.type]}
                            </span>
                            <div className="text-xs text-slate-400 font-mono flex items-center gap-1">
                              <Building className="h-3.5 w-3.5" />
                              {entities.find(e => e.id === evt.entityId)?.name || evt.entityId}
                            </div>
                          </div>

                          <h4 className="font-extrabold text-slate-800 text-sm truncate leading-snug">{evt.title}</h4>
                          <p className="text-xs text-slate-500 line-clamp-1">{evt.description}</p>
                        </div>
                      </div>

                      {/* Timing & Meta info */}
                      <div className="flex items-center md:flex-col items-end gap-3 md:gap-1.5 text-right shrink-0">
                        <div className="text-xs font-bold text-slate-800 flex items-center gap-1 bg-slate-50 border border-slate-100 py-1 px-2.5 rounded-lg">
                          <Clock className="h-3.5 w-3.5 text-slate-400" />
                          {evt.date} À {evt.time}
                        </div>
                        <div className="text-[10px] text-slate-500 font-semibold truncate flex items-center gap-1">
                          <User className="h-3.5 w-3.5 text-slate-400" />
                          Off: {evt.officiant}
                        </div>
                      </div>
                    </div>
                  );
                })
              )}
            </div>
          )}
        </div>

        {/* Right Column: Interactive Event Detail Panel + Member Availability Board */}
        <div className="space-y-5">
          {selectedEvent ? (
            <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col justify-between h-full">
              {/* Event Information Card */}
              <div className="space-y-5">
                <div className="pb-4 border-b border-slate-100 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className={`text-[9px] font-black uppercase px-2.5 py-0.5 rounded-full border ${
                      eventTypeColors[selectedEvent.type]?.bg
                    } ${eventTypeColors[selectedEvent.type]?.text} ${eventTypeColors[selectedEvent.type]?.border}`}>
                      {eventTypeLabels[selectedEvent.type]}
                    </span>

                    <span className="text-[10px] text-slate-400 font-mono">
                      ID: {selectedEvent.id}
                    </span>
                  </div>

                  <h3 className="font-extrabold text-slate-800 text-base leading-tight">
                    {selectedEvent.title}
                  </h3>
                </div>

                {/* Event Details list */}
                <div className="space-y-3 text-xs text-slate-600">
                  <div className="flex items-start gap-2.5">
                    <Clock className="h-4 w-4 text-slate-400 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-700">Date & Heure de tenue</p>
                      <p className="text-slate-500 mt-0.5">{selectedEvent.date} à {selectedEvent.time}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-2.5">
                    <MapPin className="h-4 w-4 text-slate-400 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-700">Lieu précis</p>
                      <p className="text-slate-500 mt-0.5">{selectedEvent.location}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-2.5">
                    <User className="h-4 w-4 text-slate-400 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-700">Officiant ou Animateur</p>
                      <p className="text-slate-500 mt-0.5">{selectedEvent.officiant}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-2.5 pt-1.5">
                    <Info className="h-4 w-4 text-slate-400 shrink-0 mt-0.5" />
                    <div>
                      <p className="font-bold text-slate-700">Notes pastorales</p>
                      <p className="text-slate-500 leading-normal mt-0.5">{selectedEvent.description || 'Aucune note liturgique disponible.'}</p>
                    </div>
                  </div>
                </div>

                {/* Availability Summary Stats */}
                <div className="pt-4 border-t border-slate-100 space-y-3">
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-bold text-slate-700 flex items-center gap-1.5">
                      <Users className="h-4 w-4 text-brand-blue" />
                      Statistiques de Présence
                    </span>
                    <span className="text-[10px] font-extrabold text-slate-400 bg-slate-50 px-2 py-0.5 rounded-full">
                      {scopedMembers.length} ciblés
                    </span>
                  </div>

                  <div className="grid grid-cols-4 gap-2 text-center">
                    <div className="bg-emerald-50 border border-emerald-100 rounded-lg p-2">
                      <p className="text-xs font-extrabold text-emerald-700">{availabilityStats.available}</p>
                      <p className="text-[9px] font-bold text-emerald-500 mt-0.5">Présents</p>
                    </div>
                    <div className="bg-red-50 border border-red-100 rounded-lg p-2">
                      <p className="text-xs font-extrabold text-red-700">{availabilityStats.unavailable}</p>
                      <p className="text-[9px] font-bold text-red-500 mt-0.5">Absents</p>
                    </div>
                    <div className="bg-amber-50 border border-amber-100 rounded-lg p-2">
                      <p className="text-xs font-extrabold text-amber-700">{availabilityStats.tentative}</p>
                      <p className="text-[9px] font-bold text-amber-500 mt-0.5">Incertains</p>
                    </div>
                    <div className="bg-slate-50 border border-slate-100 rounded-lg p-2">
                      <p className="text-xs font-extrabold text-slate-600">{availabilityStats.unknown}</p>
                      <p className="text-[9px] font-bold text-slate-400 mt-0.5">Inconnus</p>
                    </div>
                  </div>
                </div>

                {/* Member responses board */}
                <div className="pt-4 border-t border-slate-100 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold text-slate-700 flex items-center gap-1.5">
                      <ClipboardCheck className="h-4 w-4 text-brand-blue" />
                      Appel de Disponibilité
                    </span>
                    <p className="text-[9px] text-slate-400 font-semibold">Trier/Enregistrer les réponses</p>
                  </div>

                  {scopedMembers.length === 0 ? (
                    <div className="text-center p-4 bg-slate-50 rounded-lg border border-slate-100">
                      <p className="text-[11px] text-slate-400 font-semibold">Aucun membre enregistré dans ce périmètre ecclésiastique.</p>
                    </div>
                  ) : (
                    <div className="space-y-2 max-h-56 overflow-y-auto pr-1">
                      {scopedMembers.map((m) => {
                        const status = selectedEvent.availabilities?.[m.id];

                        return (
                          <div 
                            key={m.id} 
                            className="flex items-center justify-between p-2 rounded-lg border border-slate-50 bg-slate-50/50 hover:bg-slate-50 transition-all text-xs"
                          >
                            <div className="min-w-0">
                              <p className="font-extrabold text-slate-700 truncate">{m.firstName} {m.lastName}</p>
                              <p className="text-[9px] text-slate-400 truncate mt-0.5">{m.rank || 'Fidèle'}</p>
                            </div>

                            <div className="flex items-center gap-1">
                              {/* AVAILABLE */}
                              <button
                                onClick={() => handleSetAvailability(m.id, 'AVAILABLE')}
                                className={`p-1.5 rounded-md transition-all cursor-pointer ${
                                  status === 'AVAILABLE'
                                    ? 'bg-emerald-500 text-white shadow-sm'
                                    : 'bg-white text-slate-400 border border-slate-200 hover:text-emerald-500 hover:bg-emerald-50'
                                }`}
                                title="Disponible / Présent"
                              >
                                <Check className="h-3 w-3" />
                              </button>

                              {/* TENTATIVE */}
                              <button
                                onClick={() => handleSetAvailability(m.id, 'TENTATIVE')}
                                className={`p-1.5 rounded-md transition-all cursor-pointer ${
                                  status === 'TENTATIVE'
                                    ? 'bg-amber-500 text-white shadow-sm'
                                    : 'bg-white text-slate-400 border border-slate-200 hover:text-amber-500 hover:bg-amber-50'
                                }`}
                                title="Incertain / Sous réserve"
                              >
                                <AlertCircle className="h-3 w-3" />
                              </button>

                              {/* UNAVAILABLE */}
                              <button
                                onClick={() => handleSetAvailability(m.id, 'UNAVAILABLE')}
                                className={`p-1.5 rounded-md transition-all cursor-pointer ${
                                  status === 'UNAVAILABLE'
                                    ? 'bg-red-500 text-white shadow-sm'
                                    : 'bg-white text-slate-400 border border-slate-200 hover:text-red-500 hover:bg-red-50'
                                }`}
                                title="Indisponible / Absent"
                              >
                                <X className="h-3 w-3" />
                              </button>
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  )}
                </div>
              </div>
            </div>
          ) : (
            <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-8 text-center flex flex-col items-center justify-center">
              <CalendarDays className="h-10 w-10 text-slate-300 mb-3" />
              <h3 className="font-bold text-slate-800 text-sm">Aucun événement sélectionné</h3>
              <p className="text-xs text-slate-400 mt-1 max-w-xs mx-auto">
                Veuillez sélectionner un jour ou un événement dans la liste de gauche pour en voir les détails pastoraux et l'état de disponibilité.
              </p>
            </div>
          )}
        </div>

      </div>
    </div>
  );
}
