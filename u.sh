#!/bin/bash
# ==============================================================================
# SCRIPT DE GÉNÉRATION AUTOMATIQUE - STRUCTURE ASSETS ECCLÉSIASTE
# ==============================================================================
# Application : Ecclésiaste (Église Néo-Apostolique RDC Ouest - Champ KSO)
# Auteur : Nestor Mbuyi
# Date : 2026
# ==============================================================================
# Ce script génère automatiquement la structure complète du dossier assets/
# avec les 5 niveaux hiérarchiques, 12 commissions, et catégories utilisateur.
# ==============================================================================

set -e  # Arrêter en cas d'erreur

# ==============================================================================
# CONFIGURATION
# ==============================================================================

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Dossier racine du projet (à adapter selon votre chemin)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS_DIR="$PROJECT_ROOT/assets"

# ==============================================================================
# DÉFINITION DES ENTITÉS (5 niveaux hiérarchiques)
# ==============================================================================

declare -a ENTITY_LEVELS=(
    "internationale"
    "territoriale"
    "champ"
    "district"
    "communaute"
)

# ==============================================================================
# LES 12 COMMISSIONS OFFICIELLES
# ==============================================================================

declare -a COMMISSIONS=(
    "ecodim"
    "confirmation"
    "jeunesse"
    "chorale_musique"
    "econfi"
    "medicale"
    "aines"
    "construction"
    "securite"
    "presse_media"
    "papas_mamans"
    "joseph_arimathee"
    "sacristie"
)

# ==============================================================================
# CATÉGORIES DE LA LIBRAIRIE
# ==============================================================================

declare -a LIBRARY_CATEGORIES=(
    "cantiques"
    "catechisme"
    "liturgie"
    "pensee_directrice"
    "programmes"
    "vision_eglise"
    "directives"
    "formations"
)

# ==============================================================================
# CATÉGORIES D'ANNONCES
# ==============================================================================

declare -a ANNOUNCEMENT_TYPES=(
    "officielles"
    "evenements"
    "urgences"
    "communique"
    "nominations"
    "retraites"
    "ordination"
    "mandatement"
)

# ==============================================================================
# FONCTIONS UTILITAIRES
# ==============================================================================

# Créer un dossier avec un fichier .gitkeep pour Git
create_dir() {
    local dir_path="$1"
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
        touch "$dir_path/.gitkeep"
        echo -e "  ${GREEN}✓${NC} $dir_path"
    else
        echo -e "  ${YELLOW}${NC} $dir_path (existe déjà)"
    fi
}

# Afficher un titre de section
section_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

# Afficher un sous-titre
subsection_header() {
    echo ""
    echo -e "${CYAN}── $1 ──${NC}"
}

# ==============================================================================
# GÉNÉRATION DE LA STRUCTURE
# ==============================================================================

echo -e "${GREEN}"
echo "═══════════════════════════════════════════════════════════╗"
echo "║  GÉNÉRATION DE LA STRUCTURE ASSETS - ECCLÉSIASTE         ║"
echo "║  Église Néo-Apostolique RDC Ouest - Champ KSO            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo "📍 Dossier racine : $PROJECT_ROOT"
echo "📁 Dossier assets : $ASSETS_DIR"
echo ""

# Vérifier si le dossier assets existe
if [ ! -d "$ASSETS_DIR" ]; then
    echo -e "${YELLOW}⚠️  Le dossier assets/ n'existe pas. Création...${NC}"
    mkdir -p "$ASSETS_DIR"
fi

# ==============================================================================
# 1. DOSSIER ANNONCES (Hiérarchique par niveau d'entité)
# ==============================================================================

section_header "1. ANNONCES PAR NIVEAU D'ENTITÉ"

for level in "${ENTITY_LEVELS[@]}"; do
    subsection_header "Niveau : $level"
    
    # Dossier principal du niveau
    create_dir "$ASSETS_DIR/annonces/$level"
    
    # Sous-dossiers pour chaque type d'annonce
    for type in "${ANNOUNCEMENT_TYPES[@]}"; do
        create_dir "$ASSETS_DIR/annonces/$level/$type"
    done
    
    # Dossier pour les affiches/images
    create_dir "$ASSETS_DIR/annonces/$level/affiches"
    
    # Dossier pour les archives (annonces anciennes)
    create_dir "$ASSETS_DIR/annonces/$level/archives"
    
    # Dossier pour les brouillons (en attente de validation)
    create_dir "$ASSETS_DIR/annonces/$level/brouillons"
done

# ==============================================================================
# 2. DOSSIER ENTITÉS & RESPONSABLES
# ==============================================================================

section_header "2. ENTITÉS & RESPONSABLES"

for level in "${ENTITY_LEVELS[@]}"; do
    subsection_header "Niveau : $level"
    
    # Dossier principal de l'entité
    create_dir "$ASSETS_DIR/entites/$level"
    
    # Dossier des responsables (photos, signatures, documents officiels)
    create_dir "$ASSETS_DIR/entites/$level/responsables"
    create_dir "$ASSETS_DIR/entites/$level/responsables/photos"
    create_dir "$ASSETS_DIR/entites/$level/responsables/signatures"
    create_dir "$ASSETS_DIR/entites/$level/responsables/documents_officiels"
    
    # Dossier de l'entité elle-même (logo, blason, documents)
    create_dir "$ASSETS_DIR/entites/$level/identite"
    create_dir "$ASSETS_DIR/entites/$level/identite/logos"
    create_dir "$ASSETS_DIR/entites/$level/identite/blasons"
    create_dir "$ASSETS_DIR/entites/$level/identite/documents"
    
    # Dossier des rapports officiels de l'entité
    create_dir "$ASSETS_DIR/entites/$level/rapports"
    create_dir "$ASSETS_DIR/entites/$level/rapports/annuels"
    create_dir "$ASSETS_DIR/entites/$level/rapports/mensuels"
    create_dir "$ASSETS_DIR/entites/$level/rapports/financiers"
    
    # Dossier des statistiques
    create_dir "$ASSETS_DIR/entites/$level/statistiques"
done

# ==============================================================================
# 3. DOSSIER MEMBRES (Par entité)
# ==============================================================================

section_header "3. MEMBRES PAR ENTITÉ"

for level in "${ENTITY_LEVELS[@]}"; do
    subsection_header "Niveau : $level"
    
    create_dir "$ASSETS_DIR/membres/$level"
    
    # Photos des membres
    create_dir "$ASSETS_DIR/membres/$level/photos"
    
    # Documents des membres (pièces d'identité, certificats)
    create_dir "$ASSETS_DIR/membres/$level/documents"
    create_dir "$ASSETS_DIR/membres/$level/documents/identite"
    create_dir "$ASSETS_DIR/membres/$level/documents/sacrements"
    create_dir "$ASSETS_DIR/membres/$level/documents/certificats"
    
    # Signatures des membres
    create_dir "$ASSETS_DIR/membres/$level/signatures"
    
    # Archives (membres décédés, transférés)
    create_dir "$ASSETS_DIR/membres/$level/archives"
done

# ==============================================================================
# 4. DOSSIER MINISTRES
# ==============================================================================

section_header "4. MINISTRES"

# Dossier principal ministres
create_dir "$ASSETS_DIR/ministres"

# Pensées directrices (lecture seule pour les ministres)
create_dir "$ASSETS_DIR/ministres/pensee_directrice"
create_dir "$ASSETS_DIR/ministres/pensee_directrice/2024"
create_dir "$ASSETS_DIR/ministres/pensee_directrice/2025"
create_dir "$ASSETS_DIR/ministres/pensee_directrice/2026"
create_dir "$ASSETS_DIR/ministres/pensee_directrice/archives"

# Directives officielles
create_dir "$ASSETS_DIR/ministres/directives"
create_dir "$ASSETS_DIR/ministres/directives/version_3"
create_dir "$ASSETS_DIR/ministres/directives/circulaires"
create_dir "$ASSETS_DIR/ministres/directives/notes_de_service"

# Formations des ministres
create_dir "$ASSETS_DIR/ministres/formations"
create_dir "$ASSETS_DIR/ministres/formations/nouveaux_ministres"
create_dir "$ASSETS_DIR/ministres/formations/continues"
create_dir "$ASSETS_DIR/ministres/formations/seminaires"

# Rapports des ministres
create_dir "$ASSETS_DIR/ministres/rapports"
create_dir "$ASSETS_DIR/ministres/rapports/activites"
create_dir "$ASSETS_DIR/ministres/rapports/visites"
create_dir "$ASSETS_DIR/ministres/rapports/pastoraux"

# Documents liturgiques
create_dir "$ASSETS_DIR/ministres/liturgie"
create_dir "$ASSETS_DIR/ministres/liturgie/ceremonies"
create_dir "$ASSETS_DIR/ministres/liturgie/prieres"
create_dir "$ASSETS_DIR/ministres/liturgie/rituels"
create_dir "$ASSETS_DIR/ministres/liturgie/textes_officiels"

# Photos et signatures des ministres
create_dir "$ASSETS_DIR/ministres/identite"
create_dir "$ASSETS_DIR/ministres/identite/photos_officielles"
create_dir "$ASSETS_DIR/ministres/identite/signatures"
create_dir "$ASSETS_DIR/ministres/identite/cartes_ministerielles"

# Mandatements et ordinations
create_dir "$ASSETS_DIR/ministres/mandatements"
create_dir "$ASSETS_DIR/ministres/ordinations"
create_dir "$ASSETS_DIR/ministres/retraites"

# ==============================================================================
# 5. DOSSIER COMMISSIONS (12 commissions × 5 niveaux d'entités)
# ==============================================================================

section_header "5. COMMISSIONS (12 × 5 niveaux = 65 dossiers)"

for level in "${ENTITY_LEVELS[@]}"; do
    subsection_header "Niveau : $level"
    
    for commission in "${COMMISSIONS[@]}"; do
        create_dir "$ASSETS_DIR/commissions/$level/$commission"
        
        # Sous-dossiers standards pour chaque commission
        create_dir "$ASSETS_DIR/commissions/$level/$commission/documents"
        create_dir "$ASSETS_DIR/commissions/$level/$commission/rapports"
        create_dir "$ASSETS_DIR/commissions/$level/$commission/reunions"
        create_dir "$ASSETS_DIR/commissions/$level/$commission/programmes"
        create_dir "$ASSETS_DIR/commissions/$level/$commission/membres"
        create_dir "$ASSETS_DIR/commissions/$level/$commission/archives"
    done
done

# ==============================================================================
# 6. DOSSIER LIBRAIRIE (Ressources partagées)
# ==============================================================================

section_header "6. LIBRAIRIE"

for category in "${LIBRARY_CATEGORIES[@]}"; do
    subsection_header "Catégorie : $category"
    
    create_dir "$ASSETS_DIR/librairie/$category"
    
    # Sous-dossiers spécifiques selon la catégorie
    case $category in
        "cantiques")
            create_dir "$ASSETS_DIR/librairie/$category/liturgiques"
            create_dir "$ASSETS_DIR/librairie/$category/jeunesse"
            create_dir "$ASSETS_DIR/librairie/$category/noel"
            create_dir "$ASSETS_DIR/librairie/$category/paques"
            create_dir "$ASSETS_DIR/librairie/$category/mariage"
            create_dir "$ASSETS_DIR/librairie/$category/funeraire"
            create_dir "$ASSETS_DIR/librairie/$category/partitions"
            create_dir "$ASSETS_DIR/librairie/$category/audio"
            ;;
        "catechisme")
            create_dir "$ASSETS_DIR/librairie/$category/debutants"
            create_dir "$ASSETS_DIR/librairie/$category/confirmation"
            create_dir "$ASSETS_DIR/librairie/$category/avances"
            create_dir "$ASSETS_DIR/librairie/$category/manuels"
            create_dir "$ASSETS_DIR/librairie/$category/exercices"
            create_dir "$ASSETS_DIR/librairie/$category/evaluations"
            ;;
        "liturgie")
            create_dir "$ASSETS_DIR/librairie/$category/ceremonies"
            create_dir "$ASSETS_DIR/librairie/$category/prieres"
            create_dir "$ASSETS_DIR/librairie/$category/rituels"
            create_dir "$ASSETS_DIR/librairie/$category/textes_officiels"
            create_dir "$ASSETS_DIR/librairie/$category/bapteme"
            create_dir "$ASSETS_DIR/librairie/$category/scelle"
            create_dir "$ASSETS_DIR/librairie/$category/mariage"
            create_dir "$ASSETS_DIR/librairie/$category/funeraire"
            ;;
        "pensee_directrice")
            create_dir "$ASSETS_DIR/librairie/$category/2024"
            create_dir "$ASSETS_DIR/librairie/$category/2025"
            create_dir "$ASSETS_DIR/librairie/$category/2026"
            create_dir "$ASSETS_DIR/librairie/$category/archives"
            create_dir "$ASSETS_DIR/librairie/$category/commentaires"
            ;;
        "programmes")
            # Programmes par niveau hiérarchique
            for level in "${ENTITY_LEVELS[@]}"; do
                create_dir "$ASSETS_DIR/librairie/$category/$level"
            done
            create_dir "$ASSETS_DIR/librairie/$category/templates"
            ;;
        "vision_eglise")
            create_dir "$ASSETS_DIR/librairie/$category/documents_officiels"
            create_dir "$ASSETS_DIR/librairie/$category/rapports_annuels"
            create_dir "$ASSETS_DIR/librairie/$category/strategie"
            create_dir "$ASSETS_DIR/librairie/$category/communication"
            ;;
        "directives")
            create_dir "$ASSETS_DIR/librairie/$category/version_actuelle"
            create_dir "$ASSETS_DIR/librairie/$category/versions_anterieures"
            create_dir "$ASSETS_DIR/librairie/$category/circulaires"
            create_dir "$ASSETS_DIR/librairie/$category/notes_service"
            ;;
        "formations")
            create_dir "$ASSETS_DIR/librairie/$category/ministres"
            create_dir "$ASSETS_DIR/librairie/$category/commissions"
            create_dir "$ASSETS_DIR/librairie/$category/membres"
            create_dir "$ASSETS_DIR/librairie/$category/videos"
            create_dir "$ASSETS_DIR/librairie/$category/presentations"
            ;;
    esac
done

# ==============================================================================
# 7. DOSSIER BIBLE
# ==============================================================================

section_header "7. BIBLE"

create_dir "$ASSETS_DIR/bibles"
create_dir "$ASSETS_DIR/bibles/tob"
create_dir "$ASSETS_DIR/bibles/tob/ancien_testament"
create_dir "$ASSETS_DIR/bibles/tob/nouveau_testament"
create_dir "$ASSETS_DIR/bibles/tob/psaumes"
create_dir "$ASSETS_DIR/bibles/tob/proverbes"
create_dir "$ASSETS_DIR/bibles/autres_versions"
create_dir "$ASSETS_DIR/bibles/commentaires"
create_dir "$ASSETS_DIR/bibles/concordances"

# ==============================================================================
# 8. DOSSIER LOGOS & IDENTITÉ VISUELLE
# ==============================================================================

section_header "8. LOGOS & IDENTITÉ VISUELLE"

create_dir "$ASSETS_DIR/logos"
create_dir "$ASSETS_DIR/logos/internationale"
create_dir "$ASSETS_DIR/logos/territoriale"
create_dir "$ASSETS_DIR/logos/champ"
create_dir "$ASSETS_DIR/logos/district"
create_dir "$ASSETS_DIR/logos/communaute"
create_dir "$ASSETS_DIR/logos/commissions"
create_dir "$ASSETS_DIR/logos/divers"

# ==============================================================================
# 9. DOSSIER SCHEMAS & DIAGRAMMES
# ==============================================================================

section_header "9. SCHÉMAS & DIAGRAMMES"

create_dir "$ASSETS_DIR/schemas"
create_dir "$ASSETS_DIR/schemas/hierarchie"
create_dir "$ASSETS_DIR/schemas/workflows"
create_dir "$ASSETS_DIR/schemas/organigrammes"
create_dir "$ASSETS_DIR/schemas/processus"

# ==============================================================================
# 10. DOSSIER TEMPLATES (Modèles de documents)
# ==============================================================================

section_header "10. TEMPLATES DE DOCUMENTS"

create_dir "$ASSETS_DIR/templates"
create_dir "$ASSETS_DIR/templates/rapports"
create_dir "$ASSETS_DIR/templates/rapports/service_divin"
create_dir "$ASSETS_DIR/templates/rapports/sacristie"
create_dir "$ASSETS_DIR/templates/rapports/financier"
create_dir "$ASSETS_DIR/templates/rapports/funeraire"
create_dir "$ASSETS_DIR/templates/lettres"
create_dir "$ASSETS_DIR/templates/certificats"
create_dir "$ASSETS_DIR/templates/invitations"
create_dir "$ASSETS_DIR/templates/communiques"

# ==============================================================================
# 11. DOSSIER IMAGES GÉNÉRIQUES
# ==============================================================================

section_header "11. IMAGES GÉNÉRIQUES"

create_dir "$ASSETS_DIR/images"
create_dir "$ASSETS_DIR/images/default"
create_dir "$ASSETS_DIR/images/default/profiles"
create_dir "$ASSETS_DIR/images/default/annonces"
create_dir "$ASSETS_DIR/images/default/commissions"
create_dir "$ASSETS_DIR/images/backgrounds"
create_dir "$ASSETS_DIR/images/icons"
create_dir "$ASSETS_DIR/images/bannieres"

# ==============================================================================
# 12. DOSSIER AUDIO & VIDÉO
# ==============================================================================

section_header "12. AUDIO & VIDÉO"

create_dir "$ASSETS_DIR/media"
create_dir "$ASSETS_DIR/media/audio"
create_dir "$ASSETS_DIR/media/audio/cantiques"
create_dir "$ASSETS_DIR/media/audio/prieres"
create_dir "$ASSETS_DIR/media/audio/enseignements"
create_dir "$ASSETS_DIR/media/video"
create_dir "$ASSETS_DIR/media/video/tutoriels"
create_dir "$ASSETS_DIR/media/video/ceremonies"
create_dir "$ASSETS_DIR/media/video/enseignements"

# ==============================================================================
# 13. DOSSIER EXPORTS & BACKUPS
# ==============================================================================

section_header "13. EXPORTS & BACKUPS"

create_dir "$ASSETS_DIR/exports"
create_dir "$ASSETS_DIR/exports/rapports"
create_dir "$ASSETS_DIR/exports/membres"
create_dir "$ASSETS_DIR/exports/finances"
create_dir "$ASSETS_DIR/exports/statistiques"
create_dir "$ASSETS_DIR/backups"
create_dir "$ASSETS_DIR/backups/database"
create_dir "$ASSETS_DIR/backups/configurations"

# ==============================================================================
# RÉCAPITULATIF FINAL
# ==============================================================================

echo ""
echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  ✅ GÉNÉRATION TERMINÉE AVEC SUCCÈS                      ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Compter les dossiers créés
TOTAL_DIRS=$(find "$ASSETS_DIR" -type d | wc -l)
TOTAL_FILES=$(find "$ASSETS_DIR" -type f | wc -l)

echo "📊 STATISTIQUES :"
echo "   • Dossiers créés : $TOTAL_DIRS"
echo "   • Fichiers .gitkeep : $TOTAL_FILES"
echo ""

echo "📁 STRUCTURE GÉNÉRÉE :"
echo "   ├── annonces/        (5 niveaux × 8 types = 40+ dossiers)"
echo "   ├── entites/         (5 niveaux avec responsables)"
echo "   ├── membres/         (5 niveaux avec documents)"
echo "   ├── ministres/       (Pensées, Directives, Formations)"
echo "   ├── commissions/     (5 niveaux × 13 commissions = 65 dossiers)"
echo "   ├── librairie/       (8 catégories avec sous-dossiers)"
echo "   ├── bibles/          (TOB + autres versions)"
echo "   ├── logos/           (Par niveau d'entité)"
echo "   ├── schemas/         (Hiérarchie, workflows)"
echo "   ├── templates/       (Modèles de documents)"
echo "   ├── images/          (Images par défaut)"
echo "   ├── media/           (Audio & Vidéo)"
echo "   ├── exports/         (Exports de données)"
echo "   └── backups/         (Sauvegardes)"
echo ""

echo -e "${YELLOW}⚠️  N'OUBLIEZ PAS :${NC}"
echo "   1. Ajouter 'assets/' dans votre pubspec.yaml"
echo "   2. Exécuter 'flutter pub get'"
echo "   3. Commiter les changements dans Git"
echo ""

echo -e "${BLUE}🕊️ Que Dieu bénisse votre ministère et ce projet !${NC}"
echo ""

exit 0