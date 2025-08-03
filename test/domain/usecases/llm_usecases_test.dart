import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/models/task_form_data.dart';
import 'package:to_do_abstracta_app/domain/repositories/llm_repository.dart';
import 'package:to_do_abstracta_app/domain/usecases/llm_usecases.dart';

import 'llm_usecases_test.mocks.dart';

@GenerateMocks([LLMRepository])
void main() {
  late LLMUsecases llmUsecases;
  late MockLLMRepository mockRepository;

  setUp(() {
    mockRepository = MockLLMRepository();
    llmUsecases = LLMUsecases(mockRepository);
  });

  group('LLMUsecases', () {
    group('generateCompleteTaskFromTitle', () {
      test('should generate complete task data successfully', () async {
        // Arrange
        const title = 'Plan weekly meeting';
        final expectedTaskData = TaskFormData(
          description:
              'Plan and organize the weekly team meeting including agenda preparation and participant coordination.',
          tags: const ['meeting', 'planning', 'team', 'weekly'],
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
          assignedUser: 'Project Manager',
        );

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenAnswer((_) async => expectedTaskData);

        // Act
        final result = await llmUsecases.generateCompleteTaskFromTitle(title);

        // Assert
        expect(result, equals(expectedTaskData));
        verify(mockRepository.generateCompleteTaskFromTitle(title)).called(1);
      });

      test('should propagate repository exceptions', () async {
        // Arrange
        const title = 'Plan weekly meeting';
        const errorMessage = 'API key not configured';

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenThrow(Exception(errorMessage));

        // Act & Assert
        expect(
          () => llmUsecases.generateCompleteTaskFromTitle(title),
          throwsA(isA<Exception>()),
        );
        verify(mockRepository.generateCompleteTaskFromTitle(title)).called(1);
      });

      test('should handle empty title gracefully', () async {
        // Arrange
        const title = '';
        final expectedTaskData = TaskFormData(
          description: 'Please provide more details for this task.',
          tags: const <String>[],
          status: TaskStatus.pending,
          priority: TaskPriority.low,
          assignedUser: '',
        );

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenAnswer((_) async => expectedTaskData);

        // Act
        final result = await llmUsecases.generateCompleteTaskFromTitle(title);

        // Assert
        expect(result, equals(expectedTaskData));
        verify(mockRepository.generateCompleteTaskFromTitle(title)).called(1);
      });

      test('should handle very long titles', () async {
        // Arrange
        final longTitle = 'A' * 1000; // Título muy largo
        final expectedTaskData = TaskFormData(
          description:
              'Task with a very long title that needs proper handling.',
          tags: const ['long-title', 'edge-case'],
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
          assignedUser: 'System Admin',
        );

        when(mockRepository.generateCompleteTaskFromTitle(longTitle))
            .thenAnswer((_) async => expectedTaskData);

        // Act
        final result =
            await llmUsecases.generateCompleteTaskFromTitle(longTitle);

        // Assert
        expect(result, equals(expectedTaskData));
        verify(mockRepository.generateCompleteTaskFromTitle(longTitle))
            .called(1);
      });

      test('should handle special characters in title', () async {
        // Arrange
        const title = 'Plan meeting @#\$%^&*()[]{}|;:,.<>?';
        final expectedTaskData = TaskFormData(
          description: 'Task with special characters in the title.',
          tags: const ['special-chars', 'meeting'],
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
          assignedUser: 'Developer',
        );

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenAnswer((_) async => expectedTaskData);

        // Act
        final result = await llmUsecases.generateCompleteTaskFromTitle(title);

        // Assert
        expect(result, equals(expectedTaskData));
        verify(mockRepository.generateCompleteTaskFromTitle(title)).called(1);
      });
    });

    group('isConfigured', () {
      test('should return true when repository is configured', () {
        // Arrange
        when(mockRepository.isConfigured).thenReturn(true);

        // Act
        final result = llmUsecases.isConfigured;

        // Assert
        expect(result, isTrue);
        verify(mockRepository.isConfigured).called(1);
      });

      test('should return false when repository is not configured', () {
        // Arrange
        when(mockRepository.isConfigured).thenReturn(false);

        // Act
        final result = llmUsecases.isConfigured;

        // Assert
        expect(result, isFalse);
        verify(mockRepository.isConfigured).called(1);
      });
    });

    group('Error Handling', () {
      test('should handle network timeout errors', () async {
        // Arrange
        const title = 'Network test task';

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenThrow(Exception('Network timeout'));

        // Act & Assert
        expect(
          () => llmUsecases.generateCompleteTaskFromTitle(title),
          throwsA(
            allOf(
              isA<Exception>(),
              predicate<Exception>(
                  (e) => e.toString().contains('Network timeout')),
            ),
          ),
        );
      });

      test('should handle API rate limiting errors', () async {
        // Arrange
        const title = 'Rate limit test task';

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenThrow(Exception('Rate limit exceeded'));

        // Act & Assert
        expect(
          () => llmUsecases.generateCompleteTaskFromTitle(title),
          throwsA(
            allOf(
              isA<Exception>(),
              predicate<Exception>(
                  (e) => e.toString().contains('Rate limit exceeded')),
            ),
          ),
        );
      });

      test('should handle invalid API key errors', () async {
        // Arrange
        const title = 'API key test task';

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenThrow(Exception('Invalid API key'));

        // Act & Assert
        expect(
          () => llmUsecases.generateCompleteTaskFromTitle(title),
          throwsA(
            allOf(
              isA<Exception>(),
              predicate<Exception>(
                  (e) => e.toString().contains('Invalid API key')),
            ),
          ),
        );
      });
    });

    group('Performance and Edge Cases', () {
      test('should handle null or whitespace-only titles', () async {
        // Arrange
        const title = '   \n\t   ';
        final expectedTaskData = TaskFormData(
          description: 'Please provide a valid title for this task.',
          tags: const <String>[],
          status: TaskStatus.pending,
          priority: TaskPriority.low,
          assignedUser: '',
        );

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenAnswer((_) async => expectedTaskData);

        // Act
        final result = await llmUsecases.generateCompleteTaskFromTitle(title);

        // Assert
        expect(result, equals(expectedTaskData));
        verify(mockRepository.generateCompleteTaskFromTitle(title)).called(1);
      });

      test('should handle unicode characters in title', () async {
        // Arrange
        const title = 'Reunión semanal 🚀 プロジェクト会議 المشروع اجتماع';
        final expectedTaskData = TaskFormData(
          description: 'International task with unicode characters.',
          tags: const ['meeting', 'international', 'unicode'],
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
          assignedUser: 'International Team Lead',
        );

        when(mockRepository.generateCompleteTaskFromTitle(title))
            .thenAnswer((_) async => expectedTaskData);

        // Act
        final result = await llmUsecases.generateCompleteTaskFromTitle(title);

        // Assert
        expect(result, equals(expectedTaskData));
        verify(mockRepository.generateCompleteTaskFromTitle(title)).called(1);
      });
    });
  });
}
