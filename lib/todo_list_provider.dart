import 'package:flutter/material.dart';
import 'todo.dart';

class TodoListProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String description) {
    final todo = Todo(
      id: DateTime.now().toString(),
      description: description,
    );
    _todos.add(todo);
    notifyListeners();
  }

  void toggleTodoCompletion(String id) {
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.toggleCompleted();
    notifyListeners();
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
