import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/constants.dart';
import 'package:home_service/models/artisan/bookings.dart';
import 'package:home_service/ui/views/profile/artisan_profile.dart';
import 'package:provider/provider.dart';

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
                        title: Text(
                          sentBookingsList[index].receiverName!,
                          style: TextStyle(color: Colors.black),
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
                                        sentBookingsList[index].message!,
                                        style:
                                            TextStyle(color: Colors.black87)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              //  experience
                              sentBookingsList[index].status!,
                              style: TextStyle(
                                  color:
                                      sentBookingsList[index].status == pending
                                          ? Colors.blue
                                          : Colors.green),
                            )
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
