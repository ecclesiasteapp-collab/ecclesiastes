import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/member_profile.dart';
import '../services/database_helper.dart';
import '../services/logging_service.dart';

class MemberTransferPage extends StatefulWidget {
  final String memberId;
  const MemberTransferPage({super.key, required this.memberId});

  @override
  State<MemberTransferPage> createState() => _MemberTransferPageState();
}

class _MemberTransferPageState extends State<MemberTransferPage> {
  final _formKey = GlobalKey<FormState>();
  late MemberProfile _member;
  bool _isLoading = true;

  String? _selectedTerritorial;
  String? _selectedChamp;
  String? _selectedDistrict;
  String? _selectedCommunaute;

  List<Map<String, dynamic>> _territorials = [];
  List<Map<String, dynamic>> _champs = [];
  List<Map<String, dynamic>> _districts = [];
  List<Map<String, dynamic>> _communautes = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final box = Hive.box<MemberProfile>('member_profiles');
    _member = box.get(widget.memberId)!;

    final db = DatabaseHelper.instance;
    _territorials = await db.getEglisesTerritoriales();

    setState(() => _isLoading = false);
  }

  Future<void> _onTerritorialChanged(String? value) async {
    setState(() {
      _selectedTerritorial = value;
      _selectedChamp = null;
      _selectedDistrict = null;
      _selectedCommunaute = null;
      _champs = [];
      _districts = [];
      _communautes = [];
    });
    if (value != null) {
      final data = await DatabaseHelper.instance.getChampsApostoliques(value);
      setState(() => _champs = data);
    }
  }

  Future<void> _onChampChanged(String? value) async {
    setState(() {
      _selectedChamp = value;
      _selectedDistrict = null;
      _selectedCommunaute = null;
      _districts = [];
      _communautes = [];
    });
    if (value != null) {
      final data = await DatabaseHelper.instance.getDistricts(champId: value);
      setState(() => _districts = data);
    }
  }

  Future<void> _onDistrictChanged(String? value) async {
    setState(() {
      _selectedDistrict = value;
      _selectedCommunaute = null;
      _communautes = [];
    });
    if (value != null) {
      final data = await DatabaseHelper.instance.getCommunautesByDistrict(value);
      setState(() => _communautes = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transférer le membre'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMemberSummary(),
              const SizedBox(height: 24),
              const Text('DESTINATION DU TRANSFERT', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
              const SizedBox(height: 16),

              _buildDropdown('Église Territoriale', _territorials, _selectedTerritorial, _onTerritorialChanged),
              _buildDropdown('Champ Apostolique', _champs, _selectedChamp, _onChampChanged),
              _buildDropdown('District', _districts, _selectedDistrict, _onDistrictChanged),
              _buildDropdown('Communauté de destination', _communautes, _selectedCommunaute, (v) => setState(() => _selectedCommunaute = v)),

              const SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Motif du transfert',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Déménagement, Raisons professionnelles...',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Veuillez saisir un motif' : null,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _performTransfer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('CONFIRMER LE TRANSFERT', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: const Color(0xFF003366), child: Text(_member.nom[0])),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_member.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Actuel: ${_member.communauteId}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<Map<String, dynamic>> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: items.map((e) => DropdownMenuItem<String>(value: e['id'].toString(), child: Text(e['nom']))).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Champ obligatoire' : null,
      ),
    );
  }

  Future<void> _performTransfer() async {
    if (_formKey.currentState!.validate()) {
      try {
        _member.egliseTerritorialeId = _selectedTerritorial!;
        _member.champApostoliqueId = _selectedChamp;
        _member.districtId = _selectedDistrict!;
        _member.communauteId = _selectedCommunaute!;
        _member.statutMembre = MemberStatus.transfert;
        _member.communauteOrigine = _member.communauteId;

        await _member.save();

        LoggingService.info('Transfert réussi pour ${_member.fullName}');

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Le transfert a été effectué avec succès.')));
        context.go('/members');
      } catch (e) {
        LoggingService.error('Erreur lors du transfert', e);
      }
    }
  }
}

