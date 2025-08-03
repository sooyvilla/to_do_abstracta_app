import 'package:to_do_abstracta_app/domain/models/task_form_data.dart';

/// Contrato del repositorio para funcionalidades de modelos de lenguaje natural (LLM).
///
/// Define la interfaz que debe implementar cualquier repositorio LLM,
/// proporcionando operaciones para generar contenido usando inteligencia artificial.
abstract class LLMRepository {
  /// Genera una descripción detallada para una tarea basada en un prompt.
  @Deprecated(
      'Este método esta obsoleto. Usa generateCompleteTaskFromTitle para obtener una tarea completa.')
  Future<String> generateTaskDescription(String prompt);

  /// Genera etiquetas relevantes para una tarea basada en título y descripción.
  @Deprecated(
      'Este método esta obsoleto. Usa generateCompleteTaskFromTitle para obtener etiquetas junto con otros datos de la tarea.')
  Future<List<String>> generateTaskTags(String title, String description);

  /// Genera información completa de una tarea basada solo en el título.
  Future<TaskFormData> generateCompleteTaskFromTitle(String title);

  /// Indica si el servicio LLM está configurado correctamente.
  bool get isConfigured;
}
