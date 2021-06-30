import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/add_booking.dart';
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
  List<ArtworkModel>? artworkList;

  @override
  void initState() {
    final artisans = Provider.of<List<Artisans>>(context, listen: false);
    final artworkLists =
        Provider.of<List<ArtworkModel>>(context, listen: false);

    _selectedArtisan = artisans
        .firstWhere((Artisans artisan) => artisan.id == widget.artisanId);
    artworkList = artworkLists
        .where((ArtworkModel artisanArtwork) =>
            widget.artisanId == artisanArtwork.artisanId)
        .toList();
    super.initState();
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
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  //artisan image
                  height: 200,
                  width: 150,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  imageUrl: _selectedArtisan!.photoUrl!,

                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(_selectedArtisan!.name!, style: TextStyle(fontSize: 20)),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_selectedArtisan!.category!,
                    style: TextStyle(fontSize: 12)),
                SizedBox(width: 5),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                ),
                SizedBox(width: 5),
                Text(_selectedArtisan!.expLevel!,
                    style: TextStyle(fontSize: 12)),
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
              child: artworkList!.length == 0
                  ? Container(
                      child: Center(child: Text('No Artwork Yet')),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: artworkList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              //artwork image

                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              imageUrl: artworkList![index].artworkImageUrl,

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
