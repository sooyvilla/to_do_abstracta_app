# ToDo Abstracta App

Una aplicación de gestión de tareas desarrollada en Flutter con funcionalidades de IA.

# Documentacion de versiones

En el archivo `CHANGELOG.md` se documentan las versiones de la aplicación, incluyendo nuevas funcionalidades, correcciones de errores y mejoras.

en la rama `release/v2.0.0` se encuentra una version con cambios en el diseño de iOS y Android y funcionalidad para autocompletar toda la tarea con IA solo tomando el titulo.

## Características

- **Gestión de Tareas**: Crear, editar, completar y eliminar tareas
- **Búsqueda**: Buscar de tareas
- **IA Integrada**: Generación automática de descripciones
- **Estadísticas**: Análisis de productividad y progreso
- **Almacenamiento Local**: Persistencia de datos con Hive
- **Estado Reactivo**: Gestión de estado con Riverpod

## Demostración

### iOS
<div align="left">
  <a href="https://streamable.com/bynupi">
    <img src="https://img.shields.io/badge/📱_Ver_Demo_iOS-FF6B6B?style=for-the-badge&logo=apple&logoColor=white" alt="Demo iOS"/>
  </a>
</div>

### Android
<div align="left">
  <a href="https://streamable.com/hybben">
    <img src="https://img.shields.io/badge/%F0%9F%A4%96_Ver_Demo_Android-gray?style=for-the-badge&logo=android&logoColor=white" alt="Demo Android"/>
  </a>
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
