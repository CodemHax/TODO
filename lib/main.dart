import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navgi/item_provider.dart';
import 'package:navgi/item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: MaterialApp(home: Page()));
  }
}

class Page extends ConsumerStatefulWidget {
  Page({super.key});

  @override
  ConsumerState<Page> createState() => _PageState();
}

class _PageState extends ConsumerState<Page> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _editingController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("TODO"),
        backgroundColor: Colors.blueAccent,
      ),
      body: list.isEmpty
          ? Center(
              child: Text(
                "No Tasks Yet",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: Colors.blue.shade900,
                        child: Text(
                          item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showEditDialog(context, item),
                            icon: Icon(Icons.edit, color: Colors.orange),
                          ),
                          IconButton(
                            onPressed: () {
                              ref.read(itemsProvider.notifier).removeItem(item.id);
                            },
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Task"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter task name"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.clear();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final taskName = _controller.text.trim();
                if (taskName.isNotEmpty) {
                  ref.read(itemsProvider.notifier).addItem(taskName);
                  Navigator.of(context).pop();
                  _controller.clear();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Item item) {
    _editingController.text = item.name;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: TextField(
            controller: _editingController,
            decoration: InputDecoration(hintText: "Enter new task name"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editingController.clear();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = _editingController.text.trim();
                if (newName.isNotEmpty && newName != item.name) {
                  ref.read(itemsProvider.notifier).updateItem(item.id, newName);
                }
                Navigator.of(context).pop();
                _editingController.clear();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
