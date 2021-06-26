import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/service/booking_service.dart';
import 'package:home_service/ui/views/home/home.dart';
import 'package:home_service/ui/widgets/load_home.dart';

import '../../../../constants.dart';

class PendingBookings extends StatelessWidget {
  static const routeName = '/pendingBookings';

  const PendingBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: Builder(
          builder: (BuildContext context) {
            return StreamBuilder<List<Bookings>>(
                initialData: [],
                stream: BookingService().getPendingBookings(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadHome();
                  } else {
                    print("Data length == ${snapshot.data!.length}");

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //artisans name
                                    getUserType == user
                                        ? Text(
                                            snapshot.data![index].receiverName,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : Text(
                                            snapshot.data![index].senderName,
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            child: Text(
                                                snapshot.data![index].message,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      //  experience
                                      snapshot.data![index].status,
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
