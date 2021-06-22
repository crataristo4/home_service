import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/models/users.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/options_page.dart';
import 'package:home_service/ui/views/home/artwork.dart';
import 'package:home_service/ui/views/home/bookings.dart';
import 'package:home_service/ui/views/home/category.dart';
import 'package:home_service/ui/views/profile/complete_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

CollectionReference usersDbRef = FirebaseFirestore.instance.collection("Users");
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Users? users;
Artisans? artisans;
String? userName;
String? imageUrl;
String? getUserType;

class Home extends StatefulWidget {
  static const routeName = '/homePage';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 1;
    checkIfUserProfileExists();
    super.initState();
  }

  //method to check the state of users / artisans
  checkIfUserProfileExists() async {
    await new Future.delayed(Duration(seconds: 10));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getUserType = prefs.getString("userType");

    await usersDbRef
        .doc(currentUserId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        imageUrl = documentSnapshot.get(FieldPath(["photoUrl"]));

        if (getUserType == user) {
          // check userType and display name
          userName = documentSnapshot.get(FieldPath(["userName"]));
        } else {
          userName = documentSnapshot.get(FieldPath(["artisanName"]));
        }
      } else {
        print('Document does not exist on the database');
        Navigator.of(context).restorablePushNamed(CompleteProfile.routeName);
      }
    }).catchError((onError) {
      debugPrint("Error: $onError");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: //user profile image
        GestureDetector(
          onTap: () => showModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: (context) => OptionsPage()),
          child: Container(
            margin: EdgeInsets.only(left: eightDp, top: eightDp),
            decoration: BoxDecoration(
                border:
                    Border.all(width: 0.1, color: Colors.grey.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(60)),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: tenDp),
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            border: Border.all(width: 1, color: Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(eightDp),
          ),
          child: TabBar(
            controller: _tabController,
            // give the indicator a decoration (color and border radius)
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(eightDp),
              color: Colors.indigo,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFF757575),
            tabs: [
              Tab(
                text: 'Artworks',
              ),
              Tab(
                text: 'Artisans',
              ),
              Tab(
                text: 'Bookings',
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [ArtworksPage(), CategoryPage(), BookingPage()],
            ),
          )
        ],
      ),
    );
  }
}
