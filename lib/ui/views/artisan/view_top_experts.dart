import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/provider/history_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class ViewAllTopExperts extends StatefulWidget {
  static const routeName = '/viewAllTopExpects';

  const ViewAllTopExperts({Key? key}) : super(key: key);

  @override
  _ViewAllTopExpertsState createState() => _ViewAllTopExpertsState();
}

class _ViewAllTopExpertsState extends State<ViewAllTopExperts> {
  late List<Artisans> topArtisanList;
  double? rating;

  HistoryProvider _historyProvider = HistoryProvider();

  @override
  Widget build(BuildContext context) {
    topArtisanList = Provider.of<List<Artisans>>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
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
          topExperts,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: buildAllTopExperts(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAllTopExperts() {
    return GridView.builder(
      shrinkWrap: true,
      primary: true,
      itemCount: topArtisanList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, index) {
        //get artisans rating
        rating = Artisans.ratingApproach(topArtisanList[index].rating!);
        return GestureDetector(
          onTap: () async {
            if (topArtisanList[index].id.toString().contains(currentUserId!)) {
//create history
              _historyProvider.updateProviderListener(topArtisanList[index].id,
                  userName, imageUrl, viewedYourProfile);
              //create history
              _historyProvider.createHistory(topArtisanList[index].id!);
            }

            //open artisans profile
            await Navigator.of(context).pushNamed(ArtisanProfile.routeName,
                arguments: topArtisanList[index].id);
          },
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: tenDp, right: tenDp, left: tenDp),
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: Colors.grey, width: 0.7, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(tenDp),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(eightDp),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      strokeWidth: 0.5,
                    ),
                    imageUrl: topArtisanList[index].photoUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 165,
                left: 135,
                child: Center(
                  child: Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(tenDp),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 2),
                          child: Text(
                            "$rating",
                            style: TextStyle(
                                fontSize: fourteenDp, color: Colors.black),
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: fourteenDp,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 10,
      ),
    );
  }
}
