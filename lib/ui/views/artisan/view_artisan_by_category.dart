import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bloc/artisan_category_list_bloc.dart';
import 'package:home_service/ui/views/bottomsheet/add_booking.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
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
  late TabController _tabController; // tabs
  int? itemCount; // shows number of artisans in a category
  ArtisanCategoryListBloc? _artisanCategoryListBloc; // fetches artisan category
  //form key to validate input
  final _formKey = GlobalKey<FormState>();

  //message editing controller
  TextEditingController _controller = TextEditingController();

  //object for booking provider
  final bookingProvider = BookingsProvider();

  //for getting and passing receiver details to provider
  String? receiverName, receiverPhoneNumber, receiverPhotoUrl, receiverId;

  @override
  void initState() {
    //initialise state
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 1;
    _artisanCategoryListBloc = ArtisanCategoryListBloc();
    _artisanCategoryListBloc!.fetchFirstList(usersDbRef, widget.categoryName);
    getCategoryCount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _controller.dispose();
  }

  //method to get number of artisans in a category
  Future<void> getCategoryCount() async {
    QuerySnapshot querySnapshot = await usersDbRef
        .where("id", isNotEqualTo: currentUserId)
        .where("category", isEqualTo: widget.categoryName)
        .get();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;

    setState(() {
      itemCount = documentSnapshot.length;
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
                        ? ""
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
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildMapItem(),
                  buildListCategory(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildListCategory(context) {
    // list of all artisans by category
    return StreamBuilder<List<DocumentSnapshot>>(
        stream: _artisanCategoryListBloc!.itemListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //load if empty
            return LoadingShimmer(
              category: widget.categoryName,
            );
          } else {
            //retrieve data into a list
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                //get the details from the receiver
                receiverName = snapshot.data![index]['name'];
                receiverId = snapshot.data![index]['id'];
                receiverPhoneNumber = snapshot.data![index]['phoneNumber'];
                receiverPhotoUrl = snapshot.data![index]['photoUrl'];

                //todo get location

                //update provider ,set data
                bookingProvider.setReceiverName(receiverName);
                bookingProvider.setReceiverId(receiverId);
                bookingProvider.setReceiverPhone(receiverPhoneNumber);
                bookingProvider.setReceiverPhotoUrl(receiverPhotoUrl);

                return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      ArtisanProfile.routeName,
                      arguments: snapshot.data![index]['id']),
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
                                            snapshot.data![index]['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: sixteenDp),
                                          ),
                                          SizedBox(
                                            width: 100,
                                          ),
                                          Text(
                                            //shows artisans distance
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
                                        //shows artisans experience level
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
                        currentUserId != snapshot.data![index]['id']
                            ? SizedBox(
                                height: fortyEightDp,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: sixteenDp,
                                        right: sixteenDp,
                                        bottom: fourDp),
                                    child: TextButton(
                                        // button to open bottom sheet
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        eightDp))),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              useRootNavigator: true,
                                              builder: (context) => AddBooking(
                                                    //bottom sheet to send a short message
                                                    receiverName: receiverName,
                                                    receiverPhoneNumber:
                                                        receiverPhoneNumber,
                                                    receiverPhotoUrl:
                                                        receiverPhotoUrl,
                                                    receiverId: receiverId,
                                                  ));
                                        },
                                        child: Text(
                                          book,
                                          style:
                                              TextStyle(fontSize: fourteenDp),
                                        ))),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        });
  }

/*  Widget buildMsgBox(context) {
    return Container(
      color: Color(0xFF757575),
      margin: EdgeInsets.symmetric(horizontal: sixteenDp),
      child: Container(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: fiftyDp,
                      ),
                      Form(
                          key: _formKey,
                          child: TextFormField(
                              maxLines: 7,
                              maxLength: 500,
                              controller: _controller,
                              onChanged: (value) {
                                value = _controller.text;
                                //_controller.text = value;
                                bookingProvider.setMessage(value);
                              },
                              validator: (value) {
                                return value!.length > 20
                                    ? null
                                    : 'Please clearly state your intention';
                              },
                              keyboardType: TextInputType.multiline,
                              autofocus: true,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: sixteenDp),
                                  suffix: Container(
                                    child: Icon(
                                      Icons.message,
                                      color: Colors.white,
                                    ),
                                    width: thirtySixDp,
                                    height: thirtySixDp,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius:
                                          BorderRadius.circular(eightDp),
                                      border: Border.all(
                                          width: 0.5, color: Colors.white54),
                                    ),
                                  ),
                                  hintText: enterMsg,
                                  helperText: msgDes,
                                  helperMaxLines: 2,
                                  fillColor: Colors.white70,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: tenDp, horizontal: tenDp),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFF5F5F5)),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFF5F5F5)))))),
                      SizedBox(
                        height: fiftyDp,
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: twentyDp),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(eightDp))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //create new booking
                            bookingProvider.createNewBookings(
                                context,
                                receiverName,
                                receiverId,
                                receiverPhoneNumber,
                                receiverPhotoUrl,
                                _controller.text);
                            //clear controller
                            _controller.clear();
                          }
                        },
                        child: Text(
                          submitNow,
                          style: TextStyle(fontSize: fourteenDp),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }*/

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
