import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../../../constants.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);
  static const routeName = '/historyPage';

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  CollectionReference cf = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final historyList = Provider.of<List<History>>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: EdgeInsets.all(tenDp),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.3, color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(thirtyDp)),
              child: Padding(
                padding: EdgeInsets.all(eightDp),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: sixteenDp,
                ),
              ),
            ),
          ),
          title: Text(notifications, style: TextStyle(color: Colors.black)),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: cf
                .doc(currentUserId)
                .collection('History')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(noNotifications),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: tenDp, vertical: 2),
                        child: ListTile(
                          onTap: () {},
                          minVerticalPadding: 20,
                          horizontalTitleGap: 0,
                          tileColor: Colors.grey[100],
                          title: Text(
                            //name of viewer
                            doc['name'],
                            style: TextStyle(
                                color: Colors.black, fontSize: sixteenDp),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 2, bottom: sixDp, right: 2),
                                  child: Text(doc['message'],
                                      style: TextStyle(
                                        color: Colors.black87,
                                      )),
                                ),
                              ),
                              Icon(Icons.access_time, color: Colors.black45),
                              Padding(
                                padding: EdgeInsets.only(left: fourDp),
                                child: Text(
                                  timeAgo.format(doc['timestamp'].toDate()),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: fourteenDp),
                                ),
                              ),
                            ],
                          ),
                          leading: Padding(
                            padding: EdgeInsets.only(top: eightDp),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  CachedNetworkImageProvider(doc['photoUrl']),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: tenDp,
                      )
                    ],
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            }));
  }
}
