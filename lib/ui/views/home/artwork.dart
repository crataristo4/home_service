import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/artwork.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';


class ArtworksPage extends StatefulWidget {
  static const routeName = '/artworkPage';

  @override
  _ArtworksPageState createState() => _ArtworksPageState();
}

class _ArtworksPageState extends State<ArtworksPage> {
  Future<void>? _launched;

  bool _favorite = false;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildArtworksCard(List<ArtworkModel> artworkList, int index) {
    return Container(
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
                        artworkList[index].artworkImageUrl),
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
              IconButton(
                  onPressed: () {
                    setState(() {
                      _favorite = !_favorite;
                    });
                  },
                  icon: Icon(
                    _favorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ))
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
                  Text('Priced @: $kGhanaCedi${artworkList[index].artworkPrice}',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              ElevatedButton(
                  onPressed: () => setState(() {
                        _launched = _makePhoneCall(
                            'tel:${artworkList[index].artisanPhoneNumber}');
                      }),
                  child: Text('CALL'))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final artworkList = Provider.of<List<ArtworkModel>>(context);
    return Builder(
      builder: (BuildContext context) {
        return Container(
            margin: EdgeInsets.all(24),
            child: ListView.builder(
                itemCount: artworkList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      _buildArtworksCard(artworkList, index),
                      SizedBox(height: 24)
                    ],
                  );
                }));
      },
    );
  }
}
