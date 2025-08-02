import 'dart:convert';

import 'package:http/http.dart' as http;

/// Contrato para fuentes de datos de modelos de lenguaje natural (LLM).
///
/// Define la interfaz para servicios que pueden generar contenido
/// usando inteligencia artificial, como descripciones y etiquetas para tareas.
abstract class LLMDatasource {
  /// Genera una descripción detallada para una tarea basada en un prompt.
  Future<String> generateTaskDescription(String prompt);

  /// Genera etiquetas relevantes para una tarea basada en título y descripción.
  Future<List<String>> generateTaskTags(String title, String description);

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
}
