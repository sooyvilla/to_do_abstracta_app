import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/core/di/injection.dart';
import 'package:to_do_abstracta_app/domain/usecases/llm_usecases.dart';
import 'package:to_do_abstracta_app/data/repositories/llm_repository_impl.dart';
import 'package:to_do_abstracta_app/data/datasources/llm_datasource.dart';

void main() {
  group('Injection/DI Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide LLMUsecases instance', () {
      // Act
      final llmUsecases = container.read(llmUsecasesProvider);

      // Assert
      expect(llmUsecases, isA<LLMUsecases>());
    });

    test('should provide LLMRepositoryImpl instance', () {
      // Act
      final llmRepository = container.read(llmRepositoryProvider);

      // Assert
      expect(llmRepository, isA<LLMRepositoryImpl>());
    });

    test('should provide LLMDatasourceImpl instance', () {
      // Act
      final llmDatasource = container.read(llmDatasourceProvider);

      // Assert
      expect(llmDatasource, isA<LLMDatasourceImpl>());
    });

    test(
        'should provide same LLM instance on multiple calls (singleton behavior)',
        () {
      // Act
      final llmUsecases1 = container.read(llmUsecasesProvider);
      final llmUsecases2 = container.read(llmUsecasesProvider);

      // Assert
      expect(identical(llmUsecases1, llmUsecases2), true);
    });

    test('should provide same LLM datasource instance on multiple calls', () {
      // Act
      final llmDatasource1 = container.read(llmDatasourceProvider);
      final llmDatasource2 = container.read(llmDatasourceProvider);

      // Assert
      expect(identical(llmDatasource1, llmDatasource2), true);
    });

    test('should provide same LLM repository instance on multiple calls', () {
      // Act
      final llmRepository1 = container.read(llmRepositoryProvider);
      final llmRepository2 = container.read(llmRepositoryProvider);

      // Assert
      expect(identical(llmRepository1, llmRepository2), true);
    });
  });
}
