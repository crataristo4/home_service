import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/provider/history_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/show_user_profile.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:home_service/ui/widgets/load_home.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class ReceivedBookingsPage extends StatefulWidget {
  static const routeName = '/receivedBookings';

  const ReceivedBookingsPage({Key? key}) : super(key: key);

  @override
  _ReceivedBookingsPageState createState() => _ReceivedBookingsPageState();
}

class _ReceivedBookingsPageState extends State<ReceivedBookingsPage> {
  CollectionReference bookingCR =
      FirebaseFirestore.instance.collection('Bookings');
  HistoryProvider _historyProvider = HistoryProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  final receivedBookingList = Provider.of<List<ReceivedBookings>>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: eightDp),
        child: StreamBuilder<QuerySnapshot>(
          stream: bookingCR
              .orderBy("timestamp", descending: true)
              .where("receiverId", isEqualTo: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadHome();
            }

            if (snapshot.data!.docs.isEmpty) {
              return Column(
                children: [
                  Text(
                    noBookingsReceived,
                    style: TextStyle(fontSize: twentyDp),
                  ),
                  Image.asset(
                    "assets/images/nobookings.jpg",
                    fit: BoxFit.cover,
                  ),
                ],
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];

                return Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: ListTile(
                        onTap: () async {
                          doc['type']! == user
                              ? await showModalBottomSheet(
                                  context: context,
                                  builder: (context) => UserProfile(
                                        userId: doc['senderId'],
                                      ))
                              : await Navigator.of(context).pushNamed(
                                  ArtisanProfile.routeName,
                                  arguments: doc['senderId'],
                                );
                        },
                        minVerticalPadding: 25,
                        horizontalTitleGap: 1,
                        tileColor: Colors.grey[100],
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // name of sender
                                  doc['senderName']!,
                                  style: TextStyle(color: Colors.black),
                                ),
                                doc['status'] == confirmed
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                      )
                                    : Container()
                              ],
                            ),

                            //time sent
                            Padding(
                              padding: EdgeInsets.only(bottom: fourDp),
                              child: Row(
                                children: [
                                  Text(received,
                                      style: TextStyle(
                                        fontSize: fourteenDp,
                                        color: Colors.black45,
                                      )),
                                  Icon(Icons.access_time,
                                      color: Colors.black45),
                                  Padding(
                                    padding: EdgeInsets.only(left: eightDp),
                                    child: Text(
                                      timeAgo.format(doc['timestamp'].toDate()),
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: fourteenDp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: fourDp,
                            ),
                            Text(bookingMessage,
                                style: TextStyle(color: Colors.black45)),
                            Padding(
                              padding: EdgeInsets.only(bottom: eightDp, top: 2),
                              child: Text(doc['message']!,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: sixteenDp)),
                            ),
                            Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: fourDp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(bookingDate),

                                //show as rescheduled if changes booking time
                                Text(
                                  doc['isReschedule'] == true
                                      ? rescheduled
                                      : "",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: fourDp,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: doc['status'] == pending
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  doc['bookingDate']!,
                                  style: TextStyle(
                                      color: doc['status'] == pending
                                          ? Colors.blue
                                          : Colors.green,
                                      fontSize: fourteenDp,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: tenDp,
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.9,
                            ),
                            SizedBox(
                              height: fourDp,
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: fourteenDp,
                              ),
                            ),
                            Text(
                              doc['status'],
                              style: TextStyle(
                                  color: doc['status'] == confirmed
                                      ? Colors.green
                                      : Colors.blue,
                                  fontSize: sixteenDp),
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
                            Container(
                              height: fortyEightDp,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: doc['status'] == pending
                                          ? Theme.of(context).primaryColor
                                          : Colors.green,
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(eightDp))),
                                  onPressed: () {
                                    //else do nothing
                                    if (doc['status'] == confirmed) {
                                      //show toast
                                      ShowAction().showToast(
                                          "Already confirmed", Colors.green);
                                    } else {
                                      //update booking
                                      BookingsProvider()
                                          .updateBookingsConfirmed(
                                              context, doc['id']!);
                                    }
                                  },
                                  child: Text(
                                    doc['status'] == confirmed
                                        ? confirmed
                                        : approve,
                                    style: TextStyle(fontSize: fourteenDp),
                                  )),
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding: EdgeInsets.only(top: eightDp),
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: CachedNetworkImageProvider(
                                doc['senderPhotoUrl']!),
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
              itemCount: snapshot.data!.docs.length,
              addAutomaticKeepAlives: true,
              shrinkWrap: true,
              //todo - to be added in future
              /*      separatorBuilder: (BuildContext context, int index) {
                      return index % 3 == 0
                          ? Container(
                              margin: EdgeInsets.only(bottom: sixDp),
                              height: twoFiftyDp,
                              child: AdWidget(
                                ad: AdmobService.createBanner()..load(),
                                key: UniqueKey(),
                              ),
                            )
                          : Container();
                    },*/
            );
          },
        ),
      ),
    );
  }
}
