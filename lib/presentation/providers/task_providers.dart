import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/core/di/injection.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/domain/usecases/llm_usecases.dart';
import 'package:to_do_abstracta_app/domain/usecases/task_usecases.dart';

/// Provider para controlar la visibilidad del campo de búsqueda.
final searchVisibilityProvider = StateProvider<bool>((ref) => false);

/// Proveedor que observa la lista de tareas en tiempo real.
///
/// Retorna un stream que se actualiza automáticamente cuando
/// las tareas cambian en el repositorio.
final taskListProvider = StreamProvider<List<Task>>((ref) {
  try {
    final usecases = ref.watch(taskUsecasesProvider);
    return usecases.watchTasks();
  } catch (e) {
    return Stream.error(e);
  }
});

/// Proveedor que calcula y proporciona estadísticas de tareas.
///
/// Obtiene métricas como total de tareas, completadas, pendientes,
/// en progreso y tasa de finalización.
final taskStatisticsProvider = FutureProvider<TaskStatistics>((ref) {
  final usecases = ref.watch(taskUsecasesProvider);
  return usecases.getTaskStatistics();
});

/// Proveedor familia que obtiene una tarea específica por ID.
///
/// Observa cambios en la tarea y retorna null si no existe.
final taskByIdProvider = StreamProvider.family<Task?, String>((ref, taskId) {
  final usecases = ref.watch(taskUsecasesProvider);
  return usecases.watchTasks().map((tasks) {
    try {
      return tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  });
});

/// Proveedor de estado para la consulta de búsqueda.
///
/// Almacena el texto de búsqueda actual para filtrar tareas.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Proveedor que filtra las tareas basado en la consulta de búsqueda.
///
/// Retorna todas las tareas si no hay consulta, o tareas filtradas
/// que coincidan en título, descripción o etiquetas.
final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return tasksAsync.when(
    data: (tasks) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(tasks);
      }

      final filteredTasks = tasks.where((task) {
        final query = searchQuery.toLowerCase();
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query) ||
            task.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();

      return AsyncValue.data(filteredTasks);
    },
    loading: () {
      return const AsyncValue.loading();
    },
    error: (error, stack) {
      return AsyncValue.error(error, stack);
    },
  );
});

final taskFormProvider =
    StateNotifierProvider<TaskFormNotifier, TaskFormState>((ref) {
  final taskUsecases = ref.watch(taskUsecasesProvider);
  final llmUsecases = ref.watch(llmUsecasesProvider);
  return TaskFormNotifier(taskUsecases, llmUsecases);
});

/// Estado del formulario de tarea.
///
/// Encapsula todos los datos del formulario para crear o editar
/// una tarea, incluyendo información de carga y errores.
class TaskFormState {
  final String title;
  final String description;
  final List<String> tags;
  final TaskStatus status;
  final String assignedUser;
  final TaskPriority priority;
  final bool isLoading;
  final DateTime? createdAt;
  final String? error;
  final bool isGeneratingDescription;

  TaskFormState(
      {this.title = '',
      this.description = '',
      this.tags = const [],
      this.status = TaskStatus.pending,
      this.assignedUser = '',
      this.priority = TaskPriority.medium,
      this.isLoading = false,
      this.error,
      this.isGeneratingDescription = false,
      this.createdAt});

  /// Crea una copia del estado con los valores especificados actualizados.
  TaskFormState copyWith({
    String? title,
    String? description,
    List<String>? tags,
    TaskStatus? status,
    String? assignedUser,
    TaskPriority? priority,
    DateTime? createdAt,
    bool? isLoading,
    String? error,
    bool? isGeneratingDescription,
  }) {
    return TaskFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      assignedUser: assignedUser ?? this.assignedUser,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isGeneratingDescription:
          isGeneratingDescription ?? this.isGeneratingDescription,
    );
  }
}

/// Notificador para el estado del formulario de tarea.
///
/// Maneja las operaciones del formulario de tarea incluyendo
/// validación, guardado, generación de IA y gestión de estados.
class TaskFormNotifier extends StateNotifier<TaskFormState> {
  final TaskUsecases _taskUsecases;
  final LLMUsecases _llmUsecases;

  TaskFormNotifier(this._taskUsecases, this._llmUsecases)
      : super(TaskFormState());

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  Future<void> generateCompleteTaskFromTitle(String title) async {
    if (title.isEmpty) return;

    if (!_llmUsecases.isConfigured) {
      state = state.copyWith(
        error:
            'Gemini API key not configured. Please set up your API key in the code to use AI features.',
      );
      return;
    }

    state = state.copyWith(isGeneratingDescription: true, error: null);

    try {
      final taskData = await _llmUsecases.generateCompleteTaskFromTitle(title);
      state = state.copyWith(
        description: taskData.description,
        tags: taskData.tags,
        status: taskData.status,
        priority: taskData.priority,
        assignedUser: taskData.assignedUser,
        isGeneratingDescription: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString().contains('API key not configured')
            ? 'Gemini API key not configured. Please set up your API key to use AI features.'
            : 'Failed to generate complete task: $e',
        isGeneratingDescription: false,
      );
    }
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateTags(List<String> tags) {
    state = state.copyWith(tags: tags);
  }

  void updateStatus(TaskStatus status) {
    state = state.copyWith(status: status);
  }

  void updateAssignedUser(String assignedUser) {
    state = state.copyWith(assignedUser: assignedUser);
  }

  void updatePriority(TaskPriority priority) {
    state = state.copyWith(priority: priority);
  }

  Future<bool> saveTask({String? taskId}) async {
    if (state.title.isEmpty) {
      state = state.copyWith(error: 'Title is required');
      return false;
    } else if (state.error != null) {
      state = state.copyWith(error: null);
    }

    setLoading(true);

    try {
      final task = Task(
        id: taskId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: state.title,
        description: state.description,
        tags: state.tags,
        status: state.status,
        assignedUser: state.assignedUser,
        priority: state.priority,
        createdAt:
            taskId != null ? state.createdAt ?? DateTime.now() : DateTime.now(),
        updatedAt: taskId != null ? DateTime.now() : null,
      );

      if (taskId != null) {
        await _taskUsecases.updateTask(task);
      } else {
        await _taskUsecases.createTask(task);
      }

      setLoading(false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to save task: $e',
        isLoading: false,
      );
      return false;
    }
  }

  void loadTask(Task? task) {
    if (task == null) {
      state = TaskFormState();
      return;
    }

    state = state.copyWith(
      title: task.title,
      description: task.description,
      tags: task.tags,
      status: task.status,
      assignedUser: task.assignedUser,
      createdAt: task.createdAt,
      priority: task.priority,
    );
  }

  void reset() {
    state = TaskFormState();
  }

  bool isTaskNull() {
    return state.title.isEmpty &&
        state.description.isEmpty &&
        state.tags.isEmpty &&
        state.status == TaskStatus.pending &&
        state.assignedUser.isEmpty &&
        state.priority == TaskPriority.medium;
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}
