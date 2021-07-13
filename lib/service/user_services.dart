import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:home_service/ui/views/profile/complete_profile.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class UserService {
  final firestoreService = FirebaseFirestore.instance;
  final mediumRaking = 500;

  //create an artisan
  Future<void> createArtisan(Artisans artisans, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(artisans.id)
        .set(artisans.artisanToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //create a user
  Future<void> createUser(Users users, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(users.id)
        .set(users.userToMap())
        .whenComplete(() async {
      showSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update name
  Future<void> updateUserName(Users user, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .update(user.updateUserNameToMap())
        .catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update PHOTO
  Future<void> updatePhotoUrl(Users user, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .update(user.updateUserPhotoToMap())
        .whenComplete(() async {
      showUpdatingSuccess(context);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update artisan experience
  Future<void> updateArtisanExpLevel(Artisans artisan, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .update(artisan.updateExpLevelToMap())
        .catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update last seen
  Future<void> updateLastSeen(Artisans artisan, BuildContext context) {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .update(artisan.updateLastSeenToMap())
        .whenComplete(() {
          print('??????????????????last??? seen?????');
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //update location
  Future<void> updateLocation(BuildContext context, double lat, double lng) {
    return firestoreService
        .collection('Users')
        .doc(currentUserId)
        .update({'location': GeoPoint(lat, lng)}).whenComplete(() {
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

/*  Stream<DocumentSnapshot> getUserStream() async* {
    yield* firestoreService.doc("Users/$currentUserId").snapshots();
  }*/

  //get all artisans from db
  Stream<List<Artisans>> getAllArtisans() {
    return firestoreService
        .collection('Users')
        .where("type", isEqualTo: artisan)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Artisans.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }

  //get all users from db
  Stream<List<Users>> getAllUsers() {
    return firestoreService
        .collection('Users')
        .where("type", isEqualTo: user)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Users.fromDb(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }

  //get initial artisans list by category
  Stream<List<Artisans>> getInitialArtisanByCategory(String? category) {
    return firestoreService
        .collection('Users')
        .where("id", isNotEqualTo: currentUserId)
        .where("type", isEqualTo: artisan)
        .where("category", isEqualTo: category)
        .limit(20)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Artisans.fromFirestore(document.data()))
            .toList(growable: true))
        .handleError((error) {});
  }

  //fetch next list
  Stream<List<Artisans>> getNextList(
      List<DocumentSnapshot> documentList, String category) {
    return firestoreService
        .collection("Users")
        .where("id", isNotEqualTo: currentUserId)
        .where("type", isEqualTo: artisan)
        .where("category", isEqualTo: category)
        .limit(20)
        .startAfterDocument(documentList[documentList.length - 1])
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Artisans.fromDocument(document))
            .toList(growable: true));
  }

  //rate artisan
  Future<void> rateArtisan(
      String artisanId, double rating, BuildContext context) {
    return firestoreService.collection('Users').doc(artisanId).update({
      'ratedUsers': FieldValue.arrayUnion([currentUserId]),
      'rating': rating
    }).whenComplete(() {
      showUpdatingSuccess(context);
      Navigator.of(context)
          .pushReplacementNamed(ArtisanProfile.routeName, arguments: artisanId);
    }).catchError((onError) {
      showFailure(context, onError);
    });
  }

  //show top experts
  Stream<List<Artisans>> getTopUsersByRating() {
    return firestoreService
        .collection('Users')
        .orderBy("rating", descending: true)
        .where("type", isEqualTo: artisan)
        .where("rating", isGreaterThanOrEqualTo: mediumRaking)
        .snapshots()
        .map((snapshots) => snapshots.docs.map((document) {
              return Artisans.fromFirestore(document.data());
            }).toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }

  //check user details
  Future<void> getCurrentUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      getUserType = prefs.getString('userType');

      if (prefs.containsKey('name') & prefs.containsKey('photoUrl')) {
        userName = prefs.getString('name');
        imageUrl = prefs.getString('photoUrl');
      }

      if (prefs.containsKey('category') & prefs.containsKey('expLevel')) {
        category = prefs.getString('category');
        expLevel = prefs.getString('expLevel');
      }

      if (currentUserId != null) {
        //check the state of users / artisans if the user exists
        //check the database if user has details
        await usersDbRef
            .doc(currentUserId)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            //delete user details in-case user type changes and complete profile
            //this could happen if the user re-installs the app and selects a different account type which is different from value in the database
            type = documentSnapshot.get(FieldPath(['type']));

            if (getUserType == user && type == artisan ||
                getUserType == artisan && type == user) {
              //delete user record
              await usersDbRef.doc(currentUserId).delete().whenComplete(() {
                //delete image from storage
                firebase_storage.Reference deleteProfilePhoto = firebase_storage
                    .FirebaseStorage.instance
                    .refFromURL(imageUrl!);
                deleteProfilePhoto.delete();
                pushToCompleteProfile(context);
              });
            } else {
              //if true  ... shared pref keys for user name and photoUrl can be null so get data
              if (getUserType == artisan) {
                category = documentSnapshot.get(FieldPath(['category']));
                expLevel = documentSnapshot.get(FieldPath(['expLevel']));
              }

              userName = documentSnapshot.get(FieldPath(['name']));
              imageUrl = documentSnapshot.get(FieldPath(['photoUrl']));
              userLocation = documentSnapshot.get(FieldPath(['location']));

              //put values into shared pref to avoid null values
              prefs.setString("name", userName!);
              prefs.setString("photoUrl", imageUrl!);
              prefs.setString("category", category!);
              prefs.setString("expLevel", expLevel!);
            }
          } else {
            //if not then navigate to complete profile
            pushToCompleteProfile(context);
          }
        }).catchError((onError) {
          debugPrint("Error: $onError");
        });

//------------------------------------------------------------------------------------------------

      }
    } catch (error) {
      print("Error on HOme state : $error");
    }
  }

//----------------------------------------------------------------------------------------------------------------------
  showSuccess(context) async {
    await Future.delayed(Duration(seconds: 3));
    ShowAction().showToast(successful, Colors.black); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppState.routeName, (route) => false);
  }

  showUpdatingSuccess(context) async {
    ShowAction().showToast(successful, Colors.green); //show complete msg
    Navigator.of(context, rootNavigator: true).pop();
  }

  showNameUpdatingSuccess(context) async {
    ShowAction().showToast(userNameUpdated, Colors.black); //show complete msg
  }

  showFailure(context, error) {
    ShowAction().showToast(error, Colors.black);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialog
  }

  //push to complete profile when user has no record
  pushToCompleteProfile(BuildContext context) async {
    await new Future.delayed(Duration(seconds: 0));
    Navigator.of(context).pushReplacementNamed(CompleteProfile.routeName);
  }

//------------------------------------------------------------------------------------------------------------
}
