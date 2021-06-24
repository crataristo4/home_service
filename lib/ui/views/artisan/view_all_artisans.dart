import 'package:flutter/material.dart';
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
            return Text(artisanListProvider[index].artisanName);
          },
          itemCount: artisanListProvider.length,
          shrinkWrap: true,
          primary: true,
        );
      }),
    );
  }
}
