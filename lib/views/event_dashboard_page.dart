import 'package:ecclesiastes/services/image_service.dart';
import 'package:ecclesiastes/views/import_events_page.dart';
import 'package:flutter/material.dart';
import '../models/event_models.dart';
import '../services/announcement_service.dart';

class EventDashboardPage extends StatelessWidget {
  final List<Event> events; // À charger depuis Isar
  final AnnouncementService _syncService = AnnouncementService();

  EventDashboardPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda & Communication'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () async {
              final file = await ImageService.pickImage(context);
              if (file != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Image sélectionnée pour l\'annonce: ${file.name}'))
                );
              }
            },
            tooltip: 'Créer une annonce avec image',
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ImportEventsPage())),
            tooltip: 'Importer un programme (Tableau/Texte)',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, i) => _buildEventCard(context, events[i]),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: _getIcon(event.type),
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${event.dateTime.day}/${event.dateTime.month} à ${event.dateTime.hour}h'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.description),
                const Divider(),
                // Statistiques de participation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem('Prévus', '${event.expectedParticipants}'),
                    _statItem('Présents', '${event.actualParticipants}', color: Colors.green),
                    _statItem('Taux', '${_calcRate(event)}%', color: Colors.blue),
                  ],
                ),
                const SizedBox(height: 16),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.green),
                      onPressed: () => _syncService.shareOnWhatsApp(event),
                      tooltip: 'Partager sur WhatsApp',
                    ),
                    IconButton(
                      icon: const Icon(Icons.map, color: Colors.blue),
                      onPressed: () => _syncService.openInMaps(event),
                      tooltip: 'Ouvrir dans Maps',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_calendar),
                      onPressed: () => _editParticipation(context, event),
                      tooltip: 'Saisir participation',
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statItem(String label, String val, {Color? color}) => Column(
    children: [
      Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    ],
  );

  int _calcRate(Event e) {
    if (e.expectedParticipants == 0) return 0;
    return ((e.actualParticipants / e.expectedParticipants) * 100).toInt();
  }

  Icon _getIcon(EventType t) {
    switch(t) {
      case EventType.serviceDivin: return const Icon(Icons.church, color: Colors.blue);
      case EventType.ecodim: return const Icon(Icons.child_care, color: Colors.green);
      default: return const Icon(Icons.event);
    }
  }

  void _editParticipation(BuildContext context, Event event) {
    // Dialogue de saisie des statistiques
  }
}

