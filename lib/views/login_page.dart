import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _selectedNiveau;
  String? _selectedMinistere;
  String? _selectedRole;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.login(
        identifiant: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        context.go('/dashboard');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email ou mot de passe incorrect'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Logo circulaire bleu conforme à l'image
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF003366), width: 2),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/branding/logo_accueil.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, _, __) => const Icon(Icons.church, size: 80, color: Color(0xFF003366)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Bienvenue !',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connectez-vous à votre communauté',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Identifiant
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Identifiant ou Email',
                        prefixIcon: const Icon(Icons.alternate_email, color: Color(0xFF003366)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Mot de passe
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF003366)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Ligne Niveau / Ministère
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedNiveau,
                            decoration: InputDecoration(
                              hintText: 'Niveau',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'champ', child: Text('Champ')),
                              DropdownMenuItem(value: 'district', child: Text('District')),
                              DropdownMenuItem(value: 'communaute', child: Text('Communauté')),
                            ],
                            onChanged: (v) => setState(() => _selectedNiveau = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedMinistere,
                            decoration: InputDecoration(
                              hintText: 'Ministère',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'apotre', child: Text('Apôtre')),
                              DropdownMenuItem(value: 'eveque', child: Text('Évêque')),
                              DropdownMenuItem(value: 'pretre', child: Text('Prêtre')),
                            ],
                            onChanged: (v) => setState(() => _selectedMinistere = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Rôle
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: InputDecoration(
                        hintText: 'Rôle',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'responsable', child: Text('Responsable')),
                        DropdownMenuItem(value: 'suppleant', child: Text('Suppléant')),
                      ],
                      onChanged: (v) => setState(() => _selectedRole = v),
                    ),
                    const SizedBox(height: 32),

                    // Bouton Se connecter
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Se connecter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(height: 3, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFF003366), borderRadius: BorderRadius.circular(2))),

                    const SizedBox(height: 24),

                    // Liens
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => context.go('/forgot-password'),
                          child: const Text('Mot de passe oublié ?', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                        ),
                        const SizedBox(height: 30, child: VerticalDivider(color: Colors.grey)),
                        TextButton(
                          onPressed: () => context.go('/register'),
                          child: const Text('Créer un nouveau compte', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Footer
                    const Text(
                      'Découvrez notre plateforme unifiée pour l\'Église Néo-Apostolique. Apprenez comment gérer votre communauté.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

