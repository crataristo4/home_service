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
  List? ratedUsers = [];
  double? rating;

  GeoPoint? location;

  Artisans({required this.name,
    required this.photoUrl,
    required this.phoneNumber,
    required this.id,
    required this.dateJoined,
    required this.category,
    required this.type,
    required this.expLevel,
    required this.location,
    this.ratedUsers,
    required this.rating,});

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
        rating: documentSnapshot['rating'],
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
        rating: data['rating'],
        ratedUsers: data['ratedUsers'] ?? [],
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
      'rating': rating,
      'expLevel': expLevel,
      'photoUrl': photoUrl,
      'location': location,
      'ratedUsers': ratedUsers,
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

  static double? ratingApproach(double? ratedValue) {
    double? ratingPoints;
    if (ratedValue! <= 500) {
      ratingPoints = 0.5;
    } else if (ratedValue > 501 && ratedValue <= 1000) {
      ratingPoints = 1;
    } else if (ratedValue > 1000 && ratedValue <= 1499) {
      ratingPoints = 1.5;
    } else if (ratedValue > 1500 && ratedValue <= 2499) {
      ratingPoints = 2;
    } else if (ratedValue > 2499 && ratedValue < 3000) {
      ratingPoints = 2.5;
    } else if (ratedValue >= 3000 && ratedValue <= 3499) {
      ratingPoints = 3;
    } else if (ratedValue >= 3500 && ratedValue <= 4000) {
      ratingPoints = 3.5;
    } else if (ratedValue > 4000 && ratedValue <= 4499) {
      ratingPoints = 4;
    } else if (ratedValue >= 4500 && ratedValue < 5000) {
      ratingPoints = 4.5;
    } else if (ratedValue >= 5000) {
      ratingPoints = 5;
    }

    return ratingPoints;
  }
}
