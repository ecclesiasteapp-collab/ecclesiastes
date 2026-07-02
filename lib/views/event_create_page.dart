import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/event_models.dart';
import '../services/auth_service.dart';
import '../services/database_helper.dart';

class EventCreatePage extends StatefulWidget {
  const EventCreatePage({super.key});

  @override
  State<EventCreatePage> createState() => _EventCreatePageState();
}

class _EventCreatePageState extends State<EventCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();
  final _responsibleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _expectedController = TextEditingController(text: '0');

  EventType _type = EventType.serviceDivin;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    if (user != null) {
      _responsibleController.text = user.fullName;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _responsibleController.dispose();
    _categoryController.dispose();
    _expectedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('dd/MM/yyyy').format(_selectedDate);
    final timeLabel = _selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un événement'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Titre requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Description requise'
                  : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<EventType>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Type d’événement',
                border: OutlineInputBorder(),
              ),
              items: EventType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _type = value ?? _type),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(dateLabel),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: const Text('Heure'),
              subtitle: Text(timeLabel),
              trailing: const Icon(Icons.schedule),
              onTap: _pickTime,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Lieu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _responsibleController,
              decoration: const InputDecoration(
                labelText: 'Responsable',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _expectedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Participants attendus',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveEvent,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
              ),
              child: const Text('ENREGISTRER L’ÉVÉNEMENT'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(() => _selectedDate = selected);
    }
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (selected != null) {
      setState(() => _selectedTime = selected);
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final event = Event(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _type,
      dateTime: dateTime,
      endDate: dateTime.add(const Duration(hours: 2)),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      responsiblePerson: _responsibleController.text.trim().isEmpty
          ? null
          : _responsibleController.text.trim(),
      category: _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
      time: _selectedTime.format(context),
    )..expectedParticipants = int.tryParse(_expectedController.text.trim()) ?? 0;

    await Hive.box<Event>('events_box').put(event.id, event);
    await DatabaseHelper.instance.insertEvenement({
      'id': event.id,
      'titre': event.title,
      'description': event.description,
      'date_debut': event.dateTime.toIso8601String(),
      'date_fin': event.endDate?.toIso8601String(),
      'lieu': event.location,
      'adresse': event.address,
      'responsable': event.responsiblePerson,
      'type': event.type.name,
      'categorie': event.category,
      'participants_prevus': event.expectedParticipants,
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Événement créé avec succès')),
    );
    context.go('/events');
  }
}

