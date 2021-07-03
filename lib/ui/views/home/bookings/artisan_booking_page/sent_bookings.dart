import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/artisan/bookings.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class SentBookingsPage extends StatefulWidget {
  static const routeName = '/sentBookings';

  const SentBookingsPage({Key? key}) : super(key: key);

  @override
  _SentBookingsState createState() => _SentBookingsState();
}

class _SentBookingsState extends State<SentBookingsPage> {
  @override
  Widget build(BuildContext context) {
    final sentBookingsList = Provider.of<List<SentBookings>>(context);

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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: ListTile(
                        onTap: () async {
                          await Navigator.of(context).pushNamed(
                            ArtisanProfile.routeName,
                            arguments: sentBookingsList[index].receiverId,
                          );
                        },
                        minVerticalPadding: 10,
                        horizontalTitleGap: 4,
                        tileColor: Colors.grey[100],
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sentBookingsList[index].receiverName!,
                              style: TextStyle(color: Colors.black),
                            ),
                            Row(
                              children: [
                                Text("Sent ",
                                    style: TextStyle(
                                      fontSize: fourteenDp,
                                      color: Colors.black45,
                                    )),
                                Icon(Icons.access_time, color: Colors.black45),
                                Padding(
                                  padding: EdgeInsets.only(left: fourDp),
                                  child: Text(
                                    timeAgo.format(sentBookingsList[index]
                                        .timestamp
                                        .toDate()),
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: fourteenDp),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: sixDp,
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.9,
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: sixDp,
                            ),
                            Text("Booking Message",
                                style: TextStyle(color: Colors.black45)),
                            Padding(
                              padding: EdgeInsets.only(top: 2, bottom: sixDp),
                              child: Flexible(
                                //
                                flex: 1,
                                child: Text(sentBookingsList[index].message!,
                                    style: TextStyle(color: Colors.black87)),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.9,
                            ),
                            SizedBox(
                              height: sixDp,
                            ),
                            Text("Booking date "),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: fourDp),
                                  child: Text(
                                    //  booking date
                                    sentBookingsList[index].bookingDate!,
                                    style: TextStyle(
                                        color: sentBookingsList[index].status ==
                                                pending
                                            ? Colors.blue
                                            : Colors.green),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: sixDp,
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.9,
                            ),
                            SizedBox(
                              height: sixDp,
                            ),
                            Text(
                              "Status",
                              style: TextStyle(color: Colors.black45),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              //  status
                              sentBookingsList[index].status!,
                              style: TextStyle(
                                  color:
                                      sentBookingsList[index].status == pending
                                          ? Colors.blue
                                          : Colors.green),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.9,
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: EdgeInsets.only(top: eightDp),
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: CachedNetworkImageProvider(
                                sentBookingsList[index].receiverPhotoUrl!),
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
                      height: 10,
                    )
                  ],
                );
              },
              itemCount: sentBookingsList.length,
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}
