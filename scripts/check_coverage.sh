#!/bin/bash

# Script para verificar el coverage mínimo requerido
# Este script verifica que el coverage sea al menos del 80%

set -e

COVERAGE_FILE="coverage/lcov.info"
MIN_COVERAGE=80

if [ ! -f "$COVERAGE_FILE" ]; then
    echo "❌ Coverage file not found: $COVERAGE_FILE"
    echo "Make sure to run 'flutter test --coverage' first"
    exit 1
fi

# Instalar lcov si no está disponible (en CI)
if ! command -v lcov &> /dev/null; then
    echo "📦 Installing lcov..."
    sudo apt-get update && sudo apt-get install -y lcov
fi

# Generar reporte de coverage
echo "📊 Generating coverage report..."
genhtml coverage/lcov.info -o coverage/html

# Extraer el porcentaje de coverage
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines......" | grep -o '[0-9.]*%' | head -1 | sed 's/%//')

# Convertir a entero para comparación
COVERAGE_INT=$(echo "$COVERAGE" | cut -d'.' -f1)

echo "📈 Current coverage: ${COVERAGE}%"
echo "🎯 Minimum required: ${MIN_COVERAGE}%"

if [ "$COVERAGE_INT" -lt "$MIN_COVERAGE" ]; then
    echo "❌ Coverage is below minimum threshold!"
    echo "Current: ${COVERAGE}% | Required: ${MIN_COVERAGE}%"
    echo ""
    echo "📋 Coverage details:"
    lcov --list coverage/lcov.info
    echo ""
    echo "💡 Tips to improve coverage:"
    echo "- Add tests for uncovered lines"
    echo "- Review the HTML report in coverage/html/index.html"
    echo "- Focus on core business logic and edge cases"
    exit 1
fi

echo "✅ Coverage check passed! (${COVERAGE}%)"

# Mostrar archivos con menor coverage
echo ""
echo "📊 Files with lowest coverage:"
lcov --list coverage/lcov.info | sort -k2 -n | head -10

echo ""
echo "🎉 Coverage report generated successfully!"
echo "📁 View detailed report: coverage/html/index.html"
