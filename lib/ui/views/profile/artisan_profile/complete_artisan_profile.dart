import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:home_service/ui/models/artisan_type.dart';

import '../../../../constants.dart';

class CompleteArtisanProfile extends StatefulWidget {
  static const routeName = '/completeArtisanProfile';

  const CompleteArtisanProfile({Key? key}) : super(key: key);

  @override
  _CompleteArtisanProfileState createState() => _CompleteArtisanProfileState();
}

class _CompleteArtisanProfileState extends State<CompleteArtisanProfile> {
  String? _selectedArtisan;
  int index = getArtisanType.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
        title: Text(
          completeProfile,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(sixteenDp),
          child: Column(
            children: [
              buildArtisanName(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildArtisanName() {
    return TextFormField(
        autofocus: true,
        maxLength: 20,
        keyboardType: TextInputType.name,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
          hintText: "Enter your name",
          fillColor: Color(0xFFF5F5F5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: tenDp),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5F5F5))),
        ));
  }

  Widget buildArtisanType() {
    return DropdownButton<String>(
      value: _selectedArtisan,
      elevation: 1,
      isExpanded: true,
      style: TextStyle(color: Color(0xFF424242)),
      underline: Container(),
      items: <String>[getArtisanType[index].name]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text(
        "Select Category",
        style: TextStyle(color: Color(0xFF757575), fontSize: 16),
      ),
      onChanged: (String? value) {
        setState(() {
          _selectedArtisan = value;
        });
      },
    );
  }
}
