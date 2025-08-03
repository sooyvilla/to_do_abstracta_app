import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/models/task_form_data.dart';

/// Contrato para fuentes de datos de modelos de lenguaje natural (LLM).
///
/// Define la interfaz para servicios que pueden generar contenido
/// usando inteligencia artificial, como descripciones y etiquetas para tareas.
abstract class LLMDatasource {
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

/// Implementación de la fuente de datos LLM usando Google Gemini.
///
/// Utiliza la API de Gemini para generar descripciones y etiquetas
/// de tareas con salida estructurada JSON. Requiere una clave API válida para funcionar.
class LLMDatasourceImpl implements LLMDatasource {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  // !Insertar llave de acceso de Gemini
  static const String _apiKey = '';

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  Future<String> generateTaskDescription(String prompt) async {
    if (!isConfigured) {
      throw Exception(
          'Gemini API key not configured. Please set up your API key to use AI features.');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/models/gemini-2.5-flash:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Genera una descripción detallada para esta tarea: $prompt'
                }
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'responseSchema': {
              'type': 'OBJECT',
              'properties': {
                'descripcion': {
                  'type': 'STRING',
                  'description':
                      'Descripción detallada de la tarea (2-3 oraciones)'
                }
              },
              'required': ['descripcion'],
              'propertyOrdering': ['descripcion']
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];
        final jsonResponse = jsonDecode(content);
        return jsonResponse['descripcion'].toString().trim();
      } else {
        throw Exception(
            'Failed to generate description: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('API key not configured')) {
        rethrow;
      }
      return prompt;
    }
  }

  @override
  Future<List<String>> generateTaskTags(
      String title, String description) async {
    if (!isConfigured) {
      throw Exception(
          'Gemini API key not configured. Please set up your API key to use AI features.');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/models/gemini-2.5-flash:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Genera 3-5 etiquetas relevantes para esta tarea. Título: $title\nDescripción: $description'
                }
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'responseSchema': {
              'type': 'OBJECT',
              'properties': {
                'etiquetas': {
                  'type': 'ARRAY',
                  'items': {'type': 'STRING'},
                  'description':
                      'Lista de 3-5 etiquetas relevantes para la tarea',
                  'minItems': 3,
                  'maxItems': 5
                }
              },
              'required': ['etiquetas'],
              'propertyOrdering': ['etiquetas']
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];
        final jsonResponse = jsonDecode(content);
        final tags = List<String>.from(jsonResponse['etiquetas']);
        return tags.map((tag) => tag.trim()).toList();
      } else {
        throw Exception('Failed to generate tags: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('API key not configured')) {
        rethrow;
      }
      return ['task', 'todo', 'general'];
    }
  }

  @override
  Future<TaskFormData> generateCompleteTaskFromTitle(String title) async {
    if (!isConfigured) {
      throw Exception(
          'Gemini API key not configured. Please set up your API key to use AI features.');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/models/gemini-2.5-flash:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Basándote en este título de tarea: "$title", genera información completa para completar el formulario. Incluye una descripción detallada, etiquetas relevantes, estado apropiado, prioridad, y un usuario asignado genérico.'
                }
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'responseSchema': {
              'type': 'OBJECT',
              'properties': {
                'descripcion': {
                  'type': 'STRING',
                  'description':
                      'Descripción detallada de la tarea (2-3 oraciones)'
                },
                'etiquetas': {
                  'type': 'ARRAY',
                  'items': {'type': 'STRING'},
                  'description':
                      'Lista de 3-5 etiquetas relevantes para la tarea',
                  'minItems': 3,
                  'maxItems': 5
                },
                'estado': {
                  'type': 'STRING',
                  'enum': ['pending', 'inProgress', 'completed', 'cancelled'],
                  'description': 'Estado apropiado para la tarea'
                },
                'prioridad': {
                  'type': 'STRING',
                  'enum': ['low', 'medium', 'high'],
                  'description': 'Prioridad apropiada para la tarea'
                },
                'usuarioAsignado': {
                  'type': 'STRING',
                  'description': 'Usuario genérico asignado a la tarea'
                }
              },
              'required': [
                'descripcion',
                'etiquetas',
                'estado',
                'prioridad',
                'usuarioAsignado'
              ],
              'propertyOrdering': [
                'descripcion',
                'etiquetas',
                'estado',
                'prioridad',
                'usuarioAsignado'
              ]
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];
        final jsonResponse = jsonDecode(content);

        return TaskFormData(
          description: jsonResponse['descripcion'].toString().trim(),
          tags: List<String>.from(jsonResponse['etiquetas'])
              .map((tag) => tag.trim())
              .toList(),
          status: _mapStringToTaskStatus(jsonResponse['estado']),
          priority: _mapStringToTaskPriority(jsonResponse['prioridad']),
          assignedUser: jsonResponse['usuarioAsignado'].toString().trim(),
        );
      } else {
        throw Exception(
            'Failed to generate complete task: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('API key not configured')) {
        rethrow;
      }
      return TaskFormData(
        description: 'Descripción generada automáticamente para: $title',
        tags: ['task', 'auto-generated'],
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
        assignedUser: 'Usuario General',
      );
    }
  }

  TaskStatus _mapStringToTaskStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TaskStatus.pending;
      case 'inprogress':
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      default:
        return TaskStatus.pending;
    }
  }

  TaskPriority _mapStringToTaskPriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.medium;
    }
  }
}
