# ToDo Abstracta App

Una aplicación de gestión de tareas moderna desarrollada en Flutter con funcionalidades avanzadas de IA.

## Características

- **Gestión de Tareas**: Crear, editar, completar y eliminar tareas
- **Búsqueda Inteligente**: Buscar tareas con filtros avanzados
- **IA Integrada**: Generación automática de descripciones y etiquetas usando Google Gemini
- **Diseño Adaptativo**: UI nativa para Android (Material Design) e iOS (Cupertino)
- **Estadísticas**: Análisis de productividad y progreso
- **Almacenamiento Local**: Persistencia de datos con Hive
- **Estado Reactivo**: Gestión de estado con Riverpod

## Tecnologías

- **Flutter 3.27.0** - Framework de desarrollo
- **Riverpod** - Gestión de estado reactivo
- **Hive** - Base de datos local NoSQL
- **Google Gemini API** - Inteligencia artificial
- **Material Design / Cupertino** - Componentes UI nativos

## Arquitectura

El proyecto sigue la **Arquitectura Limpia** con las siguientes capas:

```
lib/
├── core/           # Configuración global, DI, temas
├── data/           # Fuentes de datos, modelos, repositorios
├── domain/         # Entidades, casos de uso, interfaces
└── presentation/   # UI, providers, widgets
```

## CI/CD Pipeline

Este proyecto utiliza **GitHub Actions** para automatización completa:

### Flujos de Trabajo

1. **CI Pipeline** (`.github/workflows/ci.yml`)
   - Ejecuta tests unitarios y de widgets
   - Análisis estático con Flutter analyzer
   - Verificación de cobertura (mínimo 80%)
   - Builds de Android e iOS
   - Subida de artefactos

2. **Release Pipeline** (`.github/workflows/release.yml`)
   - Creación automática de releases en GitHub
   - Builds de producción (APK y AAB)
   - Subida de artefactos de release

### Protección de Rama

La rama `main` está protegida con las siguientes reglas:

- **Status Checks Requeridos**: CI Pipeline debe pasar
- **Revisiones de PR**: Mínimo 1 aprobación requerida
- **Conversaciones**: Todas deben resolverse
- **Push Directo**: Bloqueado (solo vía PR)
- **Force Push**: Bloqueado para preservar historial

## 🔧 Configuración de Desarrollo

### Prerrequisitos

- Flutter 3.27.0 (canal stable)
- Dart 3.6.0+
- Android Studio / VS Code
- Git

### Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/to_do_abstracta_app.git
   cd to_do_abstracta_app
   ```

2. **Configurar entorno de desarrollo**:
   ```bash
   ./scripts/setup_dev.sh
   ```

3. **Configurar variables de entorno**:
   ```bash
   # Crear archivo .env en la raíz del proyecto
   GEMINI_API_KEY=tu_clave_de_gemini_aqui
   ```

### Comandos de Desarrollo

```bash
# Ejecutar tests
flutter test

# Tests con cobertura
flutter test --coverage

# Análisis estático
flutter analyze

# Ejecutar app en debug
flutter run

# Build de producción
flutter build apk --release
```

## Scripts Disponibles

El proyecto incluye scripts útiles en la carpeta `scripts/`:

- **`setup_dev.sh`**: Configuración inicial del entorno
- **`prepare_release.sh`**: Preparación para releases
- **`setup_branch_protection.sh`**: Configuración de protección de rama

### Uso de Scripts

```bash
# Configurar entorno de desarrollo
./scripts/setup_dev.sh

# Preparar release
./scripts/prepare_release.sh

# Configurar protección de rama (requiere GitHub CLI)
./scripts/setup_branch_protection.sh
```

## Proceso de Release

1. **Preparar release**:
   ```bash
   ./scripts/prepare_release.sh
   ```

2. **Crear tag de versión**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **El pipeline automáticamente**:
   - Construye artefactos de producción
   - Crea release en GitHub
   - Sube APK y AAB

## Instalación de la App

### Android

1. Ve a [Releases](https://github.com/sooyvilla/to_do_abstracta_app/releases)
2. Descarga el APK más reciente
3. Instala el APK en tu dispositivo

## Testing

El proyecto mantiene una cobertura de pruebas del **80%** mínimo:

```bash
# Ejecutar todos los tests
flutter test

# Tests con reporte de cobertura
flutter test --coverage

# Ver cobertura en HTML
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Tipos de Tests

- **Unit Tests**: Casos de uso, servicios, utilidades
- **Widget Tests**: Componentes UI individuales

## Convenciones

### Commits (Conventional Commits)

- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Documentación
- `style:` Formato de código
- `refactor:` Refactorización
- `test:` Añadir tests
- `chore:` Tareas de mantenimiento
