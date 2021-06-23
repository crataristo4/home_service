import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';

class ArtworksPage extends StatefulWidget {
  static const routeName = '/artworkPage';

  //to be corrected later with the appropriate variables
  final image;
  final name;

  const ArtworksPage({Key? key, this.image, this.name}) : super(key: key);

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

  Widget _buildArtworksCard() {
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
                  CircleAvatar(
                    foregroundImage: NetworkImage(widget.image),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              height: 200,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              imageUrl:
                  'https://lh3.googleusercontent.com/proxy/7vucF8d5EU3szbWBNMa9ulwtXan5HwwLy_vL4bGTMrRs2fmLbbyEl-fE8sBOrPKZiePL9uQAXj9LR-bCVQqBpw-Ow8oj5VsfqCLwZj_ud1Ynq2ESbDyP82GM58jQsWTR_3NJxPzfJS8',
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
                  Text('Category: Plumber',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                  Text('Priced @: GH200', style: TextStyle(color: Colors.grey)),
                ],
              ),
              ElevatedButton(
                  onPressed: () => setState(() {
                        _launched = _makePhoneCall(
                            'tel:${firebaseAuth.currentUser?.phoneNumber}');
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
    return Container(
        margin: EdgeInsets.all(24),
        child: ListView.builder(
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [_buildArtworksCard(), SizedBox(height: 24)],
              );
            }));
  }
}
