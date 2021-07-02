import 'package:cloud_firestore/cloud_firestore.dart';

//todo -- add user coordinates
class Users {
  String? name;
  String? photoUrl;
  String? phoneNumber;
  String? id;
  String? type;
  String? dateJoined;
  GeoPoint? location;

  Users.name({this.name});

  Users.photoUrl({this.photoUrl});

  Users.location({this.location});

  Users(
      {this.name,
      required this.photoUrl,
      required this.phoneNumber,
      required this.id,
      required this.type,
      required this.dateJoined,
      required this.location});

  get getUserName => name;

  get getImageUrl => photoUrl;

  set setUserName(String? userName) {
    this.name = userName;
  }

  set setPhotoUrl(String? photoUrl) {
    this.photoUrl = photoUrl;
  }

  factory Users.fromDb(Map<String, dynamic> data) {
    return Users(
        id: data['id'],
        name: data['name'],
        phoneNumber: data['phoneNumber'],
        photoUrl: data['photoUrl'],
        dateJoined: data['dateJoined'],
        type: data['type'],
        location: data['location']);
  }

  Map<String, dynamic> updateUserNameToMap() {
    return {
      'name': name,
    };
  }

  Map<String, dynamic> updateUserPhotoToMap() {
    return {
      'photoUrl': photoUrl,
    };
  }

  Map<String, dynamic> updateUserLocationToMap() {
    return {
      'location': location,
    };
  }

  Map<String, dynamic> userToMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'dateJoined': dateJoined,
      'type': type,
      'photoUrl': photoUrl,
      'location': location
    };
  }
}

class Artisans {
  String? name;
  String? photoUrl;
  String? phoneNumber;
  String? id;
  String? dateJoined;
  String? category;
  String? type;
  String? expLevel;
  GeoPoint? location;

  Artisans(
      {required this.name,
      required this.photoUrl,
      required this.phoneNumber,
      required this.id,
      required this.dateJoined,
      required this.category,
      required this.type,
      required this.expLevel,
      required this.location});

  Artisans.expLevel({this.expLevel});

  Artisans.name({this.name});

  Artisans.location({this.location});

  get getArtisanName => name;

  get getImageUrl => photoUrl;

  //for bloc
  factory Artisans.fromDocument(DocumentSnapshot documentSnapshot) {
    return Artisans(
        id: documentSnapshot['id'],
        name: documentSnapshot['name'],
        phoneNumber: documentSnapshot['phoneNumber'],
        photoUrl: documentSnapshot['photoUrl'],
        dateJoined: documentSnapshot['dateJoined'],
        category: documentSnapshot['category'],
        type: documentSnapshot['type'],
        expLevel: documentSnapshot['expLevel'],
        location: documentSnapshot['location']);
  }

  //for provider
  factory Artisans.fromFirestore(Map<String, dynamic> data) {
    return Artisans(
        id: data['id'],
        name: data['name'],
        phoneNumber: data['phoneNumber'],
        photoUrl: data['photoUrl'],
        dateJoined: data['dateJoined'],
        category: data['category'],
        type: data['type'],
        expLevel: data['expLevel'],
        location: data['location']);
  }

  Map<String, dynamic> artisanToMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'dateJoined': dateJoined,
      'category': category,
      'type': type,
      'expLevel': expLevel,
      'photoUrl': photoUrl,
      'location': location
    };
  }

  Map<String, dynamic> updateArtisanNameToMap() {
    return {
      'name': name,
    };
  }

  Map<String, dynamic> updateExpLevelToMap() {
    return {
      'expLevel': expLevel,
    };
  }

  Map<String, dynamic> updateLocationToMap() {
    return {
      'location': location,
    };
  }
}
