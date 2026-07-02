import 'package:ecclesiastes/services/file_service.dart';
import 'package:flutter/material.dart';
import '../config/organization_config.dart';
import '../models/library_document.dart';
import '../models/hierarchy_models.dart';
import '../services/library_service.dart';

class LibraryScreen extends StatefulWidget {
  final UserCategory userCategory;
  final EntityLevel userLevel;
  final CommissionType userCommission;
  final bool isSuperAdmin;
  
  const LibraryScreen({
    super.key,
    required this.userCategory,
    required this.userLevel,
    required this.userCommission,
    this.isSuperAdmin = false,
  });

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bibliothèque Officielle'),
        backgroundColor: const Color(0xFF003366),
        leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            )
          : null,
        bottom: TabBar(

          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Tous'),
            Tab(text: 'Pensées'),
            Tab(text: 'Manuels'),
            Tab(text: 'Programmes'),
            Tab(text: 'Formulaires'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          _buildStatistics(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDocumentsList(null), 
                _buildDocumentsList(DocumentType.penseesDirectrices),
                _buildDocumentsList(DocumentType.manuelCommission),
                _buildDocumentsList(null, filterProgrammes: true),
                _buildDocumentsList(DocumentType.formulaire),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un document...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _infoChip(
                  Icons.badge_outlined,
                  'Profil: ${_getCategoryLabel(widget.userCategory)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _infoChip(
                  Icons.account_tree_outlined,
                  'Niveau: ${_getLevelLabel(widget.userLevel)}',
                ),
              ),
            ],
          ),
          if (widget.userCommission != CommissionType.none) ...[
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text('Filtrer par commission: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(_getCommissionLabel(widget.userCommission)),
                    selected: true,
                    onSelected: (_) {},
                    backgroundColor: Colors.blue[50],
                    selectedColor: Colors.blue[200],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildStatistics() {
    final stats = LibraryService.getStatistics(
      category: widget.userCategory,
      level: widget.userLevel,
      commission: widget.userCommission,
      isSuperAdmin: widget.isSuperAdmin,
    );
    
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blue[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('📚 Total', stats['total']!.toString()),
          _buildStatItem('✝️ Pensées', stats['penseesDirectrices']!.toString()),
          _buildStatItem('📋 Manuels', stats['manuels']!.toString()),
          _buildStatItem('📅 Progr.', stats['programmes']!.toString()),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF003366)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
  
  Widget _buildDocumentsList(DocumentType? type, {bool filterProgrammes = false}) {
    List<LibraryDocument> documents;
    
    if (_searchQuery.isNotEmpty) {
      documents = LibraryService.search(
        query: _searchQuery,
        category: widget.userCategory,
        level: widget.userLevel,
        commission: widget.userCommission,
        isSuperAdmin: widget.isSuperAdmin,
      );
    } else if (filterProgrammes) {
      documents = LibraryService.getAccessibleDocuments(
        category: widget.userCategory,
        level: widget.userLevel,
        commission: widget.userCommission,
        isSuperAdmin: widget.isSuperAdmin,
      ).where((doc) => 
        doc.type == DocumentType.programmeCommission || 
        doc.type == DocumentType.programmeApostolique
      ).toList();
    } else if (type != null) {
      documents = LibraryService.getByType(
        type: type,
        category: widget.userCategory,
        level: widget.userLevel,
        commission: widget.userCommission,
        isSuperAdmin: widget.isSuperAdmin,
      );
    } else {
      documents = LibraryService.getAccessibleDocuments(
        category: widget.userCategory,
        level: widget.userLevel,
        commission: widget.userCommission,
        isSuperAdmin: widget.isSuperAdmin,
      );
    }
    
    if (documents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aucun document trouvé', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _buildDocumentCard(doc);
      },
    );
  }
  
  Widget _buildDocumentCard(LibraryDocument doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openDocument(doc),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getDocumentColor(doc.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getDocumentIcon(doc.type),
                  color: _getDocumentColor(doc.type),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc.description,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
            ],
          ),
        ),
      ),
    );
  }
  
  void _openDocument(LibraryDocument doc) async {
    // Si c'est un asset, on peut avoir besoin de le copier en cache pour open_filex
    // Mais ici on simule l'ouverture via FileService
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ouverture de: ${doc.title}...')),
    );
    await FileService.openFile(doc.filePath);
  }
  
  Color _getDocumentColor(DocumentType type) {
    switch (type) {
      case DocumentType.penseesDirectrices: return Colors.purple;
      case DocumentType.manuelCommission: return Colors.blue;
      case DocumentType.programmeApostolique: return Colors.red;
      case DocumentType.programmeCommission: return Colors.orange;
      case DocumentType.directives: return Colors.brown;
      case DocumentType.cantiques: return Colors.teal;
      case DocumentType.formulaire: return Colors.green;
      case DocumentType.liturgie: return Colors.indigo;
      case DocumentType.formation: return Colors.cyan;
      default: return Colors.grey;
    }
  }
  
  IconData _getDocumentIcon(DocumentType type) {
    switch (type) {
      case DocumentType.penseesDirectrices: return Icons.auto_stories;
      case DocumentType.manuelCommission: return Icons.menu_book;
      case DocumentType.programmeApostolique: return Icons.church;
      case DocumentType.programmeCommission: return Icons.calendar_month;
      case DocumentType.directives: return Icons.gavel;
      case DocumentType.cantiques: return Icons.music_note;
      case DocumentType.formulaire: return Icons.description;
      case DocumentType.liturgie: return Icons.book;
      case DocumentType.formation: return Icons.school;
      default: return Icons.insert_drive_file;
    }
  }
  
  String _getCommissionLabel(CommissionType commission) {
    return OrganizationConfig.getCommission(commission).name;
  }

  String _getCategoryLabel(UserCategory category) {
    switch (category) {
      case UserCategory.membre:
        return 'Membre';
      case UserCategory.ministre:
        return 'Ministre';
      case UserCategory.responsable:
        return 'Responsable';
    }
  }

  String _getLevelLabel(EntityLevel level) {
    switch (level) {
      case EntityLevel.communaute:
        return 'Communauté';
      case EntityLevel.district:
        return 'District';
      case EntityLevel.champ:
        return 'Champ';
      case EntityLevel.territoriale:
        return 'Territoriale';
      case EntityLevel.internationale:
        return 'Internationale';
    }
  }
}

