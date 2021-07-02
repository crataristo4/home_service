import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class ReceivedBookings extends StatefulWidget {
  static const routeName = '/receivedBookings';

  const ReceivedBookings({Key? key}) : super(key: key);

  @override
  _ReceivedBookingsState createState() => _ReceivedBookingsState();
}

class _ReceivedBookingsState extends State<ReceivedBookings> {
  @override
  Widget build(BuildContext context) {
    final receivedBookingList = Provider.of<List<Bookings>>(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: Builder(
          builder: (BuildContext context) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: ListTile(
                        onTap: () {
                          //1.pass artisans details
                          //todo
                          //2.navigate to artisan's profile
                        },
                        minVerticalPadding: 25,
                        horizontalTitleGap: 1,
                        tileColor: Colors.grey[100],
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
                                      ? receivedBookingList[index].receiverName!
                                      : receivedBookingList[index].senderName!,
                                  style: TextStyle(color: Colors.black),
                                ),
                                receivedBookingList[index].status == confirmed
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
                                  Icon(Icons.access_time,
                                      color: Colors.black45),
                                  Padding(
                                    padding: EdgeInsets.only(left: eightDp),
                                    child: Text(
                                      timeAgo.format(receivedBookingList[index]
                                          .timestamp
                                          .toDate()),
                                      style: TextStyle(color: Colors.black45),
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
                              child: Text(receivedBookingList[index].message!,
                                  style: TextStyle(
                                      color: Colors.black87,
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
                              "Booking date: ${receivedBookingList[index].bookingDate}",
                              style: TextStyle(
                                  color: Colors.grey,
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
                                      color: Colors.black,
                                      fontSize: twentyDp,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  "${receivedBookingList[index].status}",
                                  style: TextStyle(
                                      color:
                                          receivedBookingList[index].status ==
                                                  confirmed
                                              ? Colors.green
                                              : Colors.blue,
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
                                        style:
                                            TextButton.styleFrom(
                                                backgroundColor:
                                                    receivedBookingList[index]
                                                                .status ==
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
                                          if (receivedBookingList[index]
                                                  .status ==
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
                                                    receivedBookingList[index]
                                                        .id!);
                                          }
                                        },
                                        child: Text(
                                          receivedBookingList[index].status ==
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
                                    ? receivedBookingList[index]
                                        .receiverPhotoUrl!
                                    : receivedBookingList[index]
                                        .senderPhotoUrl!),
                            backgroundColor: Colors.indigo,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    )
                  ],
                );
              },
              itemCount: receivedBookingList.length,
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}
