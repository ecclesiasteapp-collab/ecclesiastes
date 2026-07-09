import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PendingConfirmationPage extends StatelessWidget {
  const PendingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération des arguments via GoRouter state extra ou settings.arguments
    // Pour GoRouter, on utilise souvent l'extra passé dans context.go(path, extra: ...)
    final Map<String, dynamic> args = (GoRouterState.of(context).extra as Map<String, dynamic>?) ?? {};
    final email = args['email'] as String? ?? '';
    final entityName = args['entityName'] as String? ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        elevation: 0,
        title: const Text('Admission Officielle', style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => AuthService.logout().then((_) => context.go('/')),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Logo ou Sceau de l'Église (Filigrane simulé)
              Opacity(
                opacity: 0.1,
                child: Icon(Icons.church, size: 100, color: const Color(0xFF003366)),
              ),
              const SizedBox(height: 20),

              // CARTE PRINCIPALE : STATUS ET PROGRESSION
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        "Dossier n° ENA-${DateTime.now().year}-PROV",
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Demande d'Admission",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "En cours de traitement par le secrétariat",
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),
                      
                      // BARRE DE PROGRESSION TEMPORELLE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Progression (3 à 4 jours)", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              const Text("25%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              value: 0.25,
                              minHeight: 10,
                              backgroundColor: Color(0xFFE0E0E0),
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Votre demande d'inscription pour la communauté $entityName est en cours de validation par le Responsable ou son Adjoint.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // SECTION SPIRITUELLE : ACCÈS BIBLE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF003366), Color(0xFF1B6B9E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.menu_book, color: Colors.white, size: 40),
                    const SizedBox(height: 12),
                    const Text(
                      "Nourriture Spirituelle",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "En attendant votre admission, la Bible TOB est à votre disposition gratuitement.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.push('/bible'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF003366),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("LIRE LA SAINTE BIBLE"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // BOUTONS D'ACTION ET CONTACT
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Action de contact secrétariat
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Contacter le Secrétariat'),
                            content: const Text('Pour toute urgence concernant votre dossier, veuillez contacter le bureau de votre district ou envoyer un message au service technique.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('FERMER')),
                              ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('ENVOYER MESSAGE')),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.support_agent),
                      label: const Text("SUPPORT"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home),
                      label: const Text("ACCUEIL"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              const Text(
                "© 2026 Église Néo-Apostolique - Système Ecclésiaste",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}

