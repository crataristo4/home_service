import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_service/models/artwork.dart';
import 'package:home_service/models/data.dart';
import 'package:home_service/provider/artwork_provider.dart';
import 'package:home_service/provider/history_provider.dart';
import 'package:home_service/service/admob_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/comments/comments_page.dart';
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
  List _likedUsers =
      []; //Issue with list is that it stores all the current artworks liked and puts value in another artwork like
  //for instance if u like 3 artworks and you like a 4th artwork it increases likes to 4 instead of one
  late List<ArtworkModel>? _artworkList; // data
  HistoryProvider _historyProvider = HistoryProvider();
  AdmobService _admobService = AdmobService();
  late final artworkProvider;
  int? commentCount;
  CollectionReference artworkRf =
      FirebaseFirestore.instance.collection('Artworks');

  @override
  void initState() {
    artworkProvider = Provider.of<ArtworkProvider>(context, listen: false);
    _admobService.createInterstitialAd();
    super.initState();
  }
/*
  Future<void> getCommentItemCount(String id) async {
    await artworkRf.doc(id).collection('Comments').get().then((value) {
      setState(() {
        commentCount = value.docs.length;
      });
    });
  }*/

  Widget _buildArtworksCard(List<ArtworkModel>? artworkList, int index) {
    _likedUsers = artworkList![index].likedUsers!;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  if (!artworkList[index]
                      .artisanId
                      .toString()
                      .contains(currentUserId!)) {
                    _historyProvider.updateProviderListener(
                        artworkList[index].artisanId,
                        userName,
                        imageUrl,
                        viewedYourProfile);
                    //create history
                    _historyProvider
                        .createHistory(artworkList[index].artisanId!);
                  }
                  await Navigator.of(context).pushNamed(
                    ArtisanProfile.routeName,
                    arguments: artworkList[index].artisanId,
                  );
                },
                child: Row(
                  children: [
                    //artisan image
                    CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                          artworkList[index].artisanPhotoUrl!),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //artisan name
                          artworkList[index].artisanName!,
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
              ),
              Row(
                children: [
                  //Text(commentCount == null ? '' : '$commentCount'),
                  IconButton(
                      onPressed: () {
                        pushToComment(
                            artworkList[index].artworkId,
                            artworkList[index].artisanName,
                            artworkList[index].artworkImageUrl);
                      },
                      icon: Icon(
                        Icons.comment,
                        color: Colors.indigoAccent,
                      )),
                  Text(artworkList[index].likedUsers!.length.toString()),
                  IconButton(
                      onPressed: () {
                        //checks if the current user is already part of the liked users
                        if (!artworkList[index].isFavorite!) {
                          artworkProvider.updateLikes(
                              artworkList[index].artworkId!, context);
                        } else if (artworkList[index].isFavorite!) {
                          artworkProvider.removeLikes(
                              artworkList[index].artworkId!, context);
                        }
                      },
                      icon: Icon(
                        artworkList[index].isFavorite!
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
            child: GestureDetector(
              onTap: () {
                pushToComment(
                    artworkList[index].artworkId,
                    artworkList[index].artisanName,
                    artworkList[index].artworkImageUrl);
              },
              child: CachedNetworkImage(
                //artwork image
                height: twoHundredDp,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                imageUrl: artworkList[index].artworkImageUrl!,

                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: tenDp),
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
    );
  }

  pushToComment(id, name, image) {
    Navigator.of(context).pushNamed(CommentsPage.routeName,
        arguments: Data(id: id, name: name, imageUrl: image));
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
                      child: ListView.builder(
                        addAutomaticKeepAlives: true,
                        itemCount: _artworkList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          // getCommentItemCount(_artworkList![index].artworkId!);
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
                        //todo -- to be added later
                        /*       separatorBuilder: (BuildContext context, int index) {
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
