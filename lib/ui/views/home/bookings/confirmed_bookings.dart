import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/service/booking_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/widgets/load_home.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';

class ConfirmedBookings extends StatefulWidget {
  static const routeName = '/confirmedBookings';

  const ConfirmedBookings({Key? key}) : super(key: key);

  @override
  _ConfirmedBookingsState createState() => _ConfirmedBookingsState();
}

class _ConfirmedBookingsState extends State<ConfirmedBookings> {
  @override
  Widget build(BuildContext context) {
    final confirmedBookingList = Provider.of<List<Bookings>>(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: Builder(
          builder: (BuildContext context) {
            return StreamBuilder<List<Bookings>>(
                initialData: [],
                stream: BookingService().getConfirmedBookings(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadHome();
                  } else {
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
                                minVerticalPadding: 25,
                                horizontalTitleGap: 4,
                                tileColor: Colors.indigoAccent,
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // name
                                    Text(
                                      snapshot.data![index].receiverName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: sixDp, bottom: sixDp),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            //
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: eightDp),
                                              child: Text(
                                                  snapshot.data![index].message,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: sixteenDp)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      //  experience
                                      "Status : ${snapshot.data![index].status}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: twentyDp),
                                    )
                                  ],
                                ),
                                leading: Padding(
                                  padding: EdgeInsets.only(top: eightDp),
                                  child: CircleAvatar(
                                    radius: 40,
                                    foregroundImage: CachedNetworkImageProvider(
                                        getUserType == user
                                            ? snapshot
                                                .data![index].receiverPhotoUrl
                                            : snapshot
                                                .data![index].senderPhotoUrl),
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
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                    );
                  }
                });
          },
        ),
      ),
    );
  }
}
