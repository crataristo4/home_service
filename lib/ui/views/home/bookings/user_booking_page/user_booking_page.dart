import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/booking.dart';
import 'package:home_service/provider/bookings_provider.dart';
import 'package:home_service/provider/history_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/views/bottomsheet/add_booking.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:home_service/ui/widgets/load_home.dart';
import 'package:home_service/ui/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class UserBookingsPage extends StatefulWidget {
  const UserBookingsPage({Key? key}) : super(key: key);

  @override
  _UserBookingsPageState createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> {
  CollectionReference bookingCR =
      FirebaseFirestore.instance.collection('Bookings');
  int? bookingCount;
  FirebaseAuth mAuth = FirebaseAuth.instance;
  String? uid;
  HistoryProvider _historyProvider = HistoryProvider();

  @override
  void initState() {
    getBookingItemCount();
    uid = mAuth.currentUser!.uid;
    super.initState();
  }

  //method to get number of bookings
  Future<void> getBookingItemCount() async {
    QuerySnapshot querySnapshot = await bookingCR
        .orderBy("timestamp", descending: true)
        .where("senderId", isEqualTo: uid)
        .get();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;


    setState(() {
      bookingCount = documentSnapshot.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userBookingList = Provider.of<List<Bookings>>(context);
    final bookingProvider = BookingsProvider();

    //options bottom sheet
    void showOptions(context, index) async {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              color: Color(0xFF757575),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(twentyDp),
                        topRight: Radius.circular(twentyDp))),
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        title: Text(rescheduleBookings,
                            style: TextStyle(color: Colors.black)),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) => AddBooking.reschedule(
                                    //bottom sheet reschedule bookings
                                    bookings: userBookingList[index],
                                  ));
                        }),
                    ListTile(
                      leading: Icon(
                        Icons.remove_red_eye,
                        color: Colors.indigoAccent,
                      ),
                      title: Text(
                        viewProfile,
                        style: TextStyle(color: Colors.indigoAccent),
                      ),
                      onTap: () async {
                        _historyProvider.updateProviderListener(
                            userBookingList[index].receiverId,
                            userName,
                            imageUrl,
                            viewedYourProfile);
                        //create history
                        _historyProvider
                            .createHistory(userBookingList[index].receiverId!);

                        await Navigator.of(context).pushNamed(
                          ArtisanProfile.routeName,
                          arguments: userBookingList[index].receiverId,
                        );
                      },
                    ),
                    ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(deleteBookings,
                            style: TextStyle(color: Colors.red)),
                        onTap: () {
                          //delete bookings
                          Dialogs.showLoadingDialog(context, loadingKey,
                              deletingBooking, Colors.white70);
                          //delete bookings
                          bookingProvider.deleteBook(
                              context, userBookingList[index].id!);
                        }),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: bookingCount == 0 || bookingCount == null
            ? Text(noBookingsMade)
            : Text("$bookingCount $bookingsMade"),
      ),
      body: Container(
            child: StreamBuilder<QuerySnapshot>(
            stream: bookingCR
                .orderBy("timestamp", descending: true)
                .where("senderId", isEqualTo: currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadHome();
              }

              if (snapshot.data!.docs.isEmpty) {
                return Image.asset(
                  "assets/images/nobookings.jpg",
                  fit: BoxFit.cover,
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: tenDp, vertical: 2),
                        child: ListTile(
                          onTap: () {
                            showOptions(context, index);
                          },
                          minVerticalPadding: tenDp,
                          horizontalTitleGap: 4,
                          tileColor: Colors.grey[100],
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    //name of receiver
                                    doc['receiverName'],
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
                              Row(
                                children: [
                                  Text(sent,
                                      style: TextStyle(
                                        fontSize: fourteenDp,
                                        color: Colors.black45,
                                      )),
                                  Icon(Icons.access_time,
                                      color: Colors.black45),
                                  Padding(
                                    padding: EdgeInsets.only(left: fourDp),
                                    child: Text(
                                      timeAgo.format(doc["timestamp"].toDate()),
                                      style: TextStyle(
                                          color: Colors.black,
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
                                height: tenDp,
                              ),
                              Text(bookingMessage,
                                  style: TextStyle(color: Colors.black45)),
                              Padding(
                                padding: EdgeInsets.only(top: 2, bottom: sixDp),
                                child: Text(doc["message"],
                                    style: TextStyle(
                                      color: Colors.black87,
                                    )),
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.9,
                              ),
                              SizedBox(
                                height: tenDp,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    bookingDate,
                                  ),
                                  //show as rescheduled if changes booking time
                                  Text(
                                    doc["isReschedule"] == true
                                        ? rescheduled
                                        : "",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  doc["isReschedule"] == true
                                      ? Shimmer.fromColors(
                                          period: Duration(seconds: 5),
                                          baseColor: Colors.black,
                                          highlightColor: Colors.red,
                                          child: Icon(
                                            Icons.calendar_today,
                                            color: doc['status'] == pending
                                                ? Colors.blue
                                                : Colors.green,
                                          ),
                                        )
                                      : Icon(
                                          Icons.calendar_today,
                                          color: doc['status'] == pending
                                              ? Colors.blue
                                              : Colors.green,
                                        ),
                                  Padding(
                                    padding: EdgeInsets.only(left: fourDp),
                                    child: doc["isReschedule"] == true
                                        ? Shimmer.fromColors(
                                            period: Duration(seconds: 5),
                                            baseColor: Colors.black,
                                            highlightColor: Colors.red,
                                            child: Text(
                                              //  booking date
                                              doc['bookingDate'],
                                              style: TextStyle(
                                                  color:
                                                      doc['status'] == pending
                                                          ? Colors.blue
                                                          : Colors.green,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          )
                                        : Text(
                                            //  booking date
                                            doc['bookingDate'],
                                            style: TextStyle(
                                                color: doc['status'] == pending
                                                    ? Colors.blue
                                                    : Colors.green,
                                                fontStyle: FontStyle.italic),
                                          ),
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
                                height: tenDp,
                              ),
                              Text(
                                status,
                                style: TextStyle(color: Colors.black45),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                //  status
                                doc['status'],
                                style: TextStyle(
                                    color: doc['status'] == pending
                                        ? Colors.blue
                                        : Colors.green),
                              ),
                              SizedBox(
                                height: tenDp,
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
                                  doc['receiverPhotoUrl']),
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
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                //todo - to be added in future
                /*     separatorBuilder: (BuildContext context, int index) {
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
                    addAutomaticKeepAlives: true,
                  );
                })));
  }
}
