#!/bin/bash

# Script de génération des écrans Ecclésiaste
# Évite les doublons en vérifiant si le fichier existe déjà.

if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Erreur: Ce script doit être exécuté à la racine du projet (là où se trouve pubspec.yaml)."
    exit 1
fi

create_screen() {
    local dir=$1
    local filename=$2
    local classname=$3
    local filepath="lib/views/$dir/$filename.dart"

    # ✅ VÉRIFICATION DES DOUBLONS
    if [ -f "$filepath" ]; then
        echo "⏭️  Ignoré (existe déjà): $filepath"
        return
    fi

    # Création du dossier si nécessaire
    mkdir -p "lib/views/$dir"

    # Génération du code Dart de base
    cat << EOF > "$filepath"
import 'package:flutter/material.dart';

class $classname extends StatelessWidget {
  final String? commissionName;
  const $classname({super.key, this.commissionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: Text('$classname'),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              '$classname',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Page en construction', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
EOF
    echo "✅ Créé: $filepath"
}

echo " Démarrage de la génération des écrans Ecclésiaste..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. AUTHENTIFICATION
create_screen "auth" "login_page.dart" "LoginPage"
create_screen "auth" "register_page.dart" "RegisterPage"
create_screen "auth" "forgot_password_page.dart" "ForgotPasswordPage"
create_screen "auth" "legal_disclaimer_page.dart" "LegalDisclaimerPage"
create_screen "auth" "biometric_lock_page.dart" "BiometricLockPage"

# 2. DASHBOARDS
create_screen "dashboards" "main_dashboard.dart" "MainDashboard"
create_screen "dashboards" "district_dashboard.dart" "DistrictDashboard"
create_screen "dashboards" "community_dashboard.dart" "CommunityDashboard"
create_screen "dashboards" "commission_dashboard.dart" "CommissionDashboard"
create_screen "dashboards" "member_dashboard.dart" "MemberDashboard"

# 3. GESTION DES MEMBRES
create_screen "members" "member_list_page.dart" "MemberListPage"
create_screen "members" "member_detail_page.dart" "MemberDetailPage"
create_screen "members" "member_registration_page.dart" "MemberRegistrationPage"
create_screen "members" "member_edit_page.dart" "MemberEditPage"
create_screen "members" "member_transfer_page.dart" "MemberTransferPage"
create_screen "members" "member_history_page.dart" "MemberHistoryPage"
create_screen "members" "member_search_page.dart" "MemberSearchPage"
create_screen "members" "member_qr_page.dart" "MemberQrPage"

# 4. RAPPORTS OFFICIELS
create_screen "reports" "report_create_page.dart" "ReportCreatePage"
create_screen "reports" "service_divin_report.dart" "ServiceDivinReport"
create_screen "reports" "sacristy_report.dart" "SacristyReport"
create_screen "reports" "funerals_report.dart" "FuneralsReport"
create_screen "reports" "fundraising_report.dart" "FundraisingReport"
create_screen "reports" "report_validation_page.dart" "ReportValidationPage"
create_screen "reports" "report_pdf_preview.dart" "ReportPdfPreview"
create_screen "reports" "report_archive_page.dart" "ReportArchivePage"
create_screen "reports" "report_export_page.dart" "ReportExportPage"
create_screen "reports" "report_comparison_page.dart" "ReportComparisonPage"
create_screen "reports" "report_detail_page.dart" "ReportDetailPage"

# 5. ANNONCES & ACTUALITÉS
create_screen "announcements" "announcements_list_page.dart" "AnnouncementsListPage"
create_screen "announcements" "announcement_create_page.dart" "AnnouncementCreatePage"
create_screen "announcements" "announcement_detail_page.dart" "AnnouncementDetailPage"
create_screen "announcements" "announcement_edit_page.dart" "AnnouncementEditPage"
create_screen "announcements" "announcement_publish_page.dart" "AnnouncementPublishPage"
create_screen "announcements" "announcement_share_page.dart" "AnnouncementSharePage"

# 6. BIBLIOTHÈQUE & BIBLE
create_screen "library" "library_home_page.dart" "LibraryHomePage"
create_screen "library" "cantiques_list_page.dart" "CantiquesListPage"
create_screen "library" "cantique_detail_page.dart" "CantiqueDetailPage"
create_screen "library" "catechism_lessons_page.dart" "CatechismLessonsPage"
create_screen "library" "pensee_directrice_page.dart" "PenseeDirectricePage"
create_screen "library" "liturgie_page.dart" "LiturgiePage"
create_screen "library" "programmes_page.dart" "ProgrammesPage"
create_screen "library" "formations_page.dart" "FormationsPage"
create_screen "library" "bible_books_page.dart" "BibleBooksPage"
create_screen "library" "bible_reader_page.dart" "BibleReaderPage"

echo "🎉 Génération terminée !"