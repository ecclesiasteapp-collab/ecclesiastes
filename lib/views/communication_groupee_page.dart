import 'package:flutter/material.dart';

class CommunicationGroupeePage extends StatefulWidget {
  const CommunicationGroupeePage({super.key});

  @override
  State<CommunicationGroupeePage> createState() => _CommunicationGroupeePageState();
}

class _CommunicationGroupeePageState extends State<CommunicationGroupeePage> {
  final List<String> _selectedChannels = ['SMS'];
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Communication Groupée'),
        backgroundColor: const Color(0xFF1B6B9E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChannelSelector(),
            const SizedBox(height: 24),
            const Text('Destinataires', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E))),
            const SizedBox(height: 8),
            _buildRecipientChips(),
            const SizedBox(height: 24),
            const Text('Message', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E))),
            const SizedBox(height: 8),
            _buildMessageInput(),
            const SizedBox(height: 30),
            _buildSendButton(),
            const SizedBox(height: 40),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Canaux de diffusion', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E))),
        const SizedBox(height: 12),
        Row(
          children: [
            _channelChip('SMS', Icons.sms, Colors.green),
            const SizedBox(width: 8),
            _channelChip('In-App', Icons.notifications_active, Colors.blue),
            const SizedBox(width: 8),
            _channelChip('WhatsApp', Icons.chat, Colors.teal),
          ],
        ),
      ],
    );
  }

  Widget _channelChip(String label, IconData icon, Color color) {
    final bool isSelected = _selectedChannels.contains(label);
    return FilterChip(
      selected: isSelected,
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12)),
      avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : color),
      onSelected: (val) {
        setState(() {
          if (val) _selectedChannels.add(label);
          else _selectedChannels.remove(label);
        });
      },
      selectedColor: color,
      backgroundColor: Colors.grey.shade100,
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildRecipientChips() {
    return Wrap(
      spacing: 8,
      children: [
        Chip(label: const Text('Tous les membres (45)', style: TextStyle(fontSize: 11)), backgroundColor: Colors.blue.shade50),
        Chip(label: const Text('Parents uniquement', style: TextStyle(fontSize: 11)), backgroundColor: Colors.orange.shade50),
        const ActionChip(
          avatar: Icon(Icons.add, size: 14),
          label: Text('Filtrer', style: TextStyle(fontSize: 11)),
          onPressed: null,
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return TextField(
      controller: _messageController,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: 'Saisissez votre message ici...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildSendButton() {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message envoyé avec succès !')));
        Navigator.pop(context);
      },
      icon: const Icon(Icons.send, color: Colors.white),
      label: const Text('ENVOYER LE COMMUNIQUÉ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B6B9E),
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Derniers envois', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 12),
        _buildHistoryItem('Rappel réunion dimanche', 'Envoyé hier • 45 reçus'),
        _buildHistoryItem('Information Séminaire', 'Envoyé le 12/03 • 42 reçus'),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: const Icon(Icons.chevron_right, size: 16),
    );
  }
}
