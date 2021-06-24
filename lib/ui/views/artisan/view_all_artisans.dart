import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_service/ui/models/users.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class ViewAllArtisans extends StatefulWidget {
  const ViewAllArtisans({Key? key}) : super(key: key);
  static const routeName = "/viewAllArtisan";

  @override
  _ViewAllArtisansState createState() => _ViewAllArtisansState();
}

class _ViewAllArtisansState extends State<ViewAllArtisans> {
  @override
  Widget build(BuildContext context) {
    final artisanListProvider = Provider.of<List<Artisans>>(context);

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
            allAvailableArtisans,
            style: TextStyle(
                color: Colors.black,
                fontSize: sixteenDp,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: eightDp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(width: 20, color: Colors.indigoAccent)),
                    child: ListTile(
                      onTap: () {
                        //1.pass artisans details
                        //todo
                        //2.navigate to artisan's profile
                      },
                      minVerticalPadding: 25,
                      horizontalTitleGap: 4,
                      tileColor: Colors.indigoAccent,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //artisans name
                          Text(
                            artisanListProvider[index].artisanName,
                            style: TextStyle(color: Colors.white),
                          ),
                          //todo implement location
                          Text(
                            "3 km",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: sixDp, bottom: sixDp),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  //artisan's category
                                  flex: 1,
                                  child: Text(
                                      artisanListProvider[index].category,
                                      style: TextStyle(color: Colors.white)),
                                ),
                                Flexible(
                                  //todo implement rating logic
                                  child: RatingBar.builder(
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
                                ),
                              ],
                            ),
                          ),
                          Text(
                            // artisan's experience
                            artisanListProvider[index].expLevel,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(top: eightDp),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: CachedNetworkImageProvider(
                              artisanListProvider[index].photoUrl),
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
            itemCount: artisanListProvider.length,
            shrinkWrap: true,
          );
        }));
  }
}
