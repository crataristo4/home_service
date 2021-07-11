import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/provider/history_provider.dart';
import 'package:home_service/provider/user_provider.dart';
import 'package:home_service/service/admob_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/add_booking.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../../../constants.dart';

class ArtisanProfile extends StatefulWidget {
  final String? artisanId;

  const ArtisanProfile({Key? key, this.artisanId}) : super(key: key);
  static const routeName = '/artisanProfile';

  @override
  _ArtisanProfileState createState() => _ArtisanProfileState();
}

class _ArtisanProfileState extends State<ArtisanProfile> {
  Artisans? _selectedArtisan;
  List<ArtworkModel>? _artworkList;
  int _totalNumberOfLikes = 0;
  bool isRatingTapped = false; // checks if user has tapped rating
  double ratingNumber = 0.0; //initial rating is zero
  AdmobService _admobService = AdmobService(); // ADS
  double?
      artisanRating; // gets rating from artisan and adds up to what other users will rate
  double? totalRating; //total rating
  double? rating; // rating
  UserProvider rateUser = UserProvider();
  HistoryProvider _historyProvider = HistoryProvider();

  @override
  void initState() {
    final artisans = Provider.of<List<Artisans>>(context, listen: false);
    final artworkLists =
        Provider.of<List<ArtworkModel>>(context, listen: false);

    _selectedArtisan = artisans
        .firstWhere((Artisans artisan) => artisan.id == widget.artisanId);

    rating = _selectedArtisan!.rating!; // from db

    //rating logic
    artisanRating = Artisans.ratingApproach(rating);

    _artworkList = artworkLists
        .where((ArtworkModel artisanArtwork) =>
            widget.artisanId == artisanArtwork.artisanId)
        .toList();
    for (var i = 0; i < _artworkList!.length; i++) {
      _totalNumberOfLikes += _artworkList![i].likedUsers.length;
    }
    //create ad
    _admobService.createInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(minutes: 7), () {
      _admobService.showInterstitialAd();
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white12,
        iconTheme: IconThemeData(color: Colors.black),
        title: _selectedArtisan!.id!.contains(currentUserId!)
            ? Text(
                profile,
                style: TextStyle(
                  color: Colors.black54,
                ),
              )
            : Text(
                _selectedArtisan!.lastSeen! == null
                    ? profile
                    : 'Last seen \n${timeAgo.format(_selectedArtisan!.lastSeen.toDate())}',
                style: TextStyle(color: Colors.black54, fontSize: fourteenDp),
              ),
        actions: [
          currentUserId != _selectedArtisan!.id
              ? Container(
                  // margin: EdgeInsets.only(right: twentyFourDp),
                  child: FloatingActionButton(
                    tooltip: 'Call ${_selectedArtisan!.name!}',
                    splashColor: Colors.green,
                    elevation: 0,
                    mini: true,
                    backgroundColor: Colors.indigo,
                    onPressed: () => ShowAction.makePhoneCall(
                        "tel:${_selectedArtisan!.phoneNumber!}"),
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
          currentUserId != _selectedArtisan!.id
              ? GestureDetector(
                  onTap: () {
                    if (_selectedArtisan!.ratedUsers!.contains(currentUserId)) {
                      ShowAction().showToast("Already rated", Colors.red);
                    } else if (!_selectedArtisan!.ratedUsers!
                        .contains(currentUserId)) {
                      ShowAction.showDetails(
                          rate,
                          "You can only rate ${_selectedArtisan!.name} once",
                          context,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ratingNumber = 0;
                                  isRatingTapped = false;
                                },
                                child: Text(cancel),
                                style: ElevatedButton.styleFrom(
                                    elevation: 0, primary: Colors.red),
                              ),
                              Flexible(
                                child: RatingBar.builder(
                                  itemPadding: EdgeInsets.only(top: 2),
                                  itemSize: 25,
                                  initialRating: 0,
                                  minRating: 0.5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    isRatingTapped = true;
                                    ratingNumber = rating;
                                  },
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    totalRating = (rating! + ratingNumber);
                                    if (isRatingTapped) {
                                      Navigator.pop(context);
                                      Dialogs.showLoadingDialog(
                                          context,
                                          loadingKey,
                                          ratingUser,
                                          Colors.white70);
                                      rateUser.rateUser(_selectedArtisan!.id,
                                          totalRating, context);

                                      //create rating history
                                      _historyProvider.updateProviderListener(
                                          _selectedArtisan!.id,
                                          userName,
                                          imageUrl,
                                          'rated you $ratingNumber ⭐');
                                      //create history
                                      _historyProvider
                                          .createHistory(_selectedArtisan!.id!);
                                    } else {
                                      ShowAction().showToast(
                                          pleaseSelectAtLeastOneRating,
                                          Colors.red);
                                    }
                                  },
                                  child: Text(rateNow)),
                            ],
                          ));
                    }
                  },
                  child: Container(
                      height: fortyEightDp,
                      width: sixtyDp,
                      margin: EdgeInsets.only(
                          top: tenDp,
                          right: twentyDp,
                          left: tenDp,
                          bottom: tenDp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(eightDp),
                          border: Border.all(
                              width: 0.3, color: Colors.indigoAccent)),
                      child: Center(
                          child: !_selectedArtisan!.ratedUsers!
                                  .contains(currentUserId)
                              ? Text(
                                  rate,
                                  style: TextStyle(color: Colors.indigoAccent),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      rated,
                                      style:
                                          TextStyle(color: Colors.indigoAccent),
                                    ),
                                    Icon(
                                      Icons.check_circle,
                                      size: tenDp,
                                      color: Colors.green,
                                    )
                                  ],
                                ))),
                )
              : Container()
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: fourDp),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(width: 0.3, color: Colors.grey),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    //artisan image
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    imageUrl: _selectedArtisan!.photoUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Text(_selectedArtisan!.name!, style: TextStyle(fontSize: 20)),
                RatingBar.builder(
                  itemPadding: EdgeInsets.only(top: 2),
                  itemSize: 24,
                  ignoreGestures: true,
                  initialRating: artisanRating!,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),

            SizedBox(height: 15),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                Text("Joined on ",
                    style: TextStyle(fontSize: 12, color: Colors.black87)),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                  ),
                ),
                Text(" ${_selectedArtisan!.dateJoined!}",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                        fontStyle: FontStyle.italic)),
              ],
            ),
            SizedBox(height: 15),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                Text(_selectedArtisan!.category!, style: TextStyle()),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                  ),
                ),
                Text(_selectedArtisan!.expLevel!, style: TextStyle()),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                  ),
                ),
                SizedBox(width: 5),
                Text('Likes: $_totalNumberOfLikes',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
            SizedBox(height: 20),
            //Booking
            currentUserId != _selectedArtisan!.id
                ? SizedBox(
                    height: fortyEightDp,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        margin: EdgeInsets.only(
                            left: sixteenDp, right: sixteenDp, bottom: fourDp),
                        child: TextButton(
                            // button to open bottom sheet
                            style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(eightDp))),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (context) => AddBooking(
                                        //bottom sheet to send a short message
                                        receiverName: _selectedArtisan!.name,
                                        receiverPhoneNumber:
                                            _selectedArtisan!.phoneNumber,
                                        receiverPhotoUrl:
                                            _selectedArtisan!.photoUrl,
                                        receiverId: _selectedArtisan!.id,
                                      ));
                            },
                            child: Text(
                              book,
                              style: TextStyle(fontSize: fourteenDp),
                            ))),
                  )
                : Container(),
            //End of Booking
            SizedBox(height: 20),
            _artworkList!.length == 0
                ? Container()
                : Text('Artwork', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Expanded(
              child: _artworkList!.length == 0
                  ? Container(
                      child: Center(child: Text('No Artwork Yet')),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: _artworkList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              //artwork image

                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              imageUrl: _artworkList![index].artworkImageUrl,

                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
