import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo.dart';

class TodoListProvider with ChangeNotifier {
  List<Todo> _todos = [];

  TodoListProvider() {
    loadTodos();
  }

  List<Todo> get todos => _todos;

  void addTodo(String title, String? description) {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      description: description,
    );
    _todos.add(todo);
    saveTodos();
    notifyListeners();
  }

  void toggleTodoCompletion(String id) {
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.toggleCompleted();
    saveTodos();
    notifyListeners();
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    saveTodos();
    notifyListeners();
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todoStrings =
        _todos.map((todo) => json.encode(todo.toJson())).toList();
    await prefs.setStringList('todos', todoStrings);
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todoStrings = prefs.getStringList('todos');

    if (todoStrings != null) {
      _todos = todoStrings
          .map((todoString) => Todo.fromJson(json.decode(todoString)))
          .toList();
      notifyListeners();
    }
  }
}
