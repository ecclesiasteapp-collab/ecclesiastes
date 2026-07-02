$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$paths = @(
  "assets/documents/ministres/manuels",
  "assets/documents/ministres/pensee_directrice/2024",
  "assets/documents/ministres/pensee_directrice/2025",
  "assets/documents/ministres/pensee_directrice/2026",
  "assets/documents/ministres/liturgie",
  "assets/documents/ministres/rapports_officiels",
  "assets/documents/formateurs/ecodim",
  "assets/documents/formateurs/econfi",
  "assets/documents/formateurs/jeunesse",
  "assets/documents/formateurs/papas",
  "assets/documents/formateurs/mamans",
  "assets/documents/formateurs/aines",
  "assets/documents/formateurs/musique/direction_technique",
  "assets/documents/formateurs/musique/orchestre",
  "assets/documents/formateurs/presse_medias_sonorisation",
  "assets/documents/formateurs/joseph_arimathee",
  "assets/documents/formateurs/securite_protocole",
  "assets/documents/formateurs/medicale",
  "assets/documents/formateurs/construction",
  "assets/documents/membres/catechisme/debutants",
  "assets/documents/membres/catechisme/confirmation",
  "assets/documents/membres/cantiques/liturgiques",
  "assets/documents/membres/cantiques/jeunesse",
  "assets/documents/membres/cantiques/special",
  "assets/documents/membres/pensees_directrices/2024",
  "assets/documents/membres/pensees_directrices/2025",
  "assets/documents/membres/pensees_directrices/2026"
)

foreach ($relativePath in $paths) {
  $absolutePath = Join-Path $root $relativePath
  New-Item -ItemType Directory -Path $absolutePath -Force | Out-Null

  $keepFile = Join-Path $absolutePath ".gitkeep"
  if (-not (Test-Path $keepFile)) {
    New-Item -ItemType File -Path $keepFile | Out-Null
  }
}

Write-Host "Structure documentaire KSO créée avec succès."
