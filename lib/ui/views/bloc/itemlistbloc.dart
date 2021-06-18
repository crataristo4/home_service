/*
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'datasource/FirebaseDataSourceProvider.dart';


class ItemsListBloc {
  FirebaseDataProvider firebaseDataProvider;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> listItemController;

  BehaviorSubject<bool>? showIndicatorController;

   ItemsListBloc() {
    listItemController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseDataProvider = FirebaseDataProvider();
    documentList = [];
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get itemListStream =>
      listItemController.stream;

*/
/*This method will automatically fetch first 10 elements from the document list */ /*

  Future fetchFirstList(CollectionReference collectionReference) async {
    try {
      documentList =
          await firebaseDataProvider.fetchFirstList(collectionReference);
      listItemController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          listItemController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      listItemController.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      listItemController.sink.addError(e);
    }
  }

*/
/*This will automatically fetch the next 10 elements from the list*/ /*

  fetchNextMovies(CollectionReference collectionReference) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await firebaseDataProvider
          .fetchNextList(collectionReference, documentList);
      documentList.addAll(newDocumentList);
      listItemController.sink.add(documentList);
      print("Fetching next list");
      try {
        if (documentList.length == 0) {
          listItemController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      listItemController.sink
          .addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      listItemController.sink.addError(e);
    }
  }

*/
/*For updating the indicator below every list and paginate*/ /*

  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    listItemController.close();
    showIndicatorController.close();
  }
}
*/
