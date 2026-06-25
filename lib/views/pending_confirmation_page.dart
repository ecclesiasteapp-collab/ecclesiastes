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
      backgroundColor: const Color(0xFF003366),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icône d'attente
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.hourglass_empty,
                        size: 64,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Titre
                    const Text(
                      'Inscription en attente',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Message
                    Text(
                      'Votre demande d\'inscription a été envoyée avec succès',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Email
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.grey.shade600, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Entité
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.church, color: Colors.grey.shade600, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Communauté',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entityName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Délai d'attente
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 32,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Délai de validation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003366),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Le responsable de votre communauté validera votre inscription sous 3 à 4 jours ouvrables',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Instructions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Que faire maintenant ?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInstruction('1. Vérifiez régulièrement vos emails'),
                          _buildInstruction('2. Le responsable vous contactera pour confirmation'),
                          _buildInstruction('3. Une fois validé, vous pourrez vous connecter'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Boutons
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/welcome'),
                        icon: const Icon(Icons.home),
                        label: const Text(
                          'Retour à l\'accueil',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        // Support logic here
                      },
                      child: const Text(
                        'Besoin d\'aide ? Contactez-nous',
                        style: TextStyle(color: Color(0xFF003366)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
