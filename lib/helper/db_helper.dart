import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:re_exam/model/book_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  Future<Database> initDB() async {
    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), 'shopping_list.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            status TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  Future<List<BookModel>> getItems() async {
    final db = await initDB();
    final data = await db.query('items');
    return List.generate(data.length, (i) {
      return BookModel.fromMap(data[i]);
    });
  }

  Future<void> insertItem(BookModel item) async {
    final db = await initDB();
    await db.insert('items', item.toMap());
  }

  Future<void> deleteItem(int id) async {
    final db = await initDB();
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateItem(BookModel item) async {
    final db = await initDB();
    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> syncLocalDatabase(List<BookModel> cloudItems) async {
    final db = await initDB();
    for (var item in cloudItems) {
      await db.insert(
        'items', // ensure consistent table name
        item.toMap(),
      );
    }
  }

  Future<void> uploadItemsToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final items = await getItems();

    for (var item in items) {
      await firestore
          .collection('shopping_list')
          .doc(item.id.toString())
          .set(item.toMap());
    }
  }

  Future<void> fetchItemsFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('shopping_list').get();

    for (var doc in snapshot.docs) {
      BookModel item = BookModel(
        id: int.tryParse(doc.id),
        title: doc.data()['title'],
        author: doc.data()['author'],
        status: doc.data()['status'],
      );

      await insertItem(item);
    }
  }
}
