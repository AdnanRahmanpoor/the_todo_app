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

            return Dismissible(
              key: Key(todo.id),
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.check, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.horizontal,
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text(
                            'Are you sure you want to delete ${todo.title}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (direction == DismissDirection.startToEnd) {
                  // Confirm completion
                  // PLaceholder for completion logic
                }
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  Provider.of<TodoListProvider>(context, listen: false)
                      .deleteTodo(todo.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task Deleted')),
                  );
                } else if (direction == DismissDirection.startToEnd) {
                  Provider.of<TodoListProvider>(context, listen: false)
                      .toggleTodoCompletion(todo.id);

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Task Marked Completed.')),
                  // );
                }
              },
              child: Card(
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
                ),
              ),
            );
          },
        );
      },
    );
  }
}
