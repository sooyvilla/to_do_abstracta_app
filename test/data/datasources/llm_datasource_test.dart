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
      expect(isConfigured, isFalse); // Sin API key configurada
    });

    test('should throw exception when generating description without API key', () async {
      // Arrange
      const taskTitle = 'Test Task';

      // Act & Assert
      expect(
        () => datasource.generateTaskDescription(taskTitle),
        throwsException,
      );
    });

    test('should throw exception when generating tags without API key', () async {
      // Arrange
      const taskTitle = 'Test Task';
      const taskDescription = 'Test Description';

      // Act & Assert
      expect(
        () => datasource.generateTaskTags(taskTitle, taskDescription),
        throwsException,
      );
    });
  });
}
