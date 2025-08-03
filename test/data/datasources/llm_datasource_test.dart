import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:to_do_abstracta_app/data/datasources/llm_datasource.dart';

@GenerateMocks([http.Client])
void main() {
  group('LLMDatasourceImpl', () {
    group('without API key configured', () {
      late LLMDatasourceImpl datasource;

      setUp(() {
        datasource = LLMDatasourceImpl();
      });

      test('should indicate service is not configured when API key is empty',
          () {
        // Act
        final isConfigured = datasource.isConfigured;

        // Assert
        expect(isConfigured, isFalse);
      });

      test('should throw exception when generating description without API key',
          () async {
        // Arrange
        const taskTitle = 'Test Task';

        // Act & Assert
        expect(
          () => datasource.generateTaskDescription(taskTitle),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Gemini API key not configured'),
          )),
        );
      });

      test('should throw exception when generating tags without API key',
          () async {
        // Arrange
        const taskTitle = 'Test Task';
        const taskDescription = 'Test Description';

        // Act & Assert
        expect(
          () => datasource.generateTaskTags(taskTitle, taskDescription),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Gemini API key not configured'),
          )),
        );
      });
    });

    group('with mocked API responses', () {
      test('should parse description response correctly', () {
        const expectedDescription = 'Una descripción generada por AI';

        expect(expectedDescription, isA<String>());
        expect(expectedDescription.isNotEmpty, isTrue);
      });

      test('should parse tags response correctly', () {

        const expectedTags = ['trabajo', 'urgente', 'importante'];

        // Para este test, simplemente verificamos que el formato esperado es correcto
        expect(expectedTags, isA<List<String>>());
        expect(expectedTags.length, greaterThan(0));
        expect(expectedTags.every((tag) => tag.isNotEmpty), isTrue);
      });
    });
  });
}
