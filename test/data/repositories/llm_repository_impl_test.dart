import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_abstracta_app/data/datasources/llm_datasource.dart';
import 'package:to_do_abstracta_app/data/repositories/llm_repository_impl.dart';

import 'llm_repository_impl_test.mocks.dart';

@GenerateMocks([LLMDatasource])
void main() {
  late LLMRepositoryImpl repository;
  late MockLLMDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockLLMDatasource();
    repository = LLMRepositoryImpl(mockDatasource);
  });

  group('LLMRepositoryImpl', () {
    test('should generate task description through datasource', () async {
      const prompt = 'Test task';
      const expectedDescription = 'Generated description';
      when(mockDatasource.generateTaskDescription(prompt))
          .thenAnswer((_) async => expectedDescription);

      // ignore: deprecated_member_use_from_same_package
      final result = await repository.generateTaskDescription(prompt);

      expect(result, expectedDescription);
      verify(mockDatasource.generateTaskDescription(prompt)).called(1);
    });

    test('should generate task tags through datasource', () async {
      const title = 'Test task';
      const description = 'Test description';
      const expectedTags = ['tag1', 'tag2'];
      when(mockDatasource.generateTaskTags(title, description))
          .thenAnswer((_) async => expectedTags);

      // ignore: deprecated_member_use_from_same_package
      final result = await repository.generateTaskTags(title, description);

      expect(result, expectedTags);
      verify(mockDatasource.generateTaskTags(title, description)).called(1);
    });
  });
}
