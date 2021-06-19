import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/models/artisan_type.dart';

import '../../../constants.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                margin: EdgeInsets.only(left: sixteenDp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //user profile image
                            Container(
                              margin: EdgeInsets.only(top: sixDp),
                              width: sixtyDp,
                              height: sixtyDp,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                  BorderRadius.circular(sixteenDp),
                                  // border: Border.all(width: 2,color: Colors.white54),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/images/a.png"), //todo -load image from network
                                  )),
                            ),

                            //Search for artisans
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: sixteenDp, vertical: eightDp),
                                child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        hintStyle:
                                            TextStyle(fontSize: sixteenDp),
                                        suffix: GestureDetector(
                                          onTap: () {
                                            debugPrint("Searching");
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.search,
                                              color: Colors.white,
                                            ),
                                            width: thirtySixDp,
                                            height: thirtySixDp,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      eightDp),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white54),
                                            ),
                                          ),
                                        ),
                                        hintText: searchService,
                                        fillColor: Colors.white70,
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: tenDp, horizontal: tenDp),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFF5F5F5)),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF5F5F5))))),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: sixteenDp,
                        ),
                        Text(
                          "Hi , Dixie Carter",
                          style: TextStyle(fontSize: twentyDp),
                        ),
                        SizedBox(
                          height: eightDp,
                        ),
                        Container(
                          margin:
                          EdgeInsets.only(bottom: 10, top: 10, right: 10),
                          child: SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Top Experts",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: sixteenDp),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: eightDp),
                                      child: Text(
                                        "View all",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: twelveDp),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: buildTopExpect(),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "Choose a service",
                          style: TextStyle(
                              fontSize: twentyDp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: sixteenDp,
                        ),
                        displayArtisanTypes(),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget displayArtisanTypes() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: fourDp, bottom: twelveDp),
      height: MediaQuery.of(context).size.height / 1.68,
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: getArtisanType.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: twelveDp,
            mainAxisSpacing: twelveDp,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  "/viewArtisanByCategoryPage",
                  arguments: getArtisanType[index].name),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(twelveDp),
                  gradient: LinearGradient(
                    colors: [
                      getArtisanType[index].bgColor[0],
                      getArtisanType[index].bgColor[1]
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: fourteenDp, left: fourDp),
                          child: Text(
                            getArtisanType[index].name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: twelveDp),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: tenDp, top: tenDp),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(thirtyDp)),
                          child: Padding(
                            padding: EdgeInsets.all(eightDp),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: sixteenDp,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildTopExpect() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 30,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: tenDp, right: tenDp),
                width: sixtyDp,
                height: sixtyDp,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey,
                        width: 0.2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(tenDp),
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/aa.jpg"))),
              ),
              Positioned(
                top: 55,
                left: 25,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey,
                        width: 0.2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(tenDp),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 2),
                        child: Text(
                          "4.5",
                          style: TextStyle(fontSize: tenDp),
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: tenDp,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}