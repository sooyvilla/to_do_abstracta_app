import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/domain/models/task_form_data.dart';
import 'package:to_do_abstracta_app/domain/usecases/llm_usecases.dart';
import 'package:to_do_abstracta_app/domain/usecases/task_usecases.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_form_widget.dart';

// Mocks
class MockTaskUsecases extends Mock implements TaskUsecases {}

class MockLLMUsecases extends Mock implements LLMUsecases {}

void main() {
  late MockTaskUsecases mockTaskUsecases;
  late MockLLMUsecases mockLLMUsecases;

  setUp(() {
    mockTaskUsecases = MockTaskUsecases();
    mockLLMUsecases = MockLLMUsecases();
  });

  Widget createWidgetUnderTest({Task? task}) {
    return ProviderScope(
      overrides: [
        taskFormProvider.overrideWith(
          (ref) => TaskFormNotifier(mockTaskUsecases, mockLLMUsecases),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: TaskFormWidget(task: task),
        ),
      ),
    );
  }

  group('TaskFormWidget', () {
    testWidgets('should display all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verificar que todos los campos están presentes
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(DropdownButtonFormField<TaskStatus>), findsOneWidget);
      expect(
          find.byType(DropdownButtonFormField<TaskPriority>), findsOneWidget);

      // Verificar etiquetas de campos
      expect(find.text('Título *'), findsOneWidget);
      expect(find.text('Descripción'), findsOneWidget);
      expect(find.text('Etiquetas (separadas por comas)'), findsOneWidget);
      expect(find.text('Usuario Asignado'), findsOneWidget);
      expect(find.text('Estado'), findsOneWidget);
      expect(find.text('Prioridad'), findsOneWidget);
    });

    testWidgets('should show validation error for empty title',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Encontrar el campo de título y simular validación
      final titleField = find.byType(TextFormField).first;
      await tester.tap(titleField);
      await tester.pump();

      // Obtener el Form widget y validar
      final formFinder = find.byType(Form);
      final form = tester.widget<Form>(formFinder);
      final globalKey = form.key as GlobalKey<FormState>;
      final isValid = globalKey.currentState!.validate();

      expect(isValid, false);
    });

    testWidgets('should display AI generation button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Autocompletar con IA'), findsOneWidget);
      expect(find.byIcon(Icons.auto_fix_high), findsOneWidget);
    });

    testWidgets('should pre-populate fields when editing task',
        (WidgetTester tester) async {
      final testTask = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['tag1', 'tag2'],
        status: TaskStatus.inProgress,
        assignedUser: 'John Doe',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      );

      await tester.pumpWidget(createWidgetUnderTest(task: testTask));
      await tester.pump(); // Esperar a que se ejecuten los callbacks

      // Verificar que los campos se pre-populan correctamente
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('tag1, tag2'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should show loading state during AI generation',
        (WidgetTester tester) async {
      // Configurar mock para simular generación de IA en progreso
      when(mockLLMUsecases.isConfigured).thenReturn(true);
      when(mockLLMUsecases.generateCompleteTaskFromTitle('Test Title'))
          .thenAnswer((_) async {
        // Simular delay
        await Future.delayed(const Duration(milliseconds: 100));
        return TaskFormData(
          description: 'Generated description',
          tags: const ['generated'],
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
          assignedUser: 'Generated User',
        );
      });

      await tester.pumpWidget(createWidgetUnderTest());

      // Ingresar título
      final titleField = find.byType(TextFormField).first;
      await tester.enterText(titleField, 'Test Title');
      await tester.pump();

      // Presionar botón de IA
      final aiButton = find.text('Autocompletar con IA');
      await tester.tap(aiButton);
      await tester.pump();

      // Verificar estado de carga
      expect(find.text('Generando...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle tag input correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Encontrar campo de etiquetas
      final tagsField =
          find.byType(TextFormField).at(2); // Tercer TextFormField
      await tester.enterText(tagsField, 'trabajo, urgente, reunión');
      await tester.pump();

      // El estado debería actualizarse a través del callback onChanged
      // Esto se verificaría mejor con un test de integración que acceda al estado
    });

    testWidgets('should show error message when present',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Simular un estado de error
      // Esto requeriría acceso al provider para establecer un error
      // En un test real, se podría usar un mock del provider
    });

    group('Form Validation', () {
      testWidgets('should require title field', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final titleField = find.byType(TextFormField).first;

        // Enfocar el campo y dejarlo vacío
        await tester.tap(titleField);
        await tester.enterText(titleField, '');
        await tester.pump();

        // Validar formulario
        final formFinder = find.byType(Form);
        final form = tester.widget<Form>(formFinder);
        final globalKey = form.key as GlobalKey<FormState>;
        final isValid = globalKey.currentState!.validate();

        expect(isValid, false);
      });

      testWidgets('should accept valid title', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final titleField = find.byType(TextFormField).first;

        await tester.tap(titleField);
        await tester.enterText(titleField, 'Valid Title');
        await tester.pump();

        // Validar formulario
        final formFinder = find.byType(Form);
        final form = tester.widget<Form>(formFinder);
        final globalKey = form.key as GlobalKey<FormState>;
        final isValid = globalKey.currentState!.validate();

        expect(isValid, true);
      });
    });
  });
}
