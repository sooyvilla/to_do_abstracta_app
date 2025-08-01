#!/bin/bash

# Script para preparar releases
# Actualiza versiones, genera changelog y prepara artifacts

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Preparando release para Todo Abstracta App...${NC}"

# Verificar que estamos en la rama main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}❌ Error: Debes estar en la rama main para crear un release${NC}"
    exit 1
fi

# Verificar que no hay cambios sin commit
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}❌ Error: Hay cambios sin commit. Commitea todos los cambios primero.${NC}"
    exit 1
fi

# Obtener la versión actual del pubspec.yaml
CURRENT_VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //')
echo -e "${YELLOW}📋 Versión actual: $CURRENT_VERSION${NC}"

# Pedir nueva versión
read -p "🏷️  Ingresa la nueva versión (ej: 1.0.1): " NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
    echo -e "${RED}❌ Error: Debes proporcionar una versión${NC}"
    exit 1
fi

# Actualizar pubspec.yaml
echo -e "${YELLOW}📝 Actualizando pubspec.yaml...${NC}"
sed -i "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" pubspec.yaml

# Ejecutar pruebas completas
echo -e "${YELLOW}🧪 Ejecutando pruebas completas...${NC}"
flutter test --coverage

# Verificar cobertura
echo -e "${YELLOW}📊 Verificando cobertura...${NC}"
./scripts/check_coverage.sh

# Generar builds
echo -e "${YELLOW}🔨 Generando builds...${NC}"

# Android
echo -e "${YELLOW}📱 Construyendo Android APK...${NC}"
flutter build apk --release

# iOS (solo en macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}🍎 Construyendo iOS...${NC}"
    flutter build ios --release --no-codesign
fi

# Crear tag
echo -e "${YELLOW}🏷️  Creando tag v$NEW_VERSION...${NC}"
git add pubspec.yaml
git commit -m "chore: bump version to $NEW_VERSION"
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

echo -e "${GREEN}✅ Release preparado exitosamente!${NC}"
echo -e "${YELLOW}📋 Próximos pasos:${NC}"
echo -e "   1. git push origin main"
echo -e "   2. git push origin v$NEW_VERSION"
echo -e "   3. Crear release en GitHub con los artifacts generados"
echo -e "   4. APK disponible en: build/app/outputs/flutter-apk/app-release.apk"

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "   5. iOS build disponible en: build/ios/iphoneos/"
fi
