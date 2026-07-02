import 'package:flutter/material.dart';

// ─── PALETTE ──────────────────────────────────────────────────────────────────
// const _bg   = Color(0xFF1E3A5F);
const _card = Color(0xFF2A4A6F);

/// Encart "Hub Réseaux" affiché dans le dashboard Responsable Entité.
/// [isGodMode] : Si true, affiche le bouton de gestion des liens (Super Admin).
class HubReseauxCard extends StatelessWidget {
  final bool isGodMode;
  final int notificationCount;

  const HubReseauxCard({
    super.key,
    this.isGodMode = false,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: isGodMode
            ? Border.all(color: Colors.amber.shade600, width: 1.5)
            : Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête ──────────────────────────────────────────────────────
          Row(
            children: [
              const Text(
                'Hub Réseaux',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (isGodMode)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '⚡ GOD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Icon(Icons.people, color: Colors.blue.shade300, size: 16),
            ],
          ),
          if (notificationCount > 0) ...[
            const SizedBox(height: 2),
            Text(
              '$notificationCount nouvelle(s) notification(s)',
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],

          const SizedBox(height: 12),

          // ── Icônes sociales ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SocialIcon(
                color: const Color(0xFF1877F2),
                label: 'f',
                badge: notificationCount > 0 ? notificationCount : null,
              ),
              const _SocialIcon(
                gradient: LinearGradient(
                  colors: [Color(0xFF833AB4), Color(0xFFE1306C), Color(0xFFF77737)],
                ),
                label: '📷',
              ),
              const _SocialIcon(
                color: Color(0xFFFF0000),
                label: '▶',
              ),
              const _SocialIcon(
                color: Color(0xFF607D8B),
                label: '📰',
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Derniers partages ────────────────────────────────────────────
          const Text(
            'Derniers Partages :',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          _ShareItem(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1877F2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('f',
                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
            text: 'FB : Galerie photos Journée de la Jeunesse KSO.',
          ),
          const SizedBox(height: 6),
          _ShareItem(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF833AB4), Color(0xFFF77737)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('📷', style: TextStyle(fontSize: 9)),
            ),
            text: "IG : Clips visite de l'Apôtre-Patriarche à KSO.",
          ),
          const SizedBox(height: 6),
          _ShareItem(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('▶', style: TextStyle(color: Colors.white, fontSize: 9)),
            ),
            text: 'YT : Service divin du Vendredi Saint KSO.',
          ),

          // ── Bouton Gérer (God Mode uniquement) ──────────────────────────
          if (isGodMode) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // TODO: Naviguer vers la gestion des liens sociaux
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amber.shade600),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings_outlined, color: Colors.amber, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Gérer les liens',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── ICÔNE SOCIALE ────────────────────────────────────────────────────────────
class _SocialIcon extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final String label;
  final int? badge;

  const _SocialIcon({
    this.color,
    this.gradient,
    required this.label,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: gradient == null ? color : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (badge != null)
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$badge',
                  style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── ITEM PARTAGE ─────────────────────────────────────────────────────────────
class _ShareItem extends StatelessWidget {
  final Widget icon;
  final String text;
  const _ShareItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white60, fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

