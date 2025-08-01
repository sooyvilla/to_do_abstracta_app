import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

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
    test('should generate task description through repository', () async {
      const prompt = 'Plan weekly meeting';
      const expectedDescription = 'Plan and organize the weekly team meeting including agenda preparation and participant coordination.';
      when(mockRepository.generateTaskDescription(prompt))
          .thenAnswer((_) async => expectedDescription);

      final result = await llmUsecases.generateTaskDescription(prompt);

      expect(result, equals(expectedDescription));
      verify(mockRepository.generateTaskDescription(prompt)).called(1);
    });

    test('should generate task tags through repository', () async {
      const title = 'Weekly Meeting';
      const description = 'Plan and organize the weekly team meeting';
      const expectedTags = ['meeting', 'planning', 'team', 'weekly'];
      when(mockRepository.generateTaskTags(title, description))
          .thenAnswer((_) async => expectedTags);

      final result = await llmUsecases.generateTaskTags(title, description);

      expect(result, equals(expectedTags));
      verify(mockRepository.generateTaskTags(title, description)).called(1);
    });
  });
}
