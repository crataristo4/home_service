import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../constants.dart';

class ViewArtisanByCategoryPage extends StatefulWidget {
  final categoryName;

  const ViewArtisanByCategoryPage({Key? key, this.categoryName})
      : super(key: key);

  @override
  _ViewArtisanByCategoryPageState createState() =>
      _ViewArtisanByCategoryPageState();
}

class _ViewArtisanByCategoryPageState extends State<ViewArtisanByCategoryPage> {
  int? _selectedItem;

  @override
  Widget build(BuildContext context) {
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
          widget.categoryName,
          style: TextStyle(
              color: Colors.black,
              fontSize: sixteenDp,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          //user profile image
          Container(
            margin: EdgeInsets.only(right: tenDp, top: tenDp),
            width: sixtyDp,
            height: seventyDp,
            decoration: BoxDecoration(
                border: Border.all(width: 0.3, color: Colors.grey),
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(eightDp),
                // border: Border.all(width: 2,color: Colors.white54),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      "assets/images/a.png"), //todo -load image from network
                )),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: twelveDp),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(thirtySixDp),
                topRight: Radius.circular(thirtySixDp)),
            border:
                Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: sixteenDp, top: twentyDp),
                  child: Text(
                    "150 ${widget.categoryName}\'s near you ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: twentyDp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: sixteenDp, vertical: sixteenDp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: fourDp),
                        child: Icon(
                          Icons.map,
                          size: thirtyDp,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(fourDp),
                        child: Icon(
                          Icons.widgets,
                          size: twentyFourDp,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: fourDp, top: fourDp),
                        child: Icon(
                          Icons.view_stream,
                          size: thirtyDp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: sixteenDp,
            ),
            Expanded(
              flex: 1,
              child: ListView(
                shrinkWrap: true,
                children: [
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory(),
                  buildListCategory()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListCategory() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: tenDp, vertical: tenDp),
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.grey),
          borderRadius: BorderRadius.circular(tenDp)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //artisans profile image
              Container(
                margin: EdgeInsets.all(tenDp),
                width: eightyDp,
                height: eightyDp,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.3, color: Colors.grey.withOpacity(0.2)),
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(eightDp),
                    // border: Border.all(width: 2,color: Colors.white54),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          "assets/images/a.png"), //todo -load image from network
                    )),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: tenDp),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //artisan name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Chantel Abrum",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: sixteenDp),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              "3 km",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: sixteenDp,
                              ),
                            ),
                          ],
                        ),
                        RatingBar.builder(
                          itemSize: 20,
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
                        SizedBox(
                          height: sixteenDp,
                        ),
                        Text(
                          "5 years Experience",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: sixteenDp,
                              color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: fortyEightDp,
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.only(
                  left: sixteenDp, right: sixteenDp, bottom: fourDp),
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(eightDp))),
                  onPressed: () {},
                  child: Text(
                    book,
                    style: TextStyle(fontSize: fourteenDp),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget buildGridCategory() {
    return Container();
  }
}
