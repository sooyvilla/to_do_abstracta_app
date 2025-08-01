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
   - Builds de Android e iOS para validación

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
- **`setup_branch_protection.sh`**: Configuración de protección de rama

### Uso de Scripts

```bash
# Configurar entorno de desarrollo
./scripts/setup_dev.sh

# Configurar protección de rama (requiere GitHub CLI)
./scripts/setup_branch_protection.sh
```

## Flujo de Trabajo de Contribución

1. **Crear rama de feature**:
   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```

2. **Desarrollar y probar**:
   ```bash
   flutter test
   flutter analyze
   ```

3. **Commit con mensaje descriptivo**:
   ```bash
   git commit -m "feat: añadir nueva funcionalidad"
   ```

4. **Push y crear PR**:
   ```bash
   git push origin feature/nueva-funcionalidad
   ```

5. **El CI verificará automáticamente**:
   - ✅ Tests pasan
   - ✅ Cobertura ≥ 80%
   - ✅ Sin errores de análisis estático
   - ✅ Build exitoso

6. **Revisión y merge**: Requiere aprobación de al menos 1 revisor

## Testing

## Convenciones

### Commits (Conventional Commits)

- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Documentación
- `style:` Formato de código
- `refactor:` Refactorización
- `test:` Añadir tests
- `chore:` Tareas de mantenimiento
