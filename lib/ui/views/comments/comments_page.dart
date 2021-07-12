import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/provider/artwork_provider.dart';
import 'package:home_service/ui/views/auth/appstate.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../../../constants.dart';

class CommentsPage extends StatefulWidget {
  final String? id, name, artworkImageUrl;

  const CommentsPage({Key? key, this.id, this.name, this.artworkImageUrl})
      : super(key: key);
  static const routeName = '/commentsPage';

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  CollectionReference commentsCR =
      FirebaseFirestore.instance.collection('Artworks');
  TextEditingController _addCommentController = TextEditingController();
  ArtworkProvider _artworkProvider = ArtworkProvider();
  List? likes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _addCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white12,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('$comments on ${widget.name}\'s Artwork',
              style: TextStyle(color: Colors.black54, fontSize: 14)),
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
          )),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: tenDp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    //artwork image
                    height: twoHundredDp,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    imageUrl: widget.artworkImageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    color: Colors.white,
                    child: buildComments(),
                    height: MediaQuery.of(context).size.height / 2),
                Container(
                  margin: EdgeInsets.only(
                    bottom: eightDp,
                  ),
                  child: TextFormField(
                      //comment text field
                      keyboardType: TextInputType.text,
                      controller: _addCommentController,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: sixteenDp),
                          suffix: GestureDetector(
                            onTap: () {
                              //add comment
                              if (_addCommentController.text.isNotEmpty) {
                                _artworkProvider.createArtworkComment(context,
                                    widget.id!, _addCommentController.text);
                                _addCommentController.clear();
                              } else {
                                ShowAction().showToast(
                                    commentsCannotBeEmpty, Colors.red);
                              }
                            },
                            child: Container(
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              width: thirtySixDp,
                              height: thirtySixDp,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(eightDp),
                                border: Border.all(
                                    width: 0.5, color: Colors.white54),
                              ),
                            ),
                          ),
                          hintText: writeAComment,
                          fillColor: Colors.white70,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: tenDp, horizontal: tenDp),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF5F5F5)),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFFF5F5F5))))),
                )
              ],
            ),
          )),
    );
  }

  StreamBuilder buildComments() {
    return StreamBuilder<QuerySnapshot>(
        stream: commentsCR
            .doc(widget.id)
            .collection('Comments')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text(noCommentsAvailable));
          }

          return ListView.builder(
            shrinkWrap: true,
            primary: true,
            addAutomaticKeepAlives: true,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];

              likes = doc['likedUsers'];

              return buildCommentList(doc);
            },
            itemCount: snapshot.data!.docs.length,
          );
        });
  }

  Widget buildCommentList(DocumentSnapshot doc) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: eightDp, right: eightDp),
            child: CircleAvatar(
              radius: 20,
              foregroundImage: CachedNetworkImageProvider(doc['photoUrl']),
              backgroundColor: Colors.indigo,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      //name
                      doc['name'],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: sixteenDp),
                    ),
                    Text(timeAgo.format(doc["timestamp"].toDate()),
                        style: TextStyle(
                            color: Colors.black45, fontSize: fourteenDp)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: fourDp, right: eightDp),
                child: Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Text(
                      //name
                      doc['message'],
                      maxLines: 40,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /*     Padding(
                      padding: EdgeInsets.only(top: eightDp, right: eightDp),
                      child: Text('3',style: TextStyle(color: Colors.black45),),
                    ),
                    Icon(
                      Icons.comment,
                      color: Colors.blueAccent,
                      size: sixteenDp,
                    ),
                    SizedBox(width: twentyDp,),*/

                    GestureDetector(
                      onTap: () {
                        //delete comment
                        _artworkProvider.deleteComment(
                            widget.id!, doc.id, context);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: eightDp, right: eightDp),
                      child: Text(
                        "${likes!.length}",
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //checks if the current user is already part of the liked users
                        if (!doc
                            .get('likedUsers')
                            .toString()
                            .contains(currentUserId!)) {
                          _artworkProvider.updateCommentLikes(
                              widget.id!, doc.id, context);
                        } else {
                          _artworkProvider.removeCommentLikes(
                              widget.id!, doc.id, context);
                        }
                      },
                      child: Icon(
                        Icons.thumb_up,
                        color: !doc
                                .get('likedUsers')
                                .toString()
                                .contains(currentUserId!)
                            ? Colors.grey
                            : Colors.blueAccent,
                        size: twentyDp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: tenDp,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: Divider(
                    thickness: 0.1,
                    color: Colors.black45,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
