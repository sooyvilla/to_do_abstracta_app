#!/bin/bash

# Script para configurar la protección de la rama main
# Requiere GitHub CLI (gh) instalado y autenticado

set -e

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🛡️  Configurando protección de rama main...${NC}"

# Verificar que GitHub CLI está instalado
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI no está instalado${NC}"
    echo "Instala GitHub CLI desde: https://cli.github.com/"
    exit 1
fi

# Verificar autenticación
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ No estás autenticado en GitHub CLI${NC}"
    echo "Ejecuta: gh auth login"
    exit 1
fi

# Obtener información del repositorio
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo -e "${YELLOW}📦 Repositorio: ${REPO}${NC}"

# Configurar protección de rama main
echo -e "${GREEN}🔒 Configurando reglas de protección...${NC}"

# Configurar protección básica
gh api repos/${REPO}/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["CI Pipeline / test","CI Pipeline / lint"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true,"require_code_owner_reviews":false,"require_last_push_approval":false}' \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false \
  --field block_creations=false \
  --field required_conversation_resolution=true

echo -e "${GREEN}✅ Protección de rama configurada exitosamente${NC}"

# Mostrar configuración actual
echo -e "\n${YELLOW}📋 Configuración actual:${NC}"
echo "• ✅ Revisiones de PR requeridas (mínimo 1)"
echo "• ✅ Status checks requeridos (CI Pipeline)"
echo "• ✅ Conversaciones deben resolverse"
echo "• ✅ Push forzado bloqueado"
echo "• ✅ Eliminación de rama bloqueada"
echo "• ✅ Reglas aplicadas a administradores"

echo -e "\n${GREEN}🎉 ¡Configuración completada!${NC}"
echo -e "${YELLOW}📝 Ahora todos los PRs a main requerirán:${NC}"
echo "  1. Pasar todos los tests (CI Pipeline)"
echo "  2. Pasar el linting"
echo "  3. Al menos 1 revisión aprobada"
echo "  4. Resolver todas las conversaciones"

# Información adicional
echo -e "\n${YELLOW}💡 Consejos adicionales:${NC}"
echo "• Crea PRs desde ramas de feature"
echo "• Ejecuta 'scripts/setup_dev.sh' antes de desarrollar"
echo "• Usa 'scripts/prepare_release.sh' antes de crear releases"
