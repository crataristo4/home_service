import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:home_service/constants.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:provider/provider.dart';

class UserBookingsPage extends StatefulWidget {
  const UserBookingsPage({Key? key}) : super(key: key);

  @override
  _UserBookingsPageState createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> {
  @override
  Widget build(BuildContext context) {
    final allBookingList = Provider.of<List<Bookings>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Center(child: Text(allYourBookingAppearHere)),
      ),
      body: Container(
        child: Builder(
          builder: (BuildContext context) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: eightDp, vertical: eightDp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(sixteenDp),
                          border: Border.all(
                              width: twentyDp, color: Colors.indigoAccent)),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ArtisanProfile.routeName,
                            arguments: allBookingList[index].receiverId,
                          );
                        },
                        minVerticalPadding: 25,
                        horizontalTitleGap: 1,
                        tileColor: Colors.indigoAccent,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // name
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getUserType == user
                                      ? allBookingList[index].receiverName!
                                      : allBookingList[index].senderName!,
                                  style: TextStyle(color: Colors.white),
                                ),
                                allBookingList[index].status == confirmed
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                      )
                                    : Container()
                              ],
                            ),

                            //time sent
                            Padding(
                              padding:
                                  EdgeInsets.only(top: fourDp, bottom: eightDp),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time),
                                  Padding(
                                    padding: EdgeInsets.only(left: eightDp),
                                    child: Text(
                                      timeAgo.format(allBookingList[index]
                                          .timestamp
                                          .toDate()),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: tenDp,
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: eightDp),
                              child: Text(allBookingList[index].message!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: sixteenDp)),
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: tenDp,
                            ),
                            Text(
                              "Booking date: ${allBookingList[index].bookingDate}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fourteenDp,
                                  fontStyle: FontStyle.italic),
                            ),
                            SizedBox(
                              height: tenDp,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Status: ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: twentyDp,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  "${allBookingList[index].status}",
                                  style: TextStyle(
                                      color: allBookingList[index].status ==
                                              confirmed
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: twentyDp),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: tenDp,
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: tenDp,
                            ),
                            //button for artisans to confirm bookings
                            getUserType == user
                                ? Container()
                                : Container(
                                    height: fortyEightDp,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                allBookingList[index].status ==
                                                        pending
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.green,
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        eightDp))),
                                        onPressed: () {
                                          //else do nothing
                                          if (allBookingList[index].status ==
                                              confirmed) {
                                            //show toast
                                            ShowAction().showToast(
                                                "Already confirmed",
                                                Colors.green);
                                          } else {
                                            //update booking
                                            BookingsProvider()
                                                .updateBookingsConfirmed(
                                                    context,
                                                    allBookingList[index].id!);
                                          }
                                        },
                                        child: Text(
                                          allBookingList[index].status ==
                                                  confirmed
                                              ? confirmed
                                              : approve,
                                          style:
                                              TextStyle(fontSize: fourteenDp),
                                        )),
                                  ),
                          ],
                        ),
                        leading: Padding(
                          padding: EdgeInsets.only(top: eightDp),
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: CachedNetworkImageProvider(
                                getUserType == user
                                    ? allBookingList[index].receiverPhotoUrl!
                                    : allBookingList[index].senderPhotoUrl!),
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
              itemCount: allBookingList.length,
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}
