import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_list_provider.dart';
import 'todo.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoListProvider(),
      child: MaterialApp(
        title: 'Todo App',
        home: TodoApp(),
      ),
    ),
  );
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddTodoDialog(context),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }

  void _displayAddTodoDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Task Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Task Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String? description = descriptionController.text.isNotEmpty
                    ? descriptionController.text
                    : null;
                if (title.isNotEmpty) {
                  Provider.of<TodoListProvider>(context, listen: false)
                      .addTodo(title, description);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder: (context, todoListProvider, child) {
        return ListView.builder(
          itemCount: todoListProvider.todos.length,
          itemBuilder: (context, index) {
            final todo = todoListProvider.todos[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration:
                        todo.completed ? TextDecoration.lineThrough : null,
                    color: todo.completed ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: todo.description != null
                    ? Text(
                        todo.description!,
                        style: TextStyle(
                          color: todo.completed
                              ? Colors.grey
                              : const Color.fromARGB(255, 96, 96, 96),
                        ),
                      )
                    : null,
                trailing: Checkbox(
                  value: todo.completed,
                  onChanged: (value) {
                    Provider.of<TodoListProvider>(context, listen: false)
                        .toggleTodoCompletion(todo.id);
                  },
                ),
                onLongPress: () {
                  Provider.of<TodoListProvider>(context, listen: false)
                      .deleteTodo(todo.id);
                },
              ),
            );
          },
        );
      },
    );
  }
}
