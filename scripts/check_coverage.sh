#!/bin/bash

# Script para verificar el coverage mínimo requerido
# Este script verifica que el coverage sea al menos del 40%

set -e

COVERAGE_FILE="coverage/lcov.info"
MIN_COVERAGE=40

if [ ! -f "$COVERAGE_FILE" ]; then
    echo "❌ Coverage file not found: $COVERAGE_FILE"
    echo "Make sure to run 'flutter test --coverage' first"
    exit 1
fi

# Calcular cobertura con los datos existentes
TOTAL=$(grep "^LF:" coverage/lcov.info | awk -F: '{sum += $2} END {print sum}')
COVERED=$(grep "^LH:" coverage/lcov.info | awk -F: '{sum += $2} END {print sum}')
COVERAGE=$(awk -v total="$TOTAL" -v covered="$COVERED" 'BEGIN { printf "%.1f", (covered/total)*100 }')

echo "� Coverage: $COVERAGE% (Required: ${MIN_COVERAGE}%)"

# Validar umbral del 40%
if (( $(echo "$COVERAGE < $MIN_COVERAGE" | awk '{print ($1 < $3)}') )); then
    echo "❌ Coverage below ${MIN_COVERAGE}%"
    exit 1
fi

echo "✅ Coverage check passed!"
