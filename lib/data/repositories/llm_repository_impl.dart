import 'package:to_do_abstracta_app/data/datasources/llm_datasource.dart';
import 'package:to_do_abstracta_app/domain/models/task_form_data.dart';
import 'package:to_do_abstracta_app/domain/repositories/llm_repository.dart';

/// Implementación del repositorio LLM.
///
/// Actúa como intermediario entre la capa de dominio y la fuente de datos LLM,
/// delegando las operaciones a la fuente de datos correspondiente.
/// Proporciona una capa de abstracción para servicios de IA.
class LLMRepositoryImpl implements LLMRepository {
  final LLMDatasource _llmDatasource;

  LLMRepositoryImpl(this._llmDatasource);

  @override
  @Deprecated(
      'Este método esta obsoleto. Usa generateCompleteTaskFromTitle para obtener una tarea completa.')
  Future<String> generateTaskDescription(String prompt) {
    return _llmDatasource.generateTaskDescription(prompt);
  }

  @override
  @Deprecated(
      'Este método esta obsoleto. Usa generateCompleteTaskFromTitle para obtener etiquetas junto con otros datos de la tarea.')
  Future<List<String>> generateTaskTags(String title, String description) {
    return _llmDatasource.generateTaskTags(title, description);
  }

  @override
  Future<TaskFormData> generateCompleteTaskFromTitle(String title) {
    return _llmDatasource.generateCompleteTaskFromTitle(title);
  }

  @override
  bool get isConfigured => _llmDatasource.isConfigured;
}
