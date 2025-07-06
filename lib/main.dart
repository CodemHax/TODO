import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navgi/item_provider.dart';

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
  Widget build(BuildContext context) {
    var list = ref.watch(itemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO"),
        backgroundColor: Colors.blueAccent,
      ),
      body: list.isEmpty
          ? Center(child: Text("No Note", style: TextStyle(fontSize: 20, color: Colors.grey)))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: Colors.blue.shade900,
                        child: Text(list[index].name.isNotEmpty ? list[index].name[0].toUpperCase() : '?'),
                      ),
                      title: Text(list[index].name, style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _editingController.text = list[index].name;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Edit TASK"),
                                    content: TextField(
                                      controller: _editingController,
                                      onChanged: (value){
                                        value = _editingController.text;
                                      },
                                      decoration: InputDecoration(hintText: "Enter new name"),
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
                                          ref.read(itemsProvider.notifier).updateItem(
                                            list[index].id,
                                            _editingController.text.trim(),
                                          );
                                          Navigator.of(context).pop();
                                          _editingController.clear();
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit, color: Colors.orange),
                          ),
                          IconButton(
                            onPressed: () {
                              ref.read(itemsProvider.notifier).removeItem(list[index].id);
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add New Task"),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "Enter task name"),
                  onChanged: (value) {
                    _controller.text = value;
                  },
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
                        ref.read(itemsProvider.notifier).addItem(_controller.text.trim());
                        Navigator.of(context).pop();
                        _controller.clear();
                      },
                      child: Text("OK")
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
