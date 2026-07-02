import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecclesiastes/services/auth_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _hasAcceptedLegal = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final prefs = await SharedPreferences.getInstance();
    _hasAcceptedLegal = prefs.getBool('has_accepted_legal_terms') ?? false;

    await AuthService().getCurrentUser();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigate() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    if (!_hasAcceptedLegal) {
      context.go('/legal');
      return;
    }

    if (AuthService.currentUser == null) {
      context.go('/login');
      return;
    }

    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _navigate();
      }
    });

    return const Scaffold(
      body: SizedBox.shrink(),
    );
  }
}

