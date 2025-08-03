import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/data/datasources/llm_datasource.dart';

void main() {
  late LLMDatasourceImpl datasource;

  setUp(() {
    datasource = LLMDatasourceImpl();
  });

  group('LLMDatasourceImpl', () {
    test('should indicate if service is configured', () {
      // Act
      final isConfigured = datasource.isConfigured;

      // Assert
      expect(isConfigured, isTrue); // Con API key configurada
    });

    test('should generate description when API key is configured', () async {
      // Arrange
      const taskTitle = 'Test Task';

      // Act
      final result = await datasource.generateTaskDescription(taskTitle);

      // Assert
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });

    test('should generate tags when API key is configured', () async {
      // Arrange
      const taskTitle = 'Test Task';
      const taskDescription = 'Test Description';

      // Act
      final result = await datasource.generateTaskTags(taskTitle, taskDescription);

      // Assert
      expect(result, isA<List<String>>());
      expect(result.isNotEmpty, isTrue);
    });
  });
}
