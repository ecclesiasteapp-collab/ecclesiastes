import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/erp_providers.dart';
import '../../providers/scope_provider.dart';
import '../../domain/entities/finance/transaction.dart';

class ERPFinanceDashboard extends ConsumerWidget {
  const ERPFinanceDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityId = ref.watch(activeEntityIdProvider);
    final repo = ref.watch(financeRepositoryProvider);
    final consolidate = ref.watch(consolidateFinanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion Financière"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/erp/finance/record'),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Soldes Actuels", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _BalanceCard(label: "Solde Consolidé (FC)", currency: "FC", futureBalance: consolidate.execute(rootEntityId: entityId, type: TransactionType.offering).then((m) => m['FC'] ?? 0.0))),
                const SizedBox(width: 16),
                Expanded(child: _BalanceCard(label: "Solde Consolidé (USD)", currency: "USD", futureBalance: consolidate.execute(rootEntityId: entityId, type: TransactionType.offering).then((m) => m['USD'] ?? 0.0))),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Dernières Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            FutureBuilder<List<FinanceTransaction>>(
              future: repo.getTransactionsForEntity(entityId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final txs = snapshot.data!;
                if (txs.isEmpty) return const Center(child: Text("Aucune transaction enregistrée."));

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: txs.length,
                  itemBuilder: (context, index) {
                    final tx = txs[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          tx.type == TransactionType.expense ? Icons.remove_circle_outline : Icons.add_circle_outline,
                          color: tx.type == TransactionType.expense ? Colors.red : Colors.green,
                        ),
                        title: Text("${tx.amount} ${tx.currency}"),
                        subtitle: Text("${tx.type.name.toUpperCase()} - ${tx.date.toString().split(' ')[0]}"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String label;
  final String currency;
  final Future<double> futureBalance;

  const _BalanceCard({required this.label, required this.currency, required this.futureBalance});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: futureBalance,
      builder: (context, snapshot) {
        return Card(
          elevation: 4,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  "${snapshot.data ?? 0.0} $currency",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
