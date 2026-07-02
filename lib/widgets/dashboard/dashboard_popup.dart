import 'package:flutter/material.dart';
import 'package:ecclesiastes/utils/constants.dart';

// ─── PALETTE ──────────────────────────────────────────────────────────────────
const _bg     = Color(0xFF1E3A5F);
const _card   = Color(0xFF2A4A6F);
const _accent = Color(0xFF3A7AB8);

/// Popup de bienvenue affiché au démarrage du dashboard.
///
/// - [isGodMode] : Si true, affiche le bloc de stats globales (Super Admin).
/// - [totalMembres] : Nombre de membres actifs dans le périmètre.
/// - [totalMinistres] : Nombre de ministres actifs dans le périmètre.
/// - [pending] : Inscriptions en attente de validation.
/// - [tauxParticipation] : Taux de participation (0–100).
/// - [onClose] : Callback de fermeture.
/// - [onViewAll] : God Mode uniquement — bouton "Voir tout le champ".
class DashboardWelcomePopup extends StatelessWidget {
  final bool isGodMode;
  final int totalMembres;
  final int totalMinistres;
  final int pending;
  final int tauxParticipation;
  final VoidCallback onClose;
  final VoidCallback? onViewAll;

  const DashboardWelcomePopup({
    super.key,
    this.isGodMode = false,
    required this.totalMembres,
    required this.totalMinistres,
    required this.pending,
    this.tauxParticipation = 0,
    required this.onClose,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.55),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {}, // Empêche la fermeture au tap sur la card
          child: Container(
            width: 380,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
              border: isGodMode
                  ? Border.all(color: Colors.amber.shade600, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── En-tête ─────────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isGodMode
                            ? Colors.amber.shade50
                            : _accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isGodMode ? Icons.bolt : Icons.dashboard_outlined,
                        color: isGodMode ? Colors.amber.shade700 : _bg,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isGodMode
                            ? '⚡ Vue Globale — God Mode'
                            : 'Tableau de Bord Rapide',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onClose,
                      child: const Icon(Icons.close, color: Colors.black38, size: 20),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // ── Stat Ministres ───────────────────────────────────────
                _PopupStatRow(
                  icon: Icons.person_outline,
                  color: _accent,
                  title: 'Suivi des Ministres',
                  subtitle: '$totalMinistres ministre(s) actif(s) dans votre périmètre',
                ),
                const SizedBox(height: 12),

                // ── Stat Membres ─────────────────────────────────────────
                _PopupStatRow(
                  icon: Icons.people_outline,
                  color: Colors.green,
                  title: 'Membres Actifs',
                  subtitle:
                      '$totalMembres membres confirmés — Participation : $tauxParticipation%',
                ),
                const SizedBox(height: 12),

                // ── Stat Validations en attente ──────────────────────────
                _PopupStatRow(
                  icon: Icons.pending_actions_outlined,
                  color: Colors.orange,
                  title: 'Validations en attente',
                  subtitle: '$pending inscription(s) à valider',
                ),

                const Divider(height: 24),

                // ── Suivi rapide commissions ─────────────────────────────
                const Text(
                  'Suivi des Commissions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ..._buildMiniCommissions(),

                // ── God Mode : actions globales ──────────────────────────
                if (isGodMode && onViewAll != null) ...[
                  const Divider(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            onClose();
                            onViewAll!();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.amber.shade700, Colors.orange.shade600],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bolt, color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Voir tout le Champ KSO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 4),

                // ── Bouton Fermer ────────────────────────────────────────
                Center(
                  child: TextButton(
                    onPressed: onClose,
                    child: const Text(
                      'Accéder au tableau de bord',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMiniCommissions() {
    final all = AppConstants.commissionsDashboard;
    final shown = all.take(4).toList();
    return shown.map((c) {
      final pct = c['pct'] as int? ?? 0;
      final ok  = pct >= 50;
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${c['nom']} — $pct%',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (ok ? Colors.green : Colors.red).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                ok ? 'À jour' : 'En attente',
                style: TextStyle(
                  color: ok ? Colors.green : Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

// ─── LIGNE DE STATISTIQUE ─────────────────────────────────────────────────────
class _PopupStatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _PopupStatRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

