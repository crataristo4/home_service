import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:provider/provider.dart';

class UserBookingsConfirmed extends StatefulWidget {
  static const routeName = '/userConfirmedBookings';

  const UserBookingsConfirmed({Key? key}) : super(key: key);

  @override
  _UserBookingsConfirmedState createState() => _UserBookingsConfirmedState();
}

class _UserBookingsConfirmedState extends State<UserBookingsConfirmed> {
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
                            // name
                            Text(
                              confirmedBookingList[index].receiverName!,
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
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: eightDp),
                                      child: Text(
                                          confirmedBookingList[index].message!,
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
                              "Status : ${confirmedBookingList[index].status}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: twentyDp),
                            ),

                            //button for artisans to confirm bookings
                            getUserType == user
                                ? Container()
                                : SizedBox(
                                    height: fortyEightDp,
                                    width: MediaQuery.of(context).size.width,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: thirtySixDp),
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8))),
                                          onPressed: () {}, //else do nothing
                                          child: Text(
                                            approve,
                                            style: TextStyle(fontSize: 14),
                                          )),
                                    ),
                                  ),
                          ],
                        ),
                        leading: Padding(
                          padding: EdgeInsets.only(top: eightDp),
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: CachedNetworkImageProvider(
                                getUserType == user
                                    ? confirmedBookingList[index]
                                        .receiverPhotoUrl!
                                    : confirmedBookingList[index]
                                        .senderPhotoUrl!),
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
              itemCount: confirmedBookingList.length,
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}
