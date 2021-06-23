import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/service/firestore_services.dart';
import 'package:home_service/ui/models/users.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:intl/intl.dart';

class UserProvider with ChangeNotifier {
  String? _id,
      _artisanName,
      _category,
      _expLevel,
      _photoUrl,
      _dateJoined,
      _type,
      _phoneNumber;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");

  // String dateJoined = dateFormat.format(DateTime.now());

  get artisanName => _artisanName;

  get category => _category;

  get expLevel => _expLevel;

  UserService userService = UserService();

  changeName(value) {
    _artisanName = value;
    notifyListeners();
  }

  changeArtisanCategory(value) {
    _category = value;
    notifyListeners();
  }

  changeArtisanExperience(value) {
    _expLevel = value;
    notifyListeners();
  }

  changeArtisanPhotoUrl(value) {
    _photoUrl = value;
    notifyListeners();
  }

  createUser(String photoUrl, BuildContext context) {
    _id = FirebaseAuth.instance.currentUser!.uid;
    _dateJoined = dateFormat.format(DateTime.now());
    _type = getUserType;
    _phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    photoUrl = _photoUrl!;

    //creates a new artisan object
    Artisans newArtisan = Artisans(
        artisanName: artisanName,
        photoUrl: photoUrl,
        phoneNumber: _phoneNumber!,
        id: _id!,
        dateJoined: _dateJoined!,
        category: category,
        type: _type!,
        expLevel: expLevel,
        artworkUrl: []);

    //push to db
    userService.createArtisan(newArtisan, context);
  }
}
