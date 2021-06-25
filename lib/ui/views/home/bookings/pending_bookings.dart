import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';

class PendingBookings extends StatelessWidget {
  static const routeName = '/pendingBookings';

  const PendingBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pendingBookingList = Provider.of<List<Bookings>>(context);
    print("pending list ${pendingBookingList.length}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) {
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
                            pendingBookingList[index].artisanName,
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
                                  //
                                  flex: 1,
                                  child: Text(pendingBookingList[index].message,
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            //  experience
                            pendingBookingList[index].status,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      /* leading: Padding(
                        padding: EdgeInsets.only(top: eightDp),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: CachedNetworkImageProvider(
                              artisanListProvider[index].photoUrl),
                          backgroundColor: Colors.indigo,
                        ),
                      ),*/
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              );
            },
            itemCount: pendingBookingList.length,
            shrinkWrap: true,
          );
        },
      ),
    );
  }
}
