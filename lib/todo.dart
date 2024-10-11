import 'package:flutter/foundation.dart';

class Todo {
  final String id;
  final String title;
  final String? description;
  bool completed;

  Todo({required this.id, required this.title, this.description, this.completed = false});

  void toggleCompleted() {
    completed = !completed;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'completed': completed,
      };

  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }
}
