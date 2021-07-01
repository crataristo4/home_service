import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';

class UserPendingBookings extends StatefulWidget {
  static const routeName = '/userPendingBookings';

  const UserPendingBookings({Key? key}) : super(key: key);

  @override
  _UserPendingBookingsState createState() => _UserPendingBookingsState();
}

class _UserPendingBookingsState extends State<UserPendingBookings> {
  @override
  Widget build(BuildContext context) {
    final bookingList = Provider.of<List<Bookings>>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: Builder(
          builder: (BuildContext context) {
            return ListView.builder(
              itemBuilder: (context, index) {
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
                              bookingList[index].receiverName!,
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                              bookingList[index].senderName!,
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
                                    child: Text(bookingList[index].message!,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              //  experience
                              bookingList[index].status!,
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
                                    ? bookingList[index].receiverPhotoUrl!
                                    : bookingList[index].senderPhotoUrl!),
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
              itemCount: bookingList.length,
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}
