#!/bin/bash

# Script para configurar el entorno de desarrollo
# Instala dependencias y herramientas necesarias

set -e

echo "🚀 Configurando entorno de desarrollo para Todo Abstracta App..."

# Verificar que Flutter esté instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado. Por favor instala Flutter primero."
    echo "📖 Visita: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Verificar versión de Flutter
echo "🔍 Verificando versión de Flutter..."
FLUTTER_VERSION=$(flutter --version | head -n1 | awk '{print $2}')
REQUIRED_VERSION="3.32.8"

echo "Flutter instalado: $FLUTTER_VERSION"
echo "Versión requerida: $REQUIRED_VERSION"

if [[ "$FLUTTER_VERSION" < "$REQUIRED_VERSION" ]]; then
    echo "⚠️  Se recomienda actualizar Flutter a la versión $REQUIRED_VERSION o superior"
    echo "💡 Ejecuta: flutter upgrade"
fi

# Instalar dependencias
echo "📦 Instalando dependencias..."
flutter pub get

# Generar archivos necesarios
echo "🔧 Generando archivos..."
flutter pub run build_runner build --delete-conflicting-outputs

# Verificar configuración
echo "✅ Verificando configuración..."
flutter doctor

# Ejecutar análisis
echo "🔍 Ejecutando análisis estático..."
flutter analyze

# Verificar formato
echo "🎨 Verificando formato del código..."
dart format --set-exit-if-changed .

# Ejecutar pruebas
echo "🧪 Ejecutando pruebas..."
flutter test

echo ""
echo "✅ ¡Entorno configurado correctamente!"
echo "🎯 Comandos útiles:"
echo "   - flutter run: Ejecutar la app"
echo "   - flutter test: Ejecutar pruebas"
echo "   - flutter analyze: Análisis estático"
echo "   - dart format .: Formatear código"
