import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataProvider {
  //todo - get location coordinates and sort based on that
  Future<List<DocumentSnapshot>> fetchInitialList(
      CollectionReference collectionReference, String category) async {
    return (await collectionReference
            .orderBy("name")
            .where("category", isEqualTo: category)
            .limit(10)
            .get())
        .docs;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      CollectionReference collectionReference,
      List<DocumentSnapshot> documentList,
      String category) async {
    return (await collectionReference
            .orderBy("name")
            .where("category", isEqualTo: category)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .get())
        .docs;
  }
}
