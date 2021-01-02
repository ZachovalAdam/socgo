import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserButton extends StatefulWidget {
  UserButton({this.userData, this.tripData, this.textStyle, this.avatarSize, this.avatarPadding, this.isTripUser});

  var userData;
  var tripData;
  TextStyle textStyle;
  double avatarSize;
  double avatarPadding;
  bool isTripUser = false;

  @override
  _UserButtonState createState() => _UserButtonState(this.userData, this.tripData, this.textStyle, this.avatarSize, this.avatarPadding, this.isTripUser);
}

class _UserButtonState extends State<UserButton> {
  var userData;
  var tripData;
  TextStyle textStyle;
  double avatarSize;
  double avatarPadding;
  bool isTripUser = false;

  _UserButtonState(var uD, var tD, TextStyle tS, double aS, double aP, bool iTU) {
    userData = uD;
    tripData = tD;
    textStyle = tS;
    avatarSize = aS;
    avatarPadding = aP;
    isTripUser = iTU;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          maxRadius: avatarSize,
          backgroundImage: CachedNetworkImageProvider(userData["pictureUrl"]),
          backgroundColor: Colors.grey,
        ),
        SizedBox(
          width: avatarPadding,
        ),
        Flexible(
          child: Text(userData["firstName"] + " " + userData["lastName"], style: textStyle),
        ),
        userData["admin"] == true
            ? Padding(
                child: Tooltip(
                  message: "Administrator",
                  child: Icon(
                    Icons.verified_user,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ),
                padding: EdgeInsets.only(left: 5),
              )
            : Container(),
        tripData != null
            ? userData["id"] == tripData["host"]
                ? Padding(
                    child: Tooltip(
                      message: "Host",
                      child: Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 18,
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                  )
                : Container()
            : Container(),
      ],
    );
  }
}
