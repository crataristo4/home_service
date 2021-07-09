import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:home_service/models/artisan_type.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/ui/views/artisan/view_all_artisans.dart';
import 'package:home_service/ui/views/artisan/view_artisan_by_category.dart';
import 'package:home_service/ui/views/artisan/view_top_experts.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class CategoryPage extends StatefulWidget {
  static const routeName = '/categoryPage';

  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController _searchInput = new TextEditingController();

  bool _isSearch = true;
  String _searchText = "";

  List<String>? _searchListItems;
  List<String>? _imageListItems;
  List<String>? _artisanListItems;
  List<String>? _artisanImageListItems;

  late List<Artisans> topArtisanList;
  late double? rating;

  @override
  void initState() {
    super.initState();
    _artisanListItems = <String>[];
    _artisanListItems = artisanListItems;
    _artisanImageListItems = <String>[];
    _artisanImageListItems = artisanImageListItems;
    _artisanListItems!.sort();
    _artisanImageListItems!.sort();
  }

  _CategoryPageState() {
    _searchInput.addListener(() {
      _searchInput.text.isEmpty
          ? setState(() {
              _isSearch = true;
              _searchText = "";
            })
          : setState(() {
              _isSearch = false;
              _searchText = _searchInput.text;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    topArtisanList = Provider.of<List<Artisans>>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                margin: EdgeInsets.only(left: eightDp, right: eightDp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: eightDp,
                        ),
                        topArtisanList.isEmpty
                            ? Container()
                            : Container(
                                //top expects
                                margin:
                                    EdgeInsets.only(bottom: sixDp, top: sixDp),
                                child: SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            topExperts,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: sixteenDp),
                                          ),
                                          topArtisanList.length > 10
                                              ? Container(
                                                  padding:
                                                      EdgeInsets.all(sixDp),
                                                  margin: EdgeInsets.only(
                                                      right: sixteenDp),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              fourDp),
                                                      border: Border.all(
                                                          width: 0.3,
                                                          color: Colors.grey
                                                              .withOpacity(0.3))),
                                            child: GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(ViewAllTopExperts
                                                                .routeName),
                                                    child: Text(
                                                      // view all top expects
                                                      viewAll,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: twelveDp),
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                      Expanded(
                                        // display to experts
                                        child: buildTopExpect(),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        //todo -- add when admob account is verified
                        /*  Container(
                          // shows a banner ad
                          height: twoFiftyDp,
                          child: AdWidget(
                            ad: AdmobService.createBanner()..load(),
                            key: UniqueKey(),
                          ),
                        ),*/
                        Container(
                          margin: EdgeInsets.only(
                            right: eightDp,
                          ),
                          child: TextFormField(
                              //search for a service text field
                              keyboardType: TextInputType.text,
                              controller: _searchInput,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: sixteenDp),
                                  suffix: Container(
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    width: thirtySixDp,
                                    height: thirtySixDp,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius:
                                          BorderRadius.circular(eightDp),
                                      border: Border.all(
                                          width: 0.5, color: Colors.white54),
                                    ),
                                  ),
                                  hintText: searchService,
                                  fillColor: Colors.white70,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: tenDp, horizontal: tenDp),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFF5F5F5)),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFF5F5F5))))),
                        ),

                        SizedBox(
                          height: sixteenDp,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chooseAservice,
                              style: TextStyle(
                                  fontSize: twentyDp,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(ViewAllArtisans.routeName),
                              child: Container(
                                padding: EdgeInsets.all(sixDp),
                                margin: EdgeInsets.only(right: sixteenDp),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(fourDp),
                                    border: Border.all(
                                        width: 0.3,
                                        color: Colors.grey.withOpacity(0.3))),
                                child: Text(
                                  viewAll,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: twelveDp,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: sixteenDp,
                        ),
                        _isSearch ? displayArtisanTypes() : _searchList(),
                        // switch between searched list and default list
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  //method to search category and sort grid list
  Widget _searchList() {
    _searchListItems = <String>[];
    _imageListItems = <String>[];
    for (int i = 0; i < _artisanListItems!.length; i++) {
      var item = _artisanListItems![i];
      var images = _artisanImageListItems![i];

      if (item.toLowerCase().contains(_searchText.toLowerCase())) {
        _searchListItems!.add(item);
        _imageListItems!.add(images);
      }
    }
    return displaySearchedArtisanTypes();
  }

  //initial list of all category of artisans available
  Widget displayArtisanTypes() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(
        right: fourDp,
      ),
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
              onTap: () {
                //push to View artisans by category page
                Navigator.of(context).pushNamed(
                    ViewArtisanByCategoryPage.routeName,
                    arguments: getArtisanType[index].name);
              },
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
                            // getArtisanType[index].name,
                            _artisanListItems![index],
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
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60,
                        child: ClipOval(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.asset(
                              getArtisanType[index].image,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  //display list as user search
  Widget displaySearchedArtisanTypes() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(
        right: fourDp,
      ),
      height: MediaQuery.of(context).size.height / 1.68,
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: _searchListItems!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: twelveDp,
            mainAxisSpacing: twelveDp,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                    ViewArtisanByCategoryPage.routeName,
                    arguments: _searchListItems![index]);
              },
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
                            _searchListItems![index],
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
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      child: ClipOval(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.asset(
                            _imageListItems![index],
                            fit: BoxFit.cover,
                          )),
                    ),
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
      itemCount: topArtisanList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, index) {
        //get artisans rating
        rating = Artisans.ratingApproach(topArtisanList[index].rating!);
        return GestureDetector(
          onTap: () async {
            //open artisans profile
            await Navigator.of(context).pushNamed(ArtisanProfile.routeName,
                arguments: topArtisanList[index].id);
          },
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: tenDp, right: tenDp),
                width: sixtyDp,
                height: sixtyDp,
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
                          "$rating",
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
