import 'package:cloud_firestore/cloud_firestore.dart';

//todo -- add user coordinates
class Users {
  String? userName;
  String? photoUrl;
  String? phoneNumber;
  String? id;
  String? type;
  String? dateJoined;
  GeoPoint? location;

  Users.userName({this.userName});

  Users.photoUrl({this.photoUrl});

  Users.location({this.location});

  Users(
      {this.userName,
      required this.photoUrl,
      required this.phoneNumber,
      required this.id,
      required this.type,
      required this.dateJoined,
      required this.location});

  get getUserName => userName;

  get getImageUrl => photoUrl;

  set setUserName(String? userName) {
    this.userName = userName;
  }

  set setPhotoUrl(String? photoUrl) {
    this.photoUrl = photoUrl;
  }

  factory Users.fromDocument(DocumentSnapshot documentSnapshot) {
    return Users(
        id: documentSnapshot['id'],
        userName: documentSnapshot['userName'],
        phoneNumber: documentSnapshot['phoneNumber'],
        photoUrl: documentSnapshot['photoUrl'],
        dateJoined: documentSnapshot['dateJoined'],
        type: documentSnapshot['type'],
        location: documentSnapshot['location']);
  }

  Map<String, dynamic> updateUserNameToMap() {
    return {
      'userName': userName,
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
      'userName': userName,
      'dateJoined': dateJoined,
      'type': type,
      'photoUrl': photoUrl,
      'location': location
    };
  }
}

class Artisans {
  final String artisanName;
  final String photoUrl;
  final String phoneNumber;
  final String id;
  final String dateJoined;
  final String category;
  final String type;
  final String expLevel;
  final List<String> artworkUrl;
  GeoPoint? location;

  Artisans(
      {required this.artisanName,
      required this.photoUrl,
      required this.phoneNumber,
      required this.id,
      required this.dateJoined,
      required this.category,
      required this.type,
      required this.artworkUrl,
      required this.expLevel,
      required this.location});

  get getArtisanName => artisanName;

  get getImageUrl => photoUrl;

  //for bloc
  factory Artisans.fromDocument(DocumentSnapshot documentSnapshot) {
    return Artisans(
        id: documentSnapshot['id'],
        artisanName: documentSnapshot['artisanName'],
        phoneNumber: documentSnapshot['phoneNumber'],
        photoUrl: documentSnapshot['photoUrl'],
        dateJoined: documentSnapshot['dateJoined'],
        category: documentSnapshot['category'],
        type: documentSnapshot['type'],
        expLevel: documentSnapshot['expLevel'],
        artworkUrl:
            List<String>.from(documentSnapshot["artworkUrl"].map((x) => x)),
        location: documentSnapshot['location']);
  }

  //for provider
  factory Artisans.fromFirestore(Map<String, dynamic> data) {
    return Artisans(
        id: data['id'],
        artisanName: data['artisanName'],
        phoneNumber: data['phoneNumber'],
        photoUrl: data['photoUrl'],
        dateJoined: data['dateJoined'],
        category: data['category'],
        type: data['type'],
        expLevel: data['expLevel'],
        artworkUrl: List<String>.from(data["artworkUrl"].map((x) => x)),
        location: data['location']);
  }

  Map<String, dynamic> artisanToMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'artisanName': artisanName,
      'dateJoined': dateJoined,
      'category': category,
      'type': type,
      'expLevel': expLevel,
      'photoUrl': photoUrl,
      'artworkUrl': artworkUrl,
      'location': location
    };
  }
}
