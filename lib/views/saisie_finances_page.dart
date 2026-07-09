import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/services/repository_providers.dart';
import 'package:ecclesiaste/domain/entities/finance/transaction.dart';
import 'package:uuid/uuid.dart';

class SaisieFinancesPage extends ConsumerStatefulWidget {
  const SaisieFinancesPage({super.key});

  @override
  ConsumerState<SaisieFinancesPage> createState() => _SaisieFinancesPageState();
}

class _SaisieFinancesPageState extends ConsumerState<SaisieFinancesPage> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _recuController = TextEditingController();
  
  TransactionType _typeTransaction = TransactionType.offering;
  String _devise = 'USD';
  DateTime _selectedDate = DateTime.now();

  final List<String> _devisesList = ['USD', 'FC', 'EUR'];

  void _enregistrer() async {
    if (_formKey.currentState!.validate()) {
      final user = AuthService.currentUser;
      final entiteId = user?.entityId ?? 'COMM_01';
      final repo = ref.read(financeRepositoryProvider);

      final transaction = FinanceTransaction(
        id: const Uuid().v4(),
        entityId: entiteId,
        personId: user?.id ?? 'ANONYMOUS',
        amount: double.parse(_montantController.text),
        currency: _devise,
        type: _typeTransaction,
        method: PaymentMethod.cash, // Par défaut dans ce formulaire simple
        date: _selectedDate,
        description: 'Reçu n° ${_recuController.text.trim()}',
      );

      await repo.recordTransaction(transaction);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opération financière enregistrée avec succès !')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saisie des Finances')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Type d'offrande
              DropdownButtonFormField<TransactionType>(
                value: _typeTransaction,
                decoration: const InputDecoration(
                  labelText: 'Type de Transaction',
                  border: OutlineInputBorder(),
                ),
                items: TransactionType.values.map((t) => DropdownMenuItem(
                  value: t, 
                  child: Text(t.name[0].toUpperCase() + t.name.substring(1))
                )).toList(),
                onChanged: (v) => setState(() => _typeTransaction = v!),
              ),
              const SizedBox(height: 20),

              // Montant
              TextFormField(
                controller: _montantController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Veuillez entrer un montant' : null,
              ),
              const SizedBox(height: 20),

              // Devise
              DropdownButtonFormField<String>(
                initialValue: _devise,
                decoration: const InputDecoration(
                  labelText: 'Devise',
                  border: OutlineInputBorder(),
                ),
                items: _devisesList.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setState(() => _devise = v!),
              ),
              const SizedBox(height: 20),

              // Numéro de reçu (Obligatoire selon vos specs)
              TextFormField(
                controller: _recuController,
                decoration: const InputDecoration(
                  labelText: 'Numéro du Reçu',
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Le numéro du reçu est obligatoire' : null,
              ),
              const SizedBox(height: 20),

              // Date de l'opération
              ListTile(
                title: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _enregistrer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('VALIDER L\'ENREGISTREMENT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _montantController.dispose();
    _recuController.dispose();
    super.dispose();
  }
}

