import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _favUsers = FirebaseFirestore.instance.collection(
    'favourite_users',
  );

  Future<void> addFavouriteUser(Map<String, dynamic> user) async {
    await _favUsers.add({...user, 'timestamp': FieldValue.serverTimestamp()});
  }

  Stream<QuerySnapshot> getFavouriteUsers() {
    return _favUsers.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> deleteFavouriteUser(String docId) async {
    await _favUsers.doc(docId).delete();
  }
}
