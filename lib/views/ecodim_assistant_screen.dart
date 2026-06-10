import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/ecodim_lesson.dart';

class EcodimAssistantScreen extends StatefulWidget {
  const EcodimAssistantScreen({super.key});

  @override
  State<EcodimAssistantScreen> createState() => _EcodimAssistantScreenState();
}

class _EcodimAssistantScreenState extends State<EcodimAssistantScreen> {
  late Box<EcodimLesson> _box;
  EcodimLesson? _nextLesson;
  final TextEditingController _resolutionCtrl = TextEditingController();
  int _attendance = 0;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<EcodimLesson>('eco_lessons');
    _loadNextLesson();
  }

  void _loadNextLesson() {
    final today = DateTime.now();
    final upcoming = _box.values.where((e) => e.date.isAfter(today)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    if (upcoming.isNotEmpty) setState(() => _nextLesson = upcoming.first);
  }

  @override
  Widget build(BuildContext context) {
    if (_nextLesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Assistant Moniteur')),
        body: const Center(child: Text('Aucune leçon prévue prochainement.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Assistant Moniteur Ecodim'), backgroundColor: const Color(0xFF003366)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. CARTE LEÇON OFFICIELLE
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(colors: [Color(0xFF003366), Color(0xFF005B9F)]),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('📅 Leçon du ${_nextLesson!.date.day}/${_nextLesson!.date.month}', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(_nextLesson!.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const Divider(color: Colors.white38),
                Text('📖 ${_nextLesson!.bibleText} (Pages ${_nextLesson!.pages})', style: const TextStyle(color: Colors.white)),
                if (_nextLesson!.estActiviteBallon) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8), 
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                    child: Text('🎈 ACTIVITÉ "VISEZ LE BUT" : ${_nextLesson!.themeApplication ?? ""}', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ]
              ]),
            ),
          ),
          const SizedBox(height: 24),

          // 2. SAISIE SIMPLIFIÉE
          Card(
            child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              Row(children: [
                const Icon(Icons.people, color: Colors.orange),
                const SizedBox(width: 12),
                const Expanded(child: Text('Enfants présents', style: TextStyle(fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.remove_circle, color: Colors.red), onPressed: () => setState(() { if (_attendance > 0) _attendance--; })),
                Text('$_attendance', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add_circle, color: Colors.green), onPressed: () => setState(() => _attendance++)),
              ]),
              const Divider(height: 30),
              const Align(alignment: Alignment.centerLeft, child: Text('🎯 Résolution "Moi aussi, je veux..."', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              TextField(
                controller: _resolutionCtrl, maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ex: Moi aussi, je veux prier tous les jours...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true, fillColor: Colors.grey[50],
                ),
              ),
            ])),
          ),
          const SizedBox(height: 24),

          // 3. BOUTON D'ACTION
          SizedBox(
            width: double.infinity, height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Rapport Ecodim envoyé au Resp. Communauté pour validation'), backgroundColor: Colors.green)
                );
              },
              icon: const Icon(Icons.check_circle, size: 24),
              label: const Text('VALIDER ET ENVOYER AU DISTRICT', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ],
      ),
    );
  }
}
