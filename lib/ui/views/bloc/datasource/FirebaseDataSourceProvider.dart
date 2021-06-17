import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataProvider {
  Future<List<DocumentSnapshot>> fetchFirstList(
      CollectionReference collectionReference) async {
    return (await collectionReference.orderBy("projectName").limit(10).get())
        .docs;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      CollectionReference collectionReference,
      List<DocumentSnapshot> documentList) async {
    return (await collectionReference
            .orderBy("projectName")
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .get())
        .docs;
  }
}
