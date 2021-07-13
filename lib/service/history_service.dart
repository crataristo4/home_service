import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_service/models/history.dart';

class HistoryService {
  final firestoreService = FirebaseFirestore.instance;

  //create history
  Future<void> createHistory(History history, String artisanId) {
    return firestoreService
        .collection('Users')
        .doc(artisanId)
        .collection('History')
        .add(history.historyToMap())
        .whenComplete(() {})
        .catchError((error) {
      print('Error $error');
    });
  }

/*  //get all history
  Stream<List<History>> fetchHistory() {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .collection('History')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) => event.docs.map((snapshots) {
              return History.fromFirestore(snapshots.data());
            }).toList(growable: true));
  }*/
}
