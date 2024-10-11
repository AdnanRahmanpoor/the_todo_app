import 'package:flutter/foundation.dart';

class Todo {
  final String id;
  final String description;
  bool completed;

  Todo({required this.id, required this.description, this.completed = false});

  void toggleCompleted() {
    completed = !completed;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'completed': completed,
      };

  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      description: json['description'],
      completed: json['completed'],
    );
  }
}
