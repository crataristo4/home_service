import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/models/users.dart';
import 'package:home_service/ui/views/bottomsheet/options_page.dart';
import 'package:home_service/ui/views/home/artwork.dart';
import 'package:home_service/ui/views/home/bookings.dart';
import 'package:home_service/ui/views/home/category.dart';
import 'package:home_service/ui/widgets/load_home.dart';

CollectionReference usersDbRef = FirebaseFirestore.instance.collection("Users");
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Users? users;
Artisans? artisans;
String? userName;
String? imageUrl;
String? getUserType;

class Home extends StatefulWidget {
  static const routeName = '/homePage';
  final name;
  final image;

  Home({Key? key, this.name, this.image}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;

  @override
  void initState() {
    showLoading();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 1;
    super.initState();
  }

  showLoading() {
    try {
      setState(() {
        isLoading = true;
      });

      Timer(Duration(seconds: 5), () {
        setState(() {
          isLoading = false;
        });
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadHome()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: //user profile image
                  imageUrl == null
                      ? Container()
                      : GestureDetector(
                          onTap: () => showModalBottomSheet(
                              isDismissible: false,
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
              children: [
                ArtworksPage(image: imageUrl, name: userName),
                CategoryPage(),
                BookingPage()
              ],
            ),
          )
        ],
      ),
    );
  }
}
