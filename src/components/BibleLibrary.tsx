import React, { useState, useEffect, useMemo } from 'react';
import { BookOpen, Search, Bookmark, Share2, Copy, Check, Info } from 'lucide-react';
import { BibleVerse } from '../types';
import { BIBLE_BOOKS_MOCK } from '../data';

export const BibleLibrary: React.FC = () => {
  const [verses, setVerses] = useState<BibleVerse[]>(BIBLE_BOOKS_MOCK);
  const [loading, setLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedBook, setSelectedBook] = useState('Tous');
  const [selectedChapter, setSelectedChapter] = useState<number | 'Tous'>('Tous');
  const [bookmarks, setBookmarks] = useState<string[]>(() => {
    const saved = localStorage.getItem('ecclesiaste_bible_bookmarks');
    return saved ? JSON.parse(saved) : [];
  });
  const [copiedId, setCopiedId] = useState<string | null>(null);
  const [sharedId, setSharedId] = useState<string | null>(null);

  // Load the complete Bible TOB if available
  useEffect(() => {
    const fetchBible = async () => {
      setLoading(true);
      try {
        const response = await fetch('/assets/librairie/bible_tob.json');
        if (response.ok) {
          const data = await response.json();
          // The JSON structure is hierarchical: an array of books, each with chapters, each with verses.
          if (Array.isArray(data)) {
            if (data.length > 0 && ('chapters' in data[0] || 'verses' in data[0])) {
              const flattened: BibleVerse[] = [];
              data.forEach((bookObj: any) => {
                if (bookObj.chapters && Array.isArray(bookObj.chapters)) {
                  bookObj.chapters.forEach((chapObj: any) => {
                    if (chapObj.verses && Array.isArray(chapObj.verses)) {
                      chapObj.verses.forEach((vObj: any) => {
                        flattened.push({
                          book: bookObj.name || bookObj.id || 'Inconnu',
                          chapter: chapObj.number || 1,
                          verse: vObj.number || 1,
                          text: vObj.text || '',
                          note: vObj.note
                        });
                      });
                    }
                  });
                }
              });
              setVerses(flattened);
            } else {
              setVerses(data);
            }
          } else if (data && typeof data === 'object' && Array.isArray(data.verses)) {
            setVerses(data.verses);
          } else if (data && typeof data === 'object') {
            console.warn('Format JSON inattendu pour la Bible, maintien du mock de secours.');
          }
        }
      } catch (e) {
        console.warn('Impossible de charger bible_tob.json, utilisation du mock de secours.', e);
      } finally {
        setLoading(false);
      }
    };
    fetchBible();
  }, []);

  // Save bookmarks to local storage
  useEffect(() => {
    localStorage.setItem('ecclesiaste_bible_bookmarks', JSON.stringify(bookmarks));
  }, [bookmarks]);

  // List of unique books
  const books = useMemo(() => {
    const set = new Set<string>();
    verses.forEach(v => {
      if (v && v.book) {
        set.add(v.book);
      }
    });
    return ['Tous', ...Array.from(set)];
  }, [verses]);

  // List of available chapters for selected book
  const chapters = useMemo(() => {
    if (selectedBook === 'Tous') return ['Tous'];
    const set = new Set<number>();
    verses.forEach(v => {
      if (v && v.book === selectedBook && typeof v.chapter === 'number') {
        set.add(v.chapter);
      }
    });
    return ['Tous', ...Array.from(set).sort((a, b) => a - b)];
  }, [verses, selectedBook]);

  // Reset selected chapter if selected book changes
  useEffect(() => {
    setSelectedChapter('Tous');
  }, [selectedBook]);

  // Filtered verses based on book, chapter, and search query
  const filteredVerses = useMemo(() => {
    return verses.filter(v => {
      const matchesBook = selectedBook === 'Tous' || v.book === selectedBook;
      const matchesChapter = selectedChapter === 'Tous' || v.chapter === selectedChapter;
      const matchesQuery = searchQuery === '' || 
        v.text.toLowerCase().includes(searchQuery.toLowerCase()) ||
        v.book.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesBook && matchesChapter && matchesQuery;
    });
  }, [verses, selectedBook, selectedChapter, searchQuery]);

  const toggleBookmark = (verseKey: string) => {
    setBookmarks(prev => 
      prev.includes(verseKey) ? prev.filter(k => k !== verseKey) : [...prev, verseKey]
    );
  };

  const getVerseKey = (v: BibleVerse) => {
    return `${v.book}_${v.chapter}_${v.verse}`;
  };

  const handleCopy = (v: BibleVerse) => {
    const key = getVerseKey(v);
    const quote = `"${v.text}" — ${v.book} ${v.chapter}:${v.verse}`;
    navigator.clipboard.writeText(quote);
    setCopiedId(key);
    setTimeout(() => setCopiedId(null), 2000);
  };

  const handleShareBrand = (v: BibleVerse) => {
    const key = getVerseKey(v);
    const brandQuote = `✨ Église Néo-Apostolique RDC Ouest ✨\n📖 Verset du Jour\n\n"${v.text}"\n— ${v.book} ${v.chapter}:${v.verse} (Traduction TOB)\n\n🕊️ Partagé via l'application Ecclesiaste.`;
    navigator.clipboard.writeText(brandQuote);
    setSharedId(key);
    setTimeout(() => setSharedId(null), 2500);
  };

  return (
    <div id="bible-library-module" className="space-y-6">
      {/* Intro details card */}
      <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="p-2.5 bg-brand-blue/10 text-brand-blue rounded-lg">
            <BookOpen className="h-6 w-6" />
          </div>
          <div>
            <h3 className="font-bold text-slate-800 text-base">Bibliothèque & Bible TOB</h3>
            <p className="text-xs text-slate-500 mt-1">
              Consultez la Bible de Traduction Œcuménique (TOB) et partagez les Saintes Écritures avec la signature officielle.
            </p>
          </div>
        </div>
        
        {loading && (
          <span className="text-xs text-slate-400 bg-slate-50 border border-slate-200 py-1.5 px-3 rounded-full flex items-center gap-1.5">
            <span className="h-2 w-2 rounded-full bg-brand-blue animate-ping" />
            Chargement de la base TOB...
          </span>
        )}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Navigation & Search Filters Column */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 space-y-4 lg:col-span-1 h-fit">
          <h4 className="font-bold text-slate-800 text-sm border-b border-slate-50 pb-2">Index Biblique</h4>

          {/* Search keyword */}
          <div>
            <label className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block mb-1">Mots-clés / Verset</label>
            <div className="relative">
              <Search className="absolute left-2.5 top-2.5 h-3.5 w-3.5 text-slate-400" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Ex: Commencement, berger..."
                className="w-full text-xs rounded-lg border border-slate-200 pl-8 pr-3 py-2 outline-none focus:border-brand-blue/50 bg-slate-50 font-medium"
              />
            </div>
          </div>

          {/* Book selector */}
          <div>
            <label className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block mb-1">Livre</label>
            <select
              value={selectedBook}
              onChange={(e) => setSelectedBook(e.target.value)}
              className="w-full text-xs rounded-lg border border-slate-200 p-2 outline-none focus:border-brand-blue/50 bg-slate-50 font-medium"
            >
              {books.map(b => (
                <option key={b} value={b}>{b}</option>
              ))}
            </select>
          </div>

          {/* Chapter selector */}
          <div>
            <label className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block mb-1">Chapitre</label>
            <select
              disabled={selectedBook === 'Tous'}
              value={selectedChapter}
              onChange={(e) => {
                const val = e.target.value;
                setSelectedChapter(val === 'Tous' ? 'Tous' : parseInt(val));
              }}
              className="w-full text-xs rounded-lg border border-slate-200 p-2 outline-none focus:border-brand-blue/50 bg-slate-50 font-medium disabled:opacity-50"
            >
              {chapters.map(c => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>
          </div>

          {/* Info on notes */}
          <div className="p-3 bg-blue-50/50 rounded-lg border border-blue-100 flex gap-2 text-[11px] text-slate-600">
            <Info className="h-4 w-4 text-brand-blue shrink-0 mt-0.5" />
            <div>
              <p className="font-semibold text-brand-blue">Notes Chiffrées</p>
              <p>Les versets de l'édition TOB incluent des renvois théologiques et des notes d'études pastorales.</p>
            </div>
          </div>
        </div>

        {/* Verses viewport Column */}
        <div className="lg:col-span-3 space-y-4">
          {/* Bookmarks bar */}
          {bookmarks.length > 0 && (
            <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-4">
              <h5 className="text-xs font-bold text-slate-500 uppercase tracking-wider flex items-center gap-1.5 mb-2.5">
                <Bookmark className="h-4 w-4 text-amber-500 fill-amber-500" />
                Mes Signets et Favoris ({bookmarks.length})
              </h5>
              <div className="flex flex-wrap gap-2">
                {bookmarks.map(key => {
                  const parts = key.split('_');
                  const ref = `${parts[0]} ${parts[1]}:${parts[2]}`;
                  return (
                    <button
                      key={key}
                      onClick={() => {
                        setSelectedBook(parts[0]);
                        setSelectedChapter(parseInt(parts[1]));
                      }}
                      className="text-[10px] bg-amber-50 border border-amber-200 text-amber-800 font-bold px-2.5 py-1 rounded-full hover:bg-amber-100 transition-colors flex items-center gap-1 cursor-pointer"
                    >
                      {ref}
                    </button>
                  );
                })}
              </div>
            </div>
          )}

          {/* Verses lists */}
          <div className="bg-white rounded-xl shadow-sm border border-slate-100 p-5 space-y-4">
            <div className="pb-3 border-b border-slate-100 flex items-center justify-between">
              <h4 className="font-bold text-slate-800 text-sm">
                {selectedBook === 'Tous' ? 'Toutes les Écritures' : `${selectedBook} ${selectedChapter !== 'Tous' ? `Chapitre ${selectedChapter}` : ''}`}
              </h4>
              <span className="text-[10px] font-bold text-slate-400 bg-slate-100 py-1 px-2.5 rounded-full">
                {filteredVerses.length} verset(s) trouvé(s)
              </span>
            </div>

            <div className="divide-y divide-slate-100 max-h-[500px] overflow-y-auto pr-2 space-y-3 pt-1">
              {filteredVerses.length === 0 ? (
                <div className="text-center py-10 text-slate-400">
                  <BookOpen className="h-10 w-10 mx-auto stroke-1" />
                  <p className="text-xs mt-2">Aucun verset ne correspond à votre index de recherche.</p>
                </div>
              ) : (
                filteredVerses.map((v, idx) => {
                  const key = getVerseKey(v);
                  const isBookmarked = bookmarks.includes(key);

                  return (
                    <div key={`${key}_${idx}`} className="py-4 first:pt-0 flex flex-col sm:flex-row sm:items-start gap-4 hover:bg-slate-50/50 rounded-lg p-2 transition-all">
                      <div className="shrink-0 font-bold text-xs text-brand-blue font-mono bg-brand-blue/5 px-2.5 py-1 rounded border border-brand-blue/10 h-fit self-start">
                        {v.book} {v.chapter}:{v.verse}
                      </div>

                      <div className="flex-1 space-y-2">
                        <p className="text-slate-800 text-sm font-medium leading-relaxed">
                          {v.text}
                        </p>
                        {v.note && (
                          <div className="text-[11px] text-slate-400 border-l-2 border-slate-200 pl-2.5 italic">
                            * Note : {v.note}
                          </div>
                        )}
                      </div>

                      <div className="flex items-center gap-1.5 self-end sm:self-start shrink-0">
                        {/* Bookmark Button */}
                        <button
                          onClick={() => toggleBookmark(key)}
                          title="Ajouter aux signets"
                          className={`p-1.5 rounded-lg border transition-all cursor-pointer ${
                            isBookmarked
                              ? 'bg-amber-50 border-amber-300 text-amber-500 hover:bg-amber-100'
                              : 'bg-slate-50 border-slate-200 text-slate-400 hover:text-slate-600 hover:bg-slate-100'
                          }`}
                        >
                          <Bookmark className={`h-3.5 w-3.5 ${isBookmarked ? 'fill-amber-500' : ''}`} />
                        </button>

                        {/* Copy Button */}
                        <button
                          onClick={() => handleCopy(v)}
                          title="Copier le verset"
                          className="p-1.5 rounded-lg border bg-slate-50 border-slate-200 text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-all cursor-pointer"
                        >
                          {copiedId === key ? <Check className="h-3.5 w-3.5 text-emerald-500" /> : <Copy className="h-3.5 w-3.5" />}
                        </button>

                        {/* Share Brand Button */}
                        <button
                          onClick={() => handleShareBrand(v)}
                          title="Partage brandé ENA RDC"
                          className="p-1.5 rounded-lg border bg-slate-50 border-slate-200 text-slate-400 hover:text-brand-blue hover:bg-brand-blue/5 transition-all cursor-pointer flex items-center gap-1"
                        >
                          {sharedId === key ? (
                            <>
                              <Check className="h-3.5 w-3.5 text-emerald-500" />
                              <span className="text-[9px] text-emerald-600 font-bold">Copié !</span>
                            </>
                          ) : (
                            <>
                              <Share2 className="h-3.5 w-3.5" />
                              <span className="text-[9px] text-slate-500 font-bold">Partage</span>
                            </>
                          )}
                        </button>
                      </div>
                    </div>
                  );
                })
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
