import 'package:to_do_abstracta_app/domain/repositories/llm_repository.dart';

/// Casos de uso para funcionalidades de modelos de lenguaje natural (LLM).
///
/// Esta clase encapsula la lógica de negocio relacionada con la generación
/// de contenido usando inteligencia artificial, actuando como intermediario
/// entre la capa de presentación y el repositorio LLM.
class LLMUsecases {
  final LLMRepository _repository;

  LLMUsecases(this._repository);

  /// Genera una descripción detallada para una tarea basada en un prompt.
  ///
  /// Utiliza IA para crear descripciones informativas y coherentes
  /// que ayuden a clarificar el propósito y contexto de la tarea.
  Future<String> generateTaskDescription(String prompt) {
    return _repository.generateTaskDescription(prompt);
  }

  /// Genera etiquetas relevantes para una tarea.
  ///
  /// Analiza el título y descripción de la tarea para sugerir
  /// etiquetas apropiadas que faciliten la organización y búsqueda.
  Future<List<String>> generateTaskTags(String title, String description) {
    return _repository.generateTaskTags(title, description);
  }

  /// Verifica si el servicio LLM está configurado y disponible.
  bool get isConfigured => _repository.isConfigured;
}
