import 'package:get/get.dart';
import 'package:re_exam/model/book_model.dart';

import '../helper/db_helper.dart';
import '../helper/firebase_helper.dart';

class BookController extends GetxController {
  final DBHelper dbHelper = DBHelper();
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  var items = <BookModel>[].obs; // All items
  var filteredItems = <BookModel>[].obs; // Filtered items based on search

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await dbHelper.getItems();
    items.assignAll(data);
    filteredItems.assignAll(data); // Initially, all items are shown in the filtered list
  }

  Future<void> addItem(String title, String author, String status) async {
    final newItem = BookModel(
      title: title,
      author: author,
      status: status,
    );
    await dbHelper.insertItem(newItem);
    fetchData();
  }

  Future<void> deleteItem(int id) async {
    await dbHelper.deleteItem(id);
    fetchData();
  }



  Future<void> editItem(BookModel updatedItem) async {
    await dbHelper.updateItem(updatedItem);
    fetchData();
  }

  Future<void> Firebase() async {
    await _firebaseHelper.uploadFirestore(items);
    final item = await _firebaseHelper.fetchItemsFromFirestore();
    await dbHelper.syncLocalDatabase(item);
    fetchData();
  }


  void filterItems(String query) {
    if (query.isEmpty) {

      filteredItems.assignAll(items);
    } else {
      final filtered = items.where((item) {
        return item.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredItems.assignAll(filtered);
    }
  }
}
