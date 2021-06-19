import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/ui/views/bottomsheet/options_page.dart';
import 'package:home_service/ui/views/home/artwork.dart';
import 'package:home_service/ui/views/home/bookings.dart';
import 'package:home_service/ui/views/home/category.dart';

class Home extends StatefulWidget {
  //final int initialIndex;

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
    super.initState();
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
            margin: EdgeInsets.only(top: sixDp, left: eightDp),
            width: sixtyDp,
            height: sixtyDp,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(sixteenDp),
                border: Border.all(width: 0.5, color: Colors.grey),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      "assets/images/a.png"), //todo -load image from network
                )),
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
