import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/models/users.dart';
import 'package:home_service/ui/widgets/actions.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class UserProfile extends StatefulWidget {
  final String? userId;

  const UserProfile({Key? key, this.userId}) : super(key: key);
  static const routeName = '/userProfile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Users? _selectedUser;

  @override
  void initState() {
    final users = Provider.of<List<Users>>(context, listen: false);

    _selectedUser =
        users.firstWhere((Users users) => users.id == widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF757575),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(twentyDp),
                  topRight: Radius.circular(twentyDp))),
          child: Column(
            children: [
              SizedBox(height: thirtyDp),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    border: Border.all(width: 0.3, color: Colors.grey),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      //artisan image
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      imageUrl: _selectedUser!.photoUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(_selectedUser!.name!, style: TextStyle(fontSize: 20)),
              SizedBox(height: 15),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: [
                  Text("Joined on ",
                      style: TextStyle(fontSize: 12, color: Colors.black87)),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                    ),
                  ),
                  Text(" ${_selectedUser!.dateJoined!}",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                          fontStyle: FontStyle.italic)),
                  SizedBox(height: twentyFourDp),
                  SizedBox(
                    height: fortyEightDp,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        margin: EdgeInsets.only(
                            left: thirtySixDp,
                            right: thirtySixDp,
                            bottom: fourDp),
                        child: TextButton(
                            // button to open bottom sheet
                            style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(eightDp))),
                            onPressed: () {
                              Navigator.pop(context);
                              ShowAction.makePhoneCall(
                                  "tel:${_selectedUser!.phoneNumber}");
                            },
                            child: Text(
                              call,
                              style: TextStyle(fontSize: fourteenDp),
                            ))),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
