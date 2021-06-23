import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_service/ui/views/bloc/artisan_category_list_bloc.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/loadingShimmer.dart';

import '../../../constants.dart';

class ViewArtisanByCategoryPage extends StatefulWidget {
  static const routeName = '/viewArtisanByCategory';
  final String? categoryName;

  const ViewArtisanByCategoryPage({Key? key, this.categoryName})
      : super(key: key);

  @override
  _ViewArtisanByCategoryPageState createState() =>
      _ViewArtisanByCategoryPageState();
}

class _ViewArtisanByCategoryPageState extends State<ViewArtisanByCategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? itemCount;

  ArtisanCategoryListBloc? _artisanCategoryListBloc;

  @override
  void initState() {
    getCategoryCount();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 2;
    _artisanCategoryListBloc = ArtisanCategoryListBloc();
    _artisanCategoryListBloc!.fetchFirstList(usersDbRef, widget.categoryName);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> getCategoryCount() async {
    QuerySnapshot _myDoc = await usersDbRef
        .orderBy("artisanName")
        .where("category", isEqualTo: widget.categoryName)
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    setState(() {
      itemCount = _myDocCount.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(tenDp),
            decoration: BoxDecoration(
                border: Border.all(width: 0.3, color: Colors.grey),
                color: Colors.white,
                borderRadius: BorderRadius.circular(thirtyDp)),
            child: Padding(
              padding: EdgeInsets.all(eightDp),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
                size: sixteenDp,
              ),
            ),
          ),
        ),
        title: Text(
          "${widget.categoryName}s near you",
          style: TextStyle(
              color: Colors.black,
              fontSize: sixteenDp,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          //user profile image
          Container(
            width: 40,
            height: 40,
            margin:
                EdgeInsets.only(right: tenDp, top: twelveDp, bottom: fourDp),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
            decoration: BoxDecoration(
              border:
                  Border.all(width: 0.1, color: Colors.grey.withOpacity(0.9)),
              borderRadius: BorderRadius.circular(30),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: twelveDp),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(thirtySixDp),
                topRight: Radius.circular(thirtySixDp)),
            border:
                Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: sixteenDp, top: twentyDp),
                  child: Text(
                    itemCount == null || itemCount == 0
                        ? "No ${widget.categoryName}\'s near you"
                        : "$itemCount ${widget.categoryName} near you ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: fourteenDp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                      width: 200,
                      height: 36,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(eightDp)),
                      margin: EdgeInsets.symmetric(
                          horizontal: sixteenDp, vertical: sixteenDp),
                      /* child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: fourDp),
                          child: Icon(
                            Icons.map,
                            size: thirtyDp,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(fourDp),
                          child: Icon(
                            Icons.widgets,
                            size: twentyFourDp,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: fourDp, top: fourDp),
                          child: Icon(
                            Icons.view_stream,
                            size: thirtyDp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),*/
                      child: TabBar(
                        controller: _tabController,
                        // give the indicator a decoration (color and border radius)
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(eightDp),
                          color: Colors.green,
                        ),
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.widgets,
                              color: Colors.white,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.view_stream,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
            SizedBox(
              height: sixteenDp,
            ),
            /*Expanded(
              flex: 1,
              child: ListView(
                shrinkWrap: true,
                children: [
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),

                  buildListCategory()
                ],
              ),
            ),*/
            Expanded(
              flex: 1,
              // fit: FlexFit.loose,
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildMapItem(),
                  buildGridCategory(),
                  buildListCategory(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildListCategory() {
    return StreamBuilder<List<DocumentSnapshot>>(
        stream: _artisanCategoryListBloc!.itemListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingShimmer(
              category: widget.categoryName,
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    margin: EdgeInsets.symmetric(
                        horizontal: tenDp, vertical: tenDp),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(tenDp)),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //artisans profile image
                            Container(
                              margin: EdgeInsets.all(tenDp),
                              width: eightyDp,
                              height: eightyDp,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.3,
                                      color: Colors.grey.withOpacity(0.2)),
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(eightDp),
                                  // border: Border.all(width: 2,color: Colors.white54),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        snapshot.data![index]['photoUrl']),
                                  )),
                            ),

                            Container(
                              margin: EdgeInsets.symmetric(vertical: tenDp),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //artisan name
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            snapshot.data![index]
                                                ['artisanName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: sixteenDp),
                                          ),
                                          SizedBox(
                                            width: 100,
                                          ),
                                          Text(
                                            "3 km",
                                            //todo add artisan location and convert into distance
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: sixteenDp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      RatingBar.builder(
                                        //todo add rating to artisan
                                        itemSize: 20,
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      SizedBox(
                                        height: sixteenDp,
                                      ),
                                      Text(
                                        snapshot.data![index]['expLevel'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: sixteenDp,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: fortyEightDp,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: sixteenDp,
                                right: sixteenDp,
                                bottom: fourDp),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(eightDp))),
                                onPressed: () {},
                                child: Text(
                                  book,
                                  style: TextStyle(fontSize: fourteenDp),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        });
  }

  Widget buildGridCategory() {
    return StreamBuilder<List<DocumentSnapshot>>(
        stream: _artisanCategoryListBloc!.itemListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingShimmer(
              category: widget.categoryName,
            );
          }
          return Container(
              width: 300,
              margin: EdgeInsets.only(right: fourDp, bottom: twelveDp),
              // height: 500,
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: twelveDp,
                    mainAxisSpacing: twelveDp,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: eightDp),
                            width: twoHundredDp,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(sixteenDp),
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                    style: BorderStyle.solid)),
                          ),
                          //artisan details
                          Positioned(
                            top: 67,
                            child: Container(
                              margin: EdgeInsets.only(left: eightDp),
                              width: 180,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(sixteenDp),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: sixteenDp,
                                    left: eightDp,
                                    right: eightDp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //artisan name
                                    Text(
                                      snapshot.data![index]['artisanName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: sixteenDp),
                                    ),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Text(
                                              "30000 km",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: sixteenDp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          itemPadding: EdgeInsets.only(top: 2),
                                          itemSize: 14,
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      snapshot.data![index]['expLevel'],
                                      style: TextStyle(
                                          fontSize: sixteenDp,
                                          color: Colors.grey),
                                    ),

                                    SizedBox(
                                      height: 38,
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: eightDp,
                                            right: eightDp,
                                            bottom: fourDp,
                                            top: fourDp),
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                primary: Colors.indigo,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            eightDp))),
                                            onPressed: () {},
                                            child: Text(
                                              book,
                                              style: TextStyle(
                                                  fontSize: fourteenDp),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //artisan profile image
                          Positioned(
                            top: 10,
                            left: 50,
                            right: 50,
                            child: ClipOval(
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                // margin: EdgeInsets.only(right: tenDp, top: tenDp),
                                width: sixtyDp,
                                height: seventyDp,
                                decoration: BoxDecoration(
                                    // border: Border.all(width: 2,color: Colors.white54),
                                    image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      snapshot.data![index]['photoUrl']),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }));
        });
  }

  Widget buildMapItem() {
    return Container();
  }
}
