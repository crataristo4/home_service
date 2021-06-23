import 'package:cloud_firestore/cloud_firestore.dart';

//todo -- add user coordinates
class Users {
  final String userName;
  final String photoUrl;
  final String phoneNumber;
  final String id;
  final String type;
  final String dateJoined;
  GeoPoint? location;

  Users(
      {required this.userName,
      required this.photoUrl,
      required this.phoneNumber,
      required this.id,
      required this.type,
      required this.dateJoined,
      this.location});

  factory Users.fromDocument(DocumentSnapshot documentSnapshot) {
    return Users(
      id: documentSnapshot['id'],
      userName: documentSnapshot['userName'],
      phoneNumber: documentSnapshot['phoneNumber'],
      photoUrl: documentSnapshot['photoUrl'],
      dateJoined: documentSnapshot['dateJoined'],
      type: documentSnapshot['type'],
    );
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
      required this.expLevel});

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
    );
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
      'artworkUrl': artworkUrl
    };
  }
}
