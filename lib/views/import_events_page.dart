import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/event_parser_service.dart';
import '../models/isar/event.dart';

class ImportEventsPage extends StatefulWidget {
  const ImportEventsPage({super.key});

  @override
  State<ImportEventsPage> createState() => _ImportEventsPageState();
}

class _ImportEventsPageState extends State<ImportEventsPage> {
  final TextEditingController _textController = TextEditingController();
  List<Event> _previewEvents = [];

  void _parse() {
    setState(() {
      _previewEvents = EventParserService.parseTextTable(_textController.text);
    });
  }

  Future<void> _save() async {
    final box = await Hive.openBox<Event>('events_box');
    for (var e in _previewEvents) {
      await box.put(e.id, e);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_previewEvents.length} événements importés avec succès !'))
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importer un Programme')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Collez ici votre tableau (Format: Date | Heure | Titre | Lieu | Officiant)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: '25/12/2025 | 10:00 | SD Noël | Cté Jérémie | Apôtre NGOLO',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _parse(),
            ),
            const SizedBox(height: 20),
            Text('${_previewEvents.length} événements détectés'),
            Expanded(
              child: ListView.builder(
                itemCount: _previewEvents.length,
                itemBuilder: (context, index) {
                  final e = _previewEvents[index];
                  return ListTile(
                    title: Text(e.title),
                    subtitle: Text('${e.time} - ${e.location}\n${e.responsiblePerson}'),
                    isThreeLine: true,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _previewEvents.isEmpty ? null : _save,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: const Text('VALIDER L\'IMPORTATION'),
            ),
          ],
        ),
      ),
    );
  }
}
