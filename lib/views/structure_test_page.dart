import 'package:flutter/material.dart';
import '../services/data_loader_service.dart';
import '../models/church_structure.dart';

class StructureTestPage extends StatefulWidget {
  const StructureTestPage({super.key});
  @override
  State<StructureTestPage> createState() => _StructureTestPageState();
}

class _StructureTestPageState extends State<StructureTestPage> {
  List<MinistryRank> _ministries = [];
  List<Commission> _commissions = [];
  KsoYouthData? _youthData;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final ministries = await DataLoaderService.loadMinistries();
      final commissions = await DataLoaderService.loadCommissions();
      final youth = await DataLoaderService.loadKsoYouth();

      setState(() {
        _ministries = ministries;
        _commissions = commissions;
        _youthData = youth;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
          title: const Text('Vérification Structure Ecclésiaste'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Ministères'),
              Tab(text: 'Commissions'),
              Tab(text: 'KSO Youth'),
            ],
          ),
        ),
        body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
            ? Center(child: Text('Erreur: $_error'))
            : TabBarView(
                children: [
                  _buildMinistriesList(),
                  _buildCommissionsList(),
                  _buildKsoYouthList(),
                ],
              ),
      ),
    );
  }

  Widget _buildMinistriesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _ministries.length,
      itemBuilder: (context, index) {
        final m = _ministries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF003366),
              child: Text('${m.id}', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(m.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(m.code),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('RÔLE:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
                    Text(m.role),
                    const SizedBox(height: 12),
                    const Text('TÂCHES:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
                    ...m.taches.map((t) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('• $t'),
                    )),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommissionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _commissions.length,
      itemBuilder: (context, index) {
        final c = _commissions[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.group_work, color: Colors.orange),
            title: Text(c.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(c.description),
            trailing: c.sousCommissions != null
              ? const Icon(Icons.account_tree_outlined)
              : null,
          ),
        );
      },
    );
  }

  Widget _buildKsoYouthList() {
    if (_youthData == null) return const SizedBox.shrink();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Champ: ${_youthData!.champ}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        const Text('Coordination Centrale:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ..._youthData!.coordinationCentrale.map((c) => ListTile(
          dense: true,
          title: Text(c['nom']),
          subtitle: Text(c['fonction']),
          trailing: Text(c['tel']),
        )),
        const Divider(height: 40),
        const Text('Pools & Districts:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ..._youthData!.pools.map((pool) => ExpansionTile(
          title: Text(pool.nom, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
          children: pool.districts.map((d) => ExpansionTile(
            title: Text(d.nom),
            subtitle: Text('Resp: ${d.responsableMixte}'),
            children: d.communautes.map((com) => ListTile(
              title: Text(com.nom),
              subtitle: Text('Resp: ${com.resp} | Adj: ${com.adj}'),
            )).toList(),
          )).toList(),
        )),
      ],
    );
  }
}
