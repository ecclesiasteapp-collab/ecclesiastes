# 🔍 ANALYSE TECHNIQUE & PRÉDICTION DES RISQUES FUTURS
**Application : Ecclésiastes (Flutter + Hive + PDF + Offline-First)**

---

## ✅ POINTS FORTS ACTUELS (Ce qui est solide)
1. **Architecture Offline-First** : Parfaitement adaptée aux contextes à connectivité instable (RDC, zones rurales).
2. **Conformité Directive v3** : Ordre liturgique verrouillé, secret pastoral §3.20.6 respecté, hiérarchie à 5 niveaux implémentée.
3. **Modularité Territoriale** : `TerritoryConfig` permet un déploiement multi-pays sans refonte.
4. **Sécurité de Base** : Chiffrement AES-256, verrouillage biométrique, RBAC fonctionnel.
5. **Documentation & Support** : Manuels, processus de tickets, chaîne YouTube, auto-répondeur professionnel déjà en place.

---

## ⚠️ PRÉDICTIONS DES PROBLÈMES FUTURS (Par Catégorie)

### 1. 🗄️ Architecture & Base de Données
| Risque Futur | Pourquoi | Impact |
|--------------|----------|--------|
| **Gonflement des Boîtes Hive** | Stocker des pièces jointes (5 Mo max) directement dans Hive. Les fichiers Hive sont monolithiques : >50 Mo = ouverture lente ou crash sur Android entrée de gamme. | 🟠 **Élevé** : L'application devient inutilisable après 6-12 mois d'usage intensif. |
| **Absence de Résolution de Conflits** | La `SyncQueue` envoie les données mais ne gère pas les modifications concurrentes (ex: 2 diacres modifient le même rapport). | 🟠 **Élevé** : Perte silencieuse de données pastorales ou financières. |

**🛡️ Mitigation** :
- Stocker les pièces jointes dans le système de fichiers (`path_provider`) et ne garder que le `chemin relatif` dans Hive.
- Implémenter une stratégie de conflit : `last-write-wins` avec horodatage + notification d'écrasement, ou verrouillage optimiste par `version` dans le modèle.

---

### 2. ⚡ Performance & Évolutivité
| Risque Futur | Pourquoi | Impact |
|--------------|----------|--------|
| **Génération PDF sur le Thread Principal** | Les rapports avec 98 lignes + signatures + affiches sont lourds. Flutter bloquera l'UI ou plantera (OOM) sur des téléphones <3 Go RAM. | 🟠 **Élevé** : Expérience utilisateur dégradée, abandon de l'app par les rapporteurs. |
| **Limitations Web (Chrome)** | `workmanager`, `local_auth`, `flutter_secure_storage` et l'accès au système de fichiers sont restreints ou simulés sur le Web. | 🟡 **Moyen** : Fonctionnalités clés désactivées ou buggy en mode Web, créant une divergence Mobile/Web. |
| **Requêtes Non Indexées** | À partir de ~2 000 membres/rapports, les recherches Hive (`where().toList()`) deviendront lentes sans indexation explicite. | 🟡 **Moyen** : Délais de chargement >5s, frustration des chefs de district. |

**🛡️ Mitigation** :
- Déplacer la génération PDF dans un **Isolate** (`compute()` ou `Isolate.spawn`) pour libérer le thread UI.
- Accepter que la version Web soit une **version "consultation légère"** et réserver les fonctions natives (biométrie, sync background, signatures) au mobile/desktop.
- Ajouter des index Hive (`@HiveIndex`) sur les champs de recherche fréquents (`memberId`, `date`, `status`).

---

### 3. 🔧 Maintenance & Dépendances
| Risque Futur | Pourquoi | Impact |
|--------------|----------|--------|
| **Fragilité du `build_runner`** | Chaque modification de modèle déclenche une régénération. Les caches corrompus (comme récemment) bloquent toute compilation. | 🔴 **Critique** : Temps perdu, frustration développeur, risque de livrer une version cassée. |
| **Dépréciations Flutter** | `Radio.groupValue`, `value` vs `initialValue`, `isInDebugMode`… Flutter évolue vite. Le code actuel contient déjà des warnings. | 🟡 **Moyen** : À la prochaine LTS Flutter, 30% du code devra être adapté sous peine de ne plus compiler. |
| **State Management Non Défini** | Si `setState` est utilisé sur 87 écrans, la maintenance deviendra ingérable et les bugs de rendu se multiplieront. | 🟠 **Élevé** : Code spaghetti, difficulté à onboarder un second développeur. |

**🛡️ Mitigation** :
- Pin les versions critiques dans `pubspec.yaml` (ex: `hive_generator: ^2.0.1`) et tester les mises à jour sur une branche `dependabot/updates`.
- Migrer progressivement vers **Riverpod** ou **Bloc** pour les écrans complexes (Dashboard, Rapports, Planning).
- Automatiser le `build_runner` dans un script `pre-commit` ou CI/CD pour détecter les erreurs avant merge.

---

### 4. 🔐 Conformité, Sécurité & Juridique
| Risque Futur | Pourquoi | Impact |
|--------------|----------|--------|
| **Perte de la Clé de Chiffrement** | `flutter_secure_storage` lie la clé au matériel. Si l'utilisateur change de téléphone ou réinstalle l'OS, les notes pastorales deviennent illisibles définitivement. | 🔴 **Critique** : Violation du §3.20.6, perte de confiance, risque juridique ecclésial. |
| **Absence de Politique de Rétention** | Aucune suppression automatique des données obsolètes (membres partis, rapports >5 ans). | 🟡 **Moyen** : Non-conformité RGPD/lois locales, base de données gonflée inutilement. |
| **Audit Log Incomplet** | Le modèle `AuditLog` existe mais n'est pas déclenché sur les accès aux notes confidentielles, modifications de rapports validés, ou changements de rôles. | 🟠 **Élevé** : Impossibilité de tracer une fuite ou une modification non autorisée. |

**🛡️ Mitigation** :
- Implémenter un **système de backup de clé** (export chiffré par mot de passe maître, ou QR code de récupération stocké hors-ligne).
- Ajouter un garbage collector : `if (report.date < DateTime.now().subtract(Duration(days: 1825))) archiveAndDelete()`.
- Instrumenter chaque action sensible avec `AuditLogService.log(action, userId, entityId, timestamp)`.

---

### 5. 📱 Expérience Utilisateur & Adoption
| Risque Futur | Pourquoi | Impact |
|--------------|----------|--------|
| **Courbe d'Apprentissage Raide** | 87 écrans, workflow à double validation, formulaires à 9 étapes. Les ministres âgés ou peu tech-savvy abandonneront. | 🟠 **Élevé** : Retour aux rapports papier, fragmentation des données. |
| **Indicateurs de Sync Absents** | L'utilisateur ne sait pas si un rapport est "en attente", "envoyé" ou "rejeté". | 🟡 **Moyen** : Duplication de saisie, conflits avec la hiérarchie. |
| **Textes Durcis (Hardcoded)** | Les libellés UI sont en français. La future i18n nécessitera de scanner 80+ fichiers. | 🟡 **Moyen** : Retard de 3-6 mois pour le déploiement multilingue. |

**🛡️ Mitigation** :
- Créer un **mode "Guide pas à pas"** (overlay `tutorial_coach_mark`) pour les 3 premières utilisations.
- Ajouter un badge de statut visuel sur chaque rapport : 🟡 `En attente`, 🟢 `Validé`, 🔴 `Rejeté`, 🔄 `Sync en cours`.
- Externaliser tous les textes dans `lib/l10n/app_fr.arb` dès maintenant, même si une seule langue est active.

---

## 📊 MATRICE DE PRIORISATION DES RISQUES

| Priorité | Risque | Délai Estimé | Action Requise |
|:---:|:---|:---|:---|
| 🔴 **Urgent** | Perte clé chiffrement | 0-3 mois | Migration mono-DB + Backup de clé |
| 🔴 **Urgent** | Fragilité `build_runner` / Cache corrompu | Immédiat | Script de réparation CI + Pin versions |
| 🟠 **Haute** | PDF sur thread principal / Sync conflits | 3-6 mois | `compute()` + Stratégie de versionnage |
| 🟡 **Moyenne** | State management / i18n hardcoded / Limites Web | 6-12 mois | Riverpod + ARB + Documentation Web |
| 🟢 **Basse** | Rétention données / Audit log partiel | 12+ month | GC automatique + Instrumentation |

---

## 🛡️ PLAN D'ACTION PRÉVENTIF (30 / 60 / 90 JOURS)

### 📅 Jours 1-30 : Stabilisation & Sécurité
- [x] Supprimer Isar. Uniformiser vers Hive.
- [ ] Implémenter `compute()` pour toutes les générations PDF.
- [x] Ajouter un mécanisme de backup/export de la clé AES-256.
- [ ] Remplacer tous les `print` par `debugPrint` + logger structuré.

### 📅 Jours 31-60 : Performance & Maintenance
- [ ] Migrer les écrans critiques vers Riverpod/Bloc.
- [ ] Indexer les champs de recherche Hive (`@HiveIndex`).
- [ ] Déplacer les pièces jointes >2 Mo vers `getApplicationDocumentsDirectory()` (ne garder que le path dans Hive).
- [ ] Configurer un workflow GitHub Actions qui lance `flutter pub get` + `build_runner` à chaque PR.

### 📅 Jours 61-90 : UX & Conformité
- [ ] Ajouter les statuts visuels de synchronisation dans l'UI.
- [ ] Externaliser les textes UI vers `arb` pour préparer l'i18n.
- [ ] Implémenter l'`AuditLog` sur les accès aux notes pastorales et validations.
- [ ] Créer un mode "Démo" ou "Guide interactif" pour les nouveaux conducteurs.

---

## 🎯 CONCLUSION

Votre application **Ecclésiastes** repose sur une base technique désormais simplifiée avec **Hive uniquement**. Cela garantit une meilleure compatibilité Web et une maintenance allégée.
