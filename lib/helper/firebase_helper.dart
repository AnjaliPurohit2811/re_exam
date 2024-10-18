

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:re_exam/model/book_model.dart';


class FirebaseHelper {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadFirestore(List<BookModel> items) async {
    try {
      final collection =  firestore.collection('books');
      for (var item in items) {
        await collection.doc(item.id.toString()).set(item.toMap());
      }
      print('Data uploaded successfully');
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  Future<List<BookModel>> fetchItemsFromFirestore() async {
    final collection = firestore.collection('books');
    final snapshot = await collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return BookModel.fromMap(data);
    }).toList();
  }
}
