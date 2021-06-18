import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/models/artisan_type.dart';

import '../../../constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                margin: EdgeInsets.only(top: seventyDp, left: sixteenDp),
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
                                    image: AssetImage("assets/images/a.png"),
                                  )),
                            ),

                            //Search for artisans
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: sixteenDp, vertical: eightDp),
                                child: TextField(
                                    keyboardType: TextInputType.text,
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
                                              // border: Border.all(width: 2,color: Colors.white54),
                                            ),
                                          ),
                                        ),
                                        hintText: searchService,
                                        fillColor: Colors.white70,
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: tenDp),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white70),
                                        ))),
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
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10, right: 10),
                      child: SizedBox(
                        height: fortyEightDp,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(eightDp))),
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/homePage'),
                            child: Text(
                              verifyNumber,
                              style: TextStyle(fontSize: fourteenDp),
                            )),
                      ),
                    )
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
      margin: EdgeInsets.only(right: 14),
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
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(twelveDp),
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.deepPurple],
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
                              fontSize: sixteenDp),
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
            );
          }),
    );
  }
}
