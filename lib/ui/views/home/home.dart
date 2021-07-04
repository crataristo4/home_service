
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/options_page.dart';
import 'package:home_service/ui/views/home/artwork.dart';
import 'package:home_service/ui/views/home/bookings.dart';
import 'package:home_service/ui/views/home/bookings/user_booking_page/user_booking_page.dart';
import 'package:home_service/ui/views/home/category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

CollectionReference usersDbRef = FirebaseFirestore.instance.collection("Users");
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Users? users;
Artisans? artisans;

class Home extends StatefulWidget {
  static const routeName = '/homePage';
  final int? tabIndex;

  Home({Key? key, required this.tabIndex}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? message, nameFromPrefs, imageFromPrefs;

  @override
  void initState() {
    greetingMessage();
    getFromSharedPref();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.index = widget.tabIndex!;

    super.initState();
  }

  getFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameFromPrefs = prefs.getString('name');
    imageFromPrefs = prefs.getString('photoUrl');
  }

  //greeting message to user
  greetingMessage() {
    var timeNow = DateTime.now().hour;
    if (timeNow < 12) {
      setState(() {
        message = goodMorning;
      });
    } else if ((timeNow >= 12) && (timeNow <= 16)) {
      setState(() {
        message = goodAfternoon;
      });
    } else if ((timeNow > 16) && (timeNow <= 20)) {
      setState(() {
        message = goodEvening;
      });
    } else {
      setState(() {
        message = goodNight;
      });
    }
  }

  //get user current location

  @override
  void dispose() {
    super.dispose();

    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
            onWillPop: () async {
              if (_tabController!.index == 0 || _tabController!.index == 2) {
                _tabController!.index = 1;
                return false;
              } else {
                if (_tabController!.index == 1) return true;
                return true;
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: //user profile image
                imageUrl == null
                  ? GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => OptionsPage()),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(left: eightDp, top: tenDp),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.1,
                                color: Colors.grey.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(30)),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: imageFromPrefs!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => OptionsPage()),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(left: eightDp, top: tenDp),
                        decoration: BoxDecoration(
                            border: Border.all(
                                      width: 0.1,
                                      color: Colors.grey.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(30)),
                              child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(30),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
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
                        text: Artwork,
                      ),
                      Tab(
                        text: Artisanz,
                      ),
                      Tab(
                        text: Bookingz,
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //display greeting message to user
                  Container(
                    margin: EdgeInsets.only(top: eightDp),
                    child: userName == null
                  ? Padding(
                      padding: EdgeInsets.only(top: tenDp, left: sixteenDp),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.indigo,
                        child: Text(
                          "$message ${nameFromPrefs ?? ''}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: tenDp, left: sixteenDp),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.indigo,
                        child: Text(
                          "$message ${userName ?? ''}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                            ),
                          ),
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ArtworksPage(),
                        CategoryPage(),
                        getUserType == user ? UserBookingsPage() : BookingPage()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
