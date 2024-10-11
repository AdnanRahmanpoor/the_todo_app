import 'package:flutter/foundation.dart';

class Todo {
  final String id;
  final String description;
  bool completed;

  Todo({required this.id, required this.description, this.completed = false});

  void toggleCompleted() {
    completed = !completed;
  }
}
