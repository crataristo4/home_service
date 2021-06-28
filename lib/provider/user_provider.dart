import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/service/firestore_services.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
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

  get photoUrl => _photoUrl;

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

  createUser(BuildContext context) async {
    _id = FirebaseAuth.instance.currentUser!.uid;
    _dateJoined = dateFormat.format(DateTime.now());
    _type = getUserType; //from shared pref
    _phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

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

      await userData.setString("category", category);
      await userData.setString("name", name);
      await userData.setString("photoUrl", photoUrl);
      await userData.setString("expLevel", expLevel);

      //push to db
      userService.createArtisan(newArtisan, context);
    } else if (getUserType == user) {
      // create new  user object
      Users newUser = Users(
          userName: name,
          photoUrl: photoUrl,
          phoneNumber: _phoneNumber!,
          id: _id!,
          type: _type!,
          dateJoined: _dateJoined!,
          location: new GeoPoint(0, 0));

      //put values into shared prefs
      await userData.setString("name", name);
      await userData.setString("photoUrl", photoUrl);

      //create record in db
      userService.createUser(newUser, context);
    }
  }

  updateUser(BuildContext context) async {
    //store values
    SharedPreferences updateUserData = await SharedPreferences.getInstance();
    print('Name from input on update $name');

    if (getUserType == artisan) {
      //creates a new artisan object
      await updateUserData.setString("name", name);

      //push to db
    }
    if (getUserType == user) {
      //remove shared prefs value
      if (updateUserData.containsKey('name')) updateUserData.remove('name');

//update values into shared prefs
      await updateUserData.setString("name", name);

      // update  user object
      Users updateUser = Users.userName(userName: name);
      //create record in db
      userService.updateUserName(updateUser, context);
    }
  }
}
