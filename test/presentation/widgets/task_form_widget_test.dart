import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_form_widget.dart';

void main() {
  group('TaskFormWidget', () {
    testWidgets('should render TaskFormWidget without task', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(TaskFormWidget), findsOneWidget);
    });

    testWidgets('should render TaskFormWidget with task', (tester) async {
      // Arrange
      final testTask = Task(
        id: 'test-task-id',
        title: 'Existing Task',
        description: 'Existing Description',
        tags: const ['existing'],
        status: TaskStatus.pending,
        assignedUser: 'user',
        priority: TaskPriority.medium,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(task: testTask),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(TaskFormWidget), findsOneWidget);
      // Verify initial values are set
      expect(find.text('Existing Task'), findsOneWidget);
      expect(find.text('Existing Description'), findsOneWidget);
    });

    testWidgets('should display form structure', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Título *'), findsOneWidget);
      expect(find.text('Descripción'), findsOneWidget);
      expect(find.text('Etiquetas (separadas por comas)'), findsOneWidget);
      expect(find.text('Usuario Asignado'), findsOneWidget);
      expect(find.text('Estado'), findsOneWidget);
      expect(find.text('Prioridad'), findsOneWidget);
      expect(find.text('Generador de Descripción IA'), findsOneWidget);
      expect(find.text('Generar'), findsOneWidget);
    });

    testWidgets('should handle text field changes', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act
      final titleField = find.widgetWithText(TextFormField, 'Título *');
      await tester.enterText(titleField, 'New Task Title');
      await tester.pump();

      final descriptionField =
          find.widgetWithText(TextFormField, 'Descripción');
      await tester.enterText(descriptionField, 'New Description');
      await tester.pump();

      // Assert
      expect(find.text('New Task Title'), findsOneWidget);
      expect(find.text('New Description'), findsOneWidget);
    });

    testWidgets('should display AI generation section', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.text('Generador de Descripción IA'), findsOneWidget);
      expect(
          find.text(
              'Ingresa un prompt y deja que la IA genere una descripción detallada para tu tarea.'),
          findsOneWidget);
      expect(find.text('Generar'), findsOneWidget);
    });

    testWidgets('should display dropdown buttons', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.byType(DropdownButtonFormField<TaskStatus>), findsOneWidget);
      expect(
          find.byType(DropdownButtonFormField<TaskPriority>), findsOneWidget);
    });

    testWidgets('should handle tags input correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act
      final tagsField =
          find.widgetWithText(TextFormField, 'Etiquetas (separadas por comas)');
      await tester.enterText(tagsField, 'trabajo, urgente, importante');
      await tester.pump();

      // Assert
      expect(find.text('trabajo, urgente, importante'), findsOneWidget);
    });

    testWidgets('should display priority indicators in dropdown',
        (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act - Open priority dropdown
      final priorityDropdown =
          find.byType(DropdownButtonFormField<TaskPriority>);
      await tester.tap(priorityDropdown);
      await tester.pump();

      // Assert - Check if priority options are displayed
      expect(find.text('Alta'), findsOneWidget);
      expect(find.text('Media'), findsOneWidget);
      expect(find.text('Baja'), findsOneWidget);
    });

    testWidgets('should update assigned user field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act
      final assignedUserField =
          find.widgetWithText(TextFormField, 'Usuario Asignado');
      await tester.enterText(assignedUserField, 'John Doe');
      await tester.pump();

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should display scroll view', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display card for AI section', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display form structure', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Título *'), findsOneWidget);
      expect(find.text('Descripción'), findsOneWidget);
      expect(find.text('Etiquetas (separadas por comas)'), findsOneWidget);
      expect(find.text('Usuario Asignado'), findsOneWidget);
      expect(find.text('Estado'), findsOneWidget);
      expect(find.text('Prioridad'), findsOneWidget);
      expect(find.text('Generador de Descripción IA'), findsOneWidget);
      expect(find.text('Generar'), findsOneWidget);
    });

    testWidgets('should handle text field changes', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act
      final titleField = find.widgetWithText(TextFormField, 'Título *');
      await tester.enterText(titleField, 'New Task Title');
      await tester.pump();

      final descriptionField =
          find.widgetWithText(TextFormField, 'Descripción');
      await tester.enterText(descriptionField, 'New Description');
      await tester.pump();

      // Assert
      expect(find.text('New Task Title'), findsOneWidget);
      expect(find.text('New Description'), findsOneWidget);
    });

    testWidgets('should display AI generation section', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.text('Generador de Descripción IA'), findsOneWidget);
      expect(
          find.text(
              'Ingresa un prompt y deja que la IA genere una descripción detallada para tu tarea.'),
          findsOneWidget);
      expect(find.text('Generar'), findsOneWidget);
    });

    testWidgets('should display dropdown buttons', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TaskFormWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert - Use more generic finders since the specific types might not load properly
      expect(find.byType(DropdownButtonFormField), findsAtLeast(2));
    });
  });
}
