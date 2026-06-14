import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> collection(String path) {
    return _db.collection(path);
  }

  static Future<String> create({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final doc = collection(collectionPath).doc();

    await doc.set({
      'id': doc.id,
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  static Future<void> update({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await collection(
      collectionPath,
    ).doc(docId).update({...data, 'updatedAt': FieldValue.serverTimestamp()});
  }

  static Future<void> set({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    await collection(collectionPath).doc(docId).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: merge));
  }

  static Future<void> delete({
    required String collectionPath,
    required String docId,
  }) async {
    await collection(collectionPath).doc(docId).delete();
  }

  static Future<Map<String, dynamic>?> get({
    required String collectionPath,
    required String docId,
  }) async {
    final doc = await collection(collectionPath).doc(docId).get();

    if (!doc.exists || doc.data() == null) return null;

    return {'id': doc.id, ...doc.data()!};
  }

  static Stream<List<Map<String, dynamic>>> watchCollection({
    required String collectionPath,
    String orderBy = 'createdAt',
    bool descending = true,
  }) {
    return collection(
      collectionPath,
    ).orderBy(orderBy, descending: descending).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    });
  }
}
