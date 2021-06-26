import 'package:flutter/material.dart';
import 'package:home_service/models/booking.dart';
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //artisans name
                            Text(
                              confirmedBookingList[index].artisanName,
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
                                    child: Text(
                                        confirmedBookingList[index].message,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              //  experience
                              confirmedBookingList[index].status,
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
              itemCount: confirmedBookingList.length,
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}