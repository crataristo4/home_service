import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/provider/history_provider.dart';
import 'package:home_service/service/location_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class ViewAllArtisans extends StatefulWidget {
  const ViewAllArtisans({Key? key}) : super(key: key);
  static const routeName = "/viewAllArtisan";

  @override
  _ViewAllArtisansState createState() => _ViewAllArtisansState();
}

class _ViewAllArtisansState extends State<ViewAllArtisans> {
  bool isLoading = false;
  List<Artisans>? _artisanListProvider;
  double? rating;
  HistoryProvider _historyProvider = HistoryProvider();
  GetLocationService _getLocationService = GetLocationService();
  double? distanceBetween, artisanLat, artisanLng, userLat, userLng;

  @override
  void initState() {
    if (userLocation != null) {
      setState(() {
        userLat = userLocation!.latitude;
        userLng = userLocation!.longitude;
      });
    } else {
      setState(() {
        userLat = GetLocationService.lat;
        userLng = GetLocationService.lng;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _artisanListProvider = Provider.of<List<Artisans>>(context);
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
            _artisanListProvider!.length == 0
                ? noArtisansAvailable
                : "${_artisanListProvider!.length} $availableArtisans",
            style: TextStyle(
                color: Colors.black,
                fontSize: sixteenDp,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return _artisanListProvider!.length == 0
              ? Column(
                  children: [
                    SizedBox(
                      height: thirtyDp,
                    ),
                    Center(
                        child: Image.asset(
                      "assets/images/noartisan.jpg",
                      fit: BoxFit.cover,
                    )),
                  ],
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    //artisans locations
                    artisanLat =
                        _artisanListProvider![index].location!.latitude;
                    artisanLng =
                        _artisanListProvider![index].location!.longitude;

                    distanceBetween =
                        _getLocationService.getDistanceInKilometers(
                            userLocation!.latitude,
                            userLocation!.longitude,
                            artisanLat!,
                            artisanLng!);


                    //get rating and display
                    rating = Artisans.ratingApproach(
                        _artisanListProvider![index].rating!);

                    return Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            onTap: () async {
                              if (!_artisanListProvider![index]
                                  .id!
                                  .contains(currentUserId!)) {
                                _historyProvider.updateProviderListener(
                                    _artisanListProvider![index].id!,
                                    userName,
                                    imageUrl,
                                    viewedYourProfile);
                                //create history record
                                _historyProvider.createHistory(
                                    _artisanListProvider![index].id!);
                              }

                              //2.navigate to artisan's profile
                              await Navigator.of(context).pushNamed(
                                  ArtisanProfile.routeName,
                                  arguments: _artisanListProvider![index].id);
                            },
                            minVerticalPadding: 25,
                            horizontalTitleGap: 4,
                            tileColor: Colors.grey[100],
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //artisans name
                                Text(
                                  _artisanListProvider![index].name!,
                                  style: TextStyle(color: Colors.black),
                                ),
                                //todo implement location
                                Text(
                                  _artisanListProvider![index]
                                              .id!
                                              .contains(currentUserId!) ||
                                          distanceBetween == 0.0
                                      ? ""
                                      : "${distanceBetween!.roundToDouble()} km",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: sixDp, bottom: sixDp),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        //artisan's category
                                        flex: 1,
                                        child: Text(
                                            _artisanListProvider![index]
                                                .category!,
                                            style:
                                            TextStyle(color: Colors.black)),
                                      ),
                                      Flexible(
                                        child: RatingBar.builder(
                                          itemPadding: EdgeInsets.only(top: 2),
                                          itemSize: 14,
                                          ignoreGestures: true,
                                          initialRating: rating!,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  // artisan's experience
                                  _artisanListProvider![index].expLevel!,
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                            leading: Padding(
                              padding: EdgeInsets.only(top: eightDp),
                              child: CircleAvatar(
                                radius: 40,
                                foregroundImage: CachedNetworkImageProvider(
                                    _artisanListProvider![index].photoUrl!),
                                backgroundColor: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                  itemCount: _artisanListProvider!.length,
                  shrinkWrap: true,
                  //todo add later
                  /*          separatorBuilder: (BuildContext context, int index) {
                    return index % 3 == 0
                        ? Container(
                            margin: EdgeInsets.only(bottom: sixDp),
                            height: twoFiftyDp,
                            child: AdWidget(
                              ad: AdmobService.createBanner()..load(),
                              key: UniqueKey(),
                            ),
                          )
                        : Container();
                  },*/
                  addAutomaticKeepAlives: true,
                );
        }));
  }
}
