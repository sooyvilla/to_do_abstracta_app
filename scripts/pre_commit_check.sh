#!/bin/bash

# Script para ejecutar todas las verificaciones de calidad de código
# Úsalo localmente antes de hacer push o crear PR

set -e

echo "🔍 Flutter To-Do App - Code Quality Checker"
echo "==========================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 1. Verificar que Flutter esté instalado
print_step "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi
print_success "Flutter found: $(flutter --version | head -1)"

# 2. Obtener dependencias
print_step "Getting dependencies..."
flutter pub get
print_success "Dependencies updated"

# 3. Verificar formato de código
print_step "Checking code formatting..."
if ! dart format --set-exit-if-changed .; then
    print_error "Code formatting issues found!"
    echo "Run 'dart format .' to fix formatting"
    exit 1
fi
print_success "Code formatting is correct"

# 4. Análisis estático
print_step "Running static analysis..."
if ! flutter analyze; then
    print_error "Static analysis failed!"
    exit 1
fi
print_success "Static analysis passed"

# 5. Ejecutar tests con coverage
print_step "Running tests with coverage..."
if ! flutter test --coverage; then
    print_error "Tests failed!"
    exit 1
fi
print_success "All tests passed"

# 6. Verificar coverage mínimo
print_step "Checking test coverage..."
if ! ./scripts/check_coverage.sh; then
    print_error "Coverage check failed!"
    exit 1
fi
print_success "Coverage requirements met"

# 7. Verificar que el build funcione
print_step "Verifying build..."
if ! flutter build apk --debug; then
    print_error "Debug build failed!"
    exit 1
fi
print_success "Build verification passed"

# 8. Linting adicional (si existe custom_lint)
if grep -q "custom_lint" pubspec.yaml; then
    print_step "Running custom linting..."
    if ! dart run custom_lint; then
        print_warning "Custom lint found issues (non-blocking)"
    else
        print_success "Custom lint passed"
    fi
fi

echo ""
echo "🎉 All quality checks passed!"
echo "Your code is ready for commit/PR 🚀"
echo ""
echo "📊 Next steps:"
echo "  • Commit your changes: git add . && git commit -m 'your message'"
echo "  • Push to remote: git push origin your-branch"
echo "  • Create PR when ready"
echo ""
echo "📁 Coverage report available at: coverage/html/index.html"
