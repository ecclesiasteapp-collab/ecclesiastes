import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecclesiaste/services/file_storage_service.dart';
import 'dart:typed_data';
import 'package:ecclesiaste/models/news_model.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/services/repository_providers.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class AnnoncesPage extends ConsumerStatefulWidget {
  const AnnoncesPage({super.key});

  @override
  ConsumerState<AnnoncesPage> createState() => _AnnoncesPageState();
}

class _AnnoncesPageState extends ConsumerState<AnnoncesPage> {
  List<News> _annonces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnonces();
  }

  Future<void> _fetchAnnonces() async {
    setState(() => _isLoading = true);
    final repo = ref.read(newsRepositoryProvider);
    final news = await repo.getAllNews();
    if (mounted) {
      setState(() {
        _annonces = news;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Annonces Officielles'),
        leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            )
          : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAnnonces,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _annonces.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _annonces.length,
                  itemBuilder: (context, index) {
                    final annonce = _annonces[index];
                    final attachment = annonce.posterAttachment;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: () => context.push('/announcements/detail/${annonce.id}', extra: annonce),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              if (attachment != null && attachment.isImage)
                                FutureBuilder<Uint8List?>(
                                  future: FileStorageService.readFile(attachment.relativePath),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                      return _buildHeroImage(snapshot.data!);
                                    } else if (snapshot.hasError) {
                                      return const Icon(Icons.error, size: 50, color: Colors.red);
                                    } else {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    annonce.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003366)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    annonce.content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '✍️ Admin',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(annonce.date),
                                        style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: AuthService.isResponsable()
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/announcements/create').then((_) => _fetchAnnonces()),
              label: const Text('Nouvelle Affiche'),
              icon: const Icon(Icons.add_photo_alternate_outlined),
              backgroundColor: const Color(0xFF003366),
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Aucune annonce officielle', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHeroImage(Uint8List data) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Image.memory(data, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image, size: 50)),
    );
  }
}

