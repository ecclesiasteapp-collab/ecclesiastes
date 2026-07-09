import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/erp_providers.dart';
import '../../services/auth_service.dart';

class RecordOfferingForm extends ConsumerStatefulWidget {
  const RecordOfferingForm({super.key});

  @override
  ConsumerState<RecordOfferingForm> createState() => _RecordOfferingFormState();
}

class _RecordOfferingFormState extends ConsumerState<RecordOfferingForm> {
  final _amountController = TextEditingController();
  String _currency = 'FC';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisie d\'Offrande'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enregistrement des offrandes collectées lors du Service Divin.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Montant',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Devise :'),
            Row(
              children: [
                Radio<String>(
                  value: 'FC',
                  groupValue: _currency,
                  onChanged: (v) => setState(() => _currency = v!),
                ),
                const Text('Francs Congolais (FC)'),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'USD',
                  groupValue: _currency,
                  onChanged: (v) => setState(() => _currency = v!),
                ),
                const Text('Dollars US (\$)'),
              ],
            ),
            const Spacer(),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.security, color: Colors.green),
              title: Text('Opération Sécurisée'),
              subtitle: Text('Cette saisie créera un workflow de validation immédiat.'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('VALIDER ET SOUMETTRE'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un montant valide.'))
      );
      return;
    }

    final recordUseCase = ref.read(recordFinancialOfferingProvider);
    try {
      await recordUseCase.execute(
        entityId: AuthService.currentEntiteId,
        personId: AuthService.currentUserId,
        amount: amount,
        currency: _currency,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Offrande enregistrée et soumise pour validation.'))
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erreur : $e'))
        );
      }
    }
  }
}
