import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_service/ui/views/auth/appstate.dart';

class FirebaseDataProvider {
  //todo - get location coordinates and sort based on that
  Future<List<DocumentSnapshot>> fetchInitialList(
      CollectionReference collectionReference, String category) async {
    return (await collectionReference
            .where("id", isNotEqualTo: currentUserId)
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
            .where("id", isNotEqualTo: currentUserId)
            .where("category", isEqualTo: category)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(10)
            .get())
        .docs;
  }
}
