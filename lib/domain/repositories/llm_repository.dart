/// Contrato del repositorio para funcionalidades de modelos de lenguaje natural (LLM).
///
/// Define la interfaz que debe implementar cualquier repositorio LLM,
/// proporcionando operaciones para generar contenido usando inteligencia artificial.
abstract class LLMRepository {
  /// Genera una descripción detallada para una tarea basada en un prompt.
  Future<String> generateTaskDescription(String prompt);

  /// Genera etiquetas relevantes para una tarea basada en título y descripción.
  Future<List<String>> generateTaskTags(String title, String description);

  /// Indica si el servicio LLM está configurado correctamente.
  bool get isConfigured;
}
