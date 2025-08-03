import 'package:to_do_abstracta_app/domain/models/task_form_data.dart';
import 'package:to_do_abstracta_app/domain/repositories/llm_repository.dart';

/// Casos de uso para funcionalidades de modelos de lenguaje natural (LLM).
///
/// Esta clase encapsula la lógica de negocio relacionada con la generación
/// de contenido usando inteligencia artificial, actuando como intermediario
/// entre la capa de presentación y el repositorio LLM.
class LLMUsecases {
  final LLMRepository _repository;

  LLMUsecases(this._repository);

  /// Genera información completa de una tarea basada solo en el título.
  ///
  /// Utiliza IA para autocompletar todos los campos del formulario
  /// incluyendo descripción, etiquetas, estado, prioridad y usuario asignado.
  Future<TaskFormData> generateCompleteTaskFromTitle(String title) {
    return _repository.generateCompleteTaskFromTitle(title);
  }

  /// Verifica si el servicio LLM está configurado y disponible.
  bool get isConfigured => _repository.isConfigured;
}
