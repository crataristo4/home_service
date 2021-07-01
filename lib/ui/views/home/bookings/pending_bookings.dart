import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';

class PendingBookings extends StatelessWidget {
  static const routeName = '/pendingBookings';

  const PendingBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingsList = Provider.of<List<Bookings>>(context);
    print("Data length ${bookingsList.length}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: Builder(
          builder: (BuildContext context) {
            return ListView.builder(
              itemBuilder: (context, index) {
                print("Data length ${bookingsList.length}");
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: eightDp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 20, color: Colors.indigoAccent)),
                      child: ListTile(
                        onTap: () {
                          //1.pass artisans details
                          //todo
                          //2.navigate to artisan's profile
                        },
                        minVerticalPadding: 10,
                        horizontalTitleGap: 4,
                        tileColor: Colors.indigoAccent,
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //artisans name
                            getUserType == user
                                ? Text(
                                    bookingsList[index].receiverName,
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    bookingsList[index].senderName,
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: sixDp, bottom: sixDp),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    //
                                    flex: 1,
                                    child: Text(bookingsList[index].message,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              //  experience
                              bookingsList[index].status,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        leading: Padding(
                          padding: EdgeInsets.only(top: eightDp),
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: CachedNetworkImageProvider(
                                getUserType == user
                                    ? bookingsList[index].receiverPhotoUrl
                                    : bookingsList[index].senderPhotoUrl),
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
              itemCount: bookingsList.length,
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}
