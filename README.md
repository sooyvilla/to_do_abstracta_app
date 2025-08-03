# ToDo Abstracta App

Una aplicación de gestión de tareas desarrollada en Flutter con funcionalidades de IA.

## Características

- **Gestión de Tareas**: Crear, editar, completar y eliminar tareas
- **Búsqueda**: Buscar de tareas
- **IA Integrada**: Generación automática de descripciones
- **Estadísticas**: Análisis de productividad y progreso
- **Almacenamiento Local**: Persistencia de datos con Hive
- **Estado Reactivo**: Gestión de estado con Riverpod

## Demostración

### Android
<div align="center">
  <img src="assets/demo/android_demo" alt="Demo Android" width="300" />
</div>

### iOS
<div align="center">
  <img src="assets/demo/ios_demo" alt="Demo iOS" width="300" />
</div>

## Tecnologías

- **Flutter 3.32.8** - Framework de desarrollo
- **Riverpod** - Gestión de estado reactivo
- **Hive** - Base de datos local NoSQL
- **Google Gemini API** - Inteligencia artificial

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
   - Verificación de cobertura (mínimo 40%)

### Protección de Rama

La rama `main` está protegida con las siguientes reglas:

- **Status Checks Requeridos**: CI Pipeline debe pasar
- **Revisiones de PR**: Mínimo 1 aprobación requerida
- **Conversaciones**: Todas deben resolverse
- **Push Directo**: Bloqueado (solo vía PR)
- **Force Push**: Bloqueado para preservar historial
