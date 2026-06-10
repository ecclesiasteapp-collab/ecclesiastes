import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/isar/event.dart';

class AnnouncementService {
  
  /// Génère un contenu formaté pour WhatsApp/Push
  String generateTemplate(Event event, {bool isWhatsApp = false}) {
    final emoji = _getEmoji(event.type);
    final buffer = StringBuffer();
    
    if (isWhatsApp) {
      buffer.writeln('🏛 *${event.title.toUpperCase()}*');
    } else {
      buffer.writeln('$emoji ${event.title}');
    }
    
    buffer.writeln('\n📅 Date : ${_formatDate(event.dateTime)}');
    buffer.writeln('⏰ Heure : ${_formatTime(event.dateTime)}');
    
    if (event.location != null) {
      buffer.writeln('📍 Lieu : ${event.location}');
    }
    
    buffer.writeln('\n${event.description}');
    
    if (isWhatsApp) {
      buffer.writeln('\n_Envoyé via l\'application Ecclesiastes_');
    }
    
    return buffer.toString();
  }

  /// Partage directement sur WhatsApp
  Future<void> shareOnWhatsApp(Event event) async {
    final text = Uri.encodeComponent(generateTemplate(event, isWhatsApp: true));
    final url = Uri.parse("whatsapp://send?text=$text");
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Utilisation de l'API moderne de share_plus
      await SharePlus.instance.share(ShareParams(text: generateTemplate(event)));
    }
  }

  /// Ouvre la localisation dans Google Maps
  Future<void> openInMaps(Event event) async {
    Uri url;
    if (event.latitude != null && event.longitude != null) {
      url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}");
    } else if (event.address != null) {
      url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(event.address!)}");
    } else {
      return;
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  String _getEmoji(EventType type) {
    switch (type) {
      case EventType.serviceDivin: return '🙏';
      case EventType.ecodim: return '👶';
      case EventType.jeunesse: return '🎯';
      case EventType.anniversaire: return '🎂';
      default: return '📅';
    }
  }

  String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";
  String _formatTime(DateTime d) => "${d.hour}:${d.minute.toString().padLeft(2, '0')}";
}
