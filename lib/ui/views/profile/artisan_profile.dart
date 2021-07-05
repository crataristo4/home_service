import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/add_booking.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:provider/provider.dart';

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
  bool isRatingTapped = false;
  double ratingNumber = 0;

  @override
  void initState() {
    final artisans = Provider.of<List<Artisans>>(context, listen: false);
    final artworkLists =
        Provider.of<List<ArtworkModel>>(context, listen: false);

    _selectedArtisan = artisans
        .firstWhere((Artisans artisan) => artisan.id == widget.artisanId);
    _artworkList = artworkLists
        .where((ArtworkModel artisanArtwork) =>
            widget.artisanId == artisanArtwork.artisanId)
        .toList();
    for (var i = 0; i < _artworkList!.length; i++) {
      _totalNumberOfLikes += _artworkList![i].likedUsers.length;
    }
    super.initState();
  }

  @override
  void dispose() {
    isRatingTapped = false;
    ratingNumber = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white12,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
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
                              //todo implement rating logic
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
                                  print(rating);
                                  isRatingTapped = true;
                                  ratingNumber = rating;
                                },
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (isRatingTapped) {
                                    print("Rated $ratingNumber");
                                  } else {
                                    print("rate user now");
                                    ShowAction().showToast(
                                        "Please select at least one rating",
                                        Colors.red);
                                  }
                                },
                                child: Text(rateNow)),
                          ],
                        ));
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
                        border:
                            Border.all(width: 0.3, color: Colors.indigoAccent)),
                    child: Center(
                        child: Text(
                      rate,
                      style: TextStyle(color: Colors.indigoAccent),
                    )),
                  ),
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
            Text(_selectedArtisan!.name!, style: TextStyle(fontSize: 20)),

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
            Text('Artwork', style: TextStyle(fontSize: 16)),
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
