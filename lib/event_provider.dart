import 'package:flutter/material.dart';
import 'models/event_models.dart';
import 'models/sacristy_report.dart';
import 'services/database_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Charger tous les événements
  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = DatabaseService.getAllEvents();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erreur chargement événements: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Créer un nouvel événement
  Future<bool> createEvent(Event event) async {
    try {
      await DatabaseService.insertEvent(event);
      await loadEvents();
      return true;
    } catch (e) {
      _errorMessage = 'Erreur création: $e';
      notifyListeners();
      return false;
    }
  }
}

/// Provider pour la gestion des rapports
class ReportProvider extends ChangeNotifier {
  List<SacristyReport> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SacristyReport> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Charger les rapports pour un événement
  Future<void> loadReportsByEvent(String eventId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reports = await DatabaseService.getSacristyReportsByEvent(eventId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erreur chargement rapports: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Créer un rapport
  Future<bool> createReport(SacristyReport report) async {
    try {
      await DatabaseService.insertSacristyReport(report);
      return true;
    } catch (e) {
      _errorMessage = 'Erreur création rapport: $e';
      notifyListeners();
      return false;
    }
  }
}

