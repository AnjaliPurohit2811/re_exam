import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re_exam/controller/book_controller.dart';
import 'package:re_exam/model/book_model.dart';

import '../../controller/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  final BookController bookController = Get.put(BookController());
  final AuthController authController = Get.put(AuthController());
  final RxString searchQuery = ''.obs; // Observable to track the search query

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: const Text(
          'Book App',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sync,
              color: Colors.white,
            ),
            onPressed: () {
              bookController.Firebase();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
             // authController.logout(); // Add your logout logic here
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchQuery.value = value; // Update search query
              },
              decoration: InputDecoration(
                labelText: 'Search by title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          // List of filtered books
          Expanded(
            child: Obx(() {
              final filteredItems = bookController.items.where((item) {
                return item.title
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase());
              }).toList();

              if (filteredItems.isEmpty) {
                return const Center(
                  child: Text('No items found.'),
                );
              }

              return ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          item.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.author,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(item.status),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                bookController.deleteItem(item.id!);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showEditItemDialog(context, item);
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _showAddItemDialog(context);
        },
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    String title = '';
    String author = '';
    String status = 'Reading';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => title = value,
              decoration: const InputDecoration(labelText: 'Book Name'),
            ),
            TextField(
              onChanged: (value) => author = value,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            DropdownButton<String>(
              value: status,
              onChanged: (value) => status = value!,
              items: ['Reading', 'Completed', 'Half'].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (title.isNotEmpty) {
                bookController.addItem(title, author, status);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, BookModel item) {
    TextEditingController titleController = TextEditingController(text: item.title);
    TextEditingController authorController = TextEditingController(text: item.author);
    String status = item.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => item.title = value,
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title Name'),
            ),
            TextField(
              onChanged: (value) => item.author = value,
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            DropdownButton<String>(
              value: status,
              onChanged: (value) => status = value!,
              items: ['Reading', 'Completed', 'Half'].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (item.title.isNotEmpty) {
                final updatedItem = BookModel(
                  id: item.id,
                  title: titleController.text,
                  author: authorController.text,
                  status: status,
                );
                bookController.editItem(updatedItem);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
