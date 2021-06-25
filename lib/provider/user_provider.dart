import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/service/firestore_services.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _id,
      _name,
      _category,
      _expLevel,
      _photoUrl,
      _dateJoined,
      _type,
      _phoneNumber;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");

  get name => _name;

  get category => _category;

  get expLevel => _expLevel;

  UserService userService = UserService();

  changeName(value) {
    _name = value;
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

  createUser(String photoUrl, BuildContext context) async {
    _id = FirebaseAuth.instance.currentUser!.uid;
    _dateJoined = dateFormat.format(DateTime.now());
    _type = getUserType;
    _phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    photoUrl = _photoUrl!;

    //store values
    SharedPreferences userData = await SharedPreferences.getInstance();

    if (getUserType == artisan) {
      //creates a new artisan object
      Artisans newArtisan = Artisans(
          artisanName: name,
          photoUrl: photoUrl,
          phoneNumber: _phoneNumber!,
          id: _id!,
          dateJoined: _dateJoined!,
          category: category,
          type: _type!,
          expLevel: expLevel,
          artworkUrl: [],
          location: new GeoPoint(0, 0));

      //push to db
      userService.createArtisan(newArtisan, context);
    } else if (getUserType == user) {
      // create new  user
      Users newUser = Users(
          userName: name,
          photoUrl: photoUrl,
          phoneNumber: _phoneNumber!,
          id: _id!,
          type: _type!,
          dateJoined: _dateJoined!,
          location: new GeoPoint(0, 0));

      userService.createUser(newUser, context);
    }

    await userData.setString("name", name);
    await userData.setString("photoUrl", photoUrl);
  }
}
