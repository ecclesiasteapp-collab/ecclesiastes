import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/views/saisie_programme_page.dart';
import 'package:intl/intl.dart';

class CalendrierPage extends StatefulWidget {
  const CalendrierPage({super.key});

  @override
  State<CalendrierPage> createState() => _CalendrierPageState();
}

class _CalendrierPageState extends State<CalendrierPage> {
  List<Appointment> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final db = DatabaseHelper.instance;
    final allEvents = await db.getEvenements();
    final allAnnivs = await db.getAnniversairesDuJour();

    final List<Appointment> meetings = [];

    for (var e in allEvents) {
      final DateTime start = DateTime.parse(e['date_debut'] ?? e['date_evenement'] ?? DateTime.now().toIso8601String());
      final DateTime end = e['date_fin'] != null ? DateTime.parse(e['date_fin']) : start.add(const Duration(hours: 1));
      
      meetings.add(Appointment(
        startTime: start,
        endTime: end,
        subject: e['titre'] ?? 'Sans titre',
        notes: e['description'],
        color: _getEventColor(e['type']),
      ));
    }

    for (var a in allAnnivs) {
      // Pour les anniversaires, on les met sur toute la journée
      final DateTime now = DateTime.now();
      final String dateAnnivStr = a['date_naissance'] ?? '';
      if (dateAnnivStr.isNotEmpty) {
        final DateTime birthDate = DateTime.parse(dateAnnivStr);
        final DateTime annivThisYear = DateTime(now.year, birthDate.month, birthDate.day);
        
        meetings.add(Appointment(
          startTime: annivThisYear,
          endTime: annivThisYear.add(const Duration(hours: 23, minutes: 59)),
          subject: "🎂 ${a['nom']} ${a['prenom']}",
          isAllDay: true,
          color: Colors.pink,
        ));
      }
    }

    if (mounted) {
      setState(() {
        _appointments = meetings;
        _isLoading = false;
      });
    }
  }

  Color _getEventColor(String? type) {
    switch (type) {
      case 'SD': return Colors.blue;
      case 'REUNION': return Colors.orange;
      case 'ECODIM': return Colors.green;
      case 'JEUNESSE': return Colors.purple;
      default: return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier & Programmes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SfCalendar(
            view: CalendarView.month,
            dataSource: MeetingDataSource(_appointments),
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            ),
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.appointment) {
                // Gérer le clic sur un événement (modification)
                final Appointment app = details.appointments![0];
                _showEventDetails(app);
              }
            },
          ),
      floatingActionButton: AuthService.isResponsable()
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SaisieProgrammePage()),
                ).then((_) => _loadData());
              },
              backgroundColor: const Color(0xFF003366),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  void _showEventDetails(Appointment app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(app.subject),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Début : ${DateFormat('dd/MM/yyyy HH:mm').format(app.startTime)}"),
            Text("Fin : ${DateFormat('dd/MM/yyyy HH:mm').format(app.endTime)}"),
            const SizedBox(height: 10),
            Text(app.notes ?? 'Aucune description'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
          if (AuthService.isResponsable())
            TextButton(
              onPressed: () {
                // Logique de modification
                Navigator.pop(context);
              }, 
              child: const Text('Modifier')
            ),
        ],
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

