import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/provider/artwork_provider.dart';
import 'package:home_service/service/admob_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/load_home.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../../../constants.dart';
import '../profile/artisan_profile.dart';

class ArtworksPage extends StatefulWidget {
  static const routeName = '/artworkPage';

  @override
  _ArtworksPageState createState() => _ArtworksPageState();
}

class _ArtworksPageState extends State<ArtworksPage> {
  Future<void>? _launched;
  List _likedUsers = [];
  late List<ArtworkModel>? _artworkList; // data

  AdmobService _admobService = AdmobService();

  @override
  void initState() {
    super.initState();
    _admobService.createInterstitialAd();
  }

  Widget _buildArtworksCard(List<ArtworkModel>? artworkList, int index) {
    final artworkProvider = Provider.of<ArtworkProvider>(context);
    _likedUsers = artworkList![index].likedUsers;
    //Check if the current user is part of the liked users
    // if (_likedUsers.contains(currentUserId)) {
    //   artworkList[index].isFavorite = true;
    // }
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).pushNamed(
          ArtisanProfile.routeName,
          arguments: artworkList[index].artisanId,
        );
      },
      onLongPress: () {
        print(artworkList[index].likedUsers);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    //artisan image
                    CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                          artworkList[index].artisanPhotoUrl),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //artisan name
                          artworkList[index].artisanName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          //TIME POSTED
                          timeAgo.format(artworkList[index].timeStamp.toDate()),
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(artworkList[index].likedUsers.length.toString()),
                    IconButton(
                        onPressed: () {
                          //ckecks if the current user is already part of the liked users

                          if (!_likedUsers.contains(currentUserId)) {
                            _likedUsers.add(currentUserId);
                            print('1 ');
                            print(_likedUsers);
                          } else {
                            _likedUsers.remove(currentUserId);
                            print('0');
                            print(_likedUsers);
                          }

                          artworkProvider
                              .updateLikedUsers(artworkList[index].artworkId,
                                  _likedUsers, context)
                              .then((value) => setState(() {
                                    artworkList[index].isFavorite =
                                        !artworkList[index].isFavorite;
                                  }));
                        },
                        icon: Icon(
                          artworkList[index].isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        )),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                //artwork image
                height: 200,

                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                imageUrl: artworkList[index].artworkImageUrl,

                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${artworkList[index].artisanCategory}',
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    Text(
                        'Priced @: $kGhanaCedi${artworkList[index].artworkPrice}',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton(
                    onPressed: () => setState(() {
                          _launched = ShowAction.makePhoneCall(
                              'tel:${artworkList[index].artisanPhoneNumber}');
                        }),
                    child: Text('CALL'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _artworkList = Provider.of<List<ArtworkModel>>(context);

    Timer(Duration(seconds: 60), () {
      _admobService.showInterstitialAd();
    });

    return _artworkList == null
        ? LoadHome()
        : Builder(
            builder: (BuildContext context) {
              return _artworkList!.length != 0
                  ? Container(
                      margin: EdgeInsets.all(twentyFourDp),
                      child: ListView.separated(
                        addAutomaticKeepAlives: true,
                        itemCount: _artworkList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (_artworkList![index] is ArtworkModel) {
                            return Column(
                              children: [
                                _buildArtworksCard(_artworkList, index),
                                SizedBox(height: twentyFourDp)
                              ],
                            );
                          } else {
                            final Container adContainer = Container(
                              height: 50,
                              child: AdWidget(
                                ad: _artworkList![index] as BannerAd,
                                key: UniqueKey(),
                              ),
                            );

                            return adContainer;
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) {
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
                        },
                      ))
                  : Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: thirtyDp,
                          ),
                          Text(
                            noArtworksAvailable,
                            style: TextStyle(fontSize: twentyDp),
                          ),
                          Center(
                              child: Image.asset(
                            "assets/images/noartwork.jpg",
                            fit: BoxFit.cover,
                          )),
                        ],
                      ),
                    );
            },
          );
  }
}
