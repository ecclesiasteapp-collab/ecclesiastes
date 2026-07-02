# Description de l'Application : Ecclesiaste

## 1. Vision et Objectif
**Ecclesiaste** est une solution numérique de gestion ecclésiale conçue pour l'Église Néo-Apostolique. Elle vise à digitaliser la hiérarchie, la collecte des rapports d'activité, le suivi des membres et la diffusion des ressources spirituelles (Bible, manuels) au sein d'une structure territoriale complexe.

## 2. Caractéristiques Principales

### 2.1. Architecture Hiérarchique Multi-Entités (5 Niveaux)
L'application repose sur un modèle de données dynamique capable de représenter l'intégralité de la structure ecclésiale :
1.  **Internationale** (Racine unique)
2.  **Territoriale** (ex: RDC Ouest)
3.  **Champ** (Supervision apostolique)
4.  **District** (Regroupement de communautés)
5.  **Communauté** (Niveau local)
> *Cette structure permet un filtrage automatique des données et des rapports selon le périmètre (scope) de l'utilisateur connecté.*

### 2.2. Système de Rapports Universel
- **Moteur Dynamique** : Génération de rapports mensuels pour les 12 commissions (Ecodim, Jeunesse, Musique, etc.).
- **KPIs Automatisés** : Calcul en temps réel du taux de présence et suivi des engagements.
- **Flux de Transmission** : Circuit de validation hiérarchique intégré (du local vers le district/champ).

### 2.3. Interface et Expérience Utilisateur (UI/UX)
- **Dashboards Modulaires par Rôle** : L'écran d'accueil se métamorphose selon le profil :
    - *Dashboard Membre* : Focus sur la vie spirituelle, le calendrier personnel et les actualités locales.
    - *Dashboard Ministre* : Outils de statistiques pastorales, finances de l'entité et suivi des membres.
    - *Dashboard Responsable Commission* : Gestion des activités, programmes et transmission des rapports.
- **Système de Navigation "Boussole"** : Un fil d'Ariane permanent permettant de se situer instantanément dans les 5 niveaux hiérarchiques.
- **En-tête Officiel (HeaderOfficiel)** : Composant standardisé garantissant que chaque rapport respecte l'identité visuelle institutionnelle (Logo ENA, codes de commission).
- **Visualisation de Données** : Utilisation de graphiques avancés (fl_chart) pour représenter la progression mensuelle et le taux de présence.

### 2.4. Bibliothèque et Bibliothèque Spirituelle
- **Bible TOB Intégrée** : Version complète disponible hors-ligne avec recherche plein texte.
- **Notes Pastorales Sécurisées** : Système de prise de notes avec chiffrement AES pour garantir la confidentialité des réflexions ministérielles.
- **Gestion Documentaire** : Accès aux manuels de formation, pensées directrices et liturgie selon le profil (Ministre, Formateur, Membre).

### 2.5. Sécurité et Paramètres Avancés
- **Authentification Biométrique** : Support de Face ID et des empreintes digitales.
- **Mode Discret** : Fonctionnalité unique permettant de flouter les données sensibles (noms, chiffres) lors d'une utilisation en public.
- **Personnalisation** : Thèmes dynamiques, mode sombre et gestion granulaire des notifications (Push, SMS, Email).

## 3. Spécifications Techniques
- **Framework** : Flutter (Multiplateforme : Android, iOS, Web).
- **Base de Données** : Hive (NoSQL ultra-rapide avec persistance locale).
- **Navigation** : GoRouter (Navigation déclarative basée sur les rôles).
- **Compatibilité** : Isolation des services `dart:io` pour un fonctionnement fluide sur navigateur web.

## 4. Ce qui manque (Roadmap d'Amélioration)

### 4.1. Finalisation de la Logique Métier
- **Authentification 2FA** : L'interface est prête mais la logique d'envoi de codes reste à implémenter.
- **Export RGPD** : La fonction d'exportation des données personnelles en format JSON.
- **Sauvegarde Cloud** : Synchronisation automatique vers un serveur central.

### 4.2. Internationalisation et Accessibilité
- **Traductions Vernaculaires** : Compléter les fichiers de traduction (.arb) pour le Lingala, Swahili, etc.
- **Lecture Audio** : Intégration de la synthèse vocale (TTS) pour la Bible.

### 4.3. Automatisation Technique
- **Génération de Code** : Automatisation complète via `build_runner` pour les adaptateurs Hive.
- **Tests Automatisés** : Suite de tests unitaires pour valider les calculs statistiques.

---
*Document généré le 26 Juin 2026 - Version 1.1.0*
