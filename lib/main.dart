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
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Task Description'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String description = controller.text;
                if (description.isNotEmpty) {
                  Provider.of<TodoListProvider>(context, listen: false)
                      .addTodo(description);
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
    // TODO: implement build
    return Consumer<TodoListProvider>(
      builder: (context, todoListProvider, child) {
        return ListView.builder(
          itemCount: todoListProvider.todos.length,
          itemBuilder: (context, index) {
            final todo = todoListProvider.todos[index];
            return ListTile(
              title: Text(todo.description,
                  style: TextStyle(
                      decoration:
                          todo.completed ? TextDecoration.lineThrough : null)),
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
            );
          },
        );
      },
    );
  }
}
