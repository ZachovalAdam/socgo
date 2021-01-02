import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:socgo/globals.dart';

class InfoPanel extends StatelessWidget {
  static List info = [
    {"photoUrl": "https://latravelgirl.com/wp-content/uploads/2019/02/DSC_2436.jpg", "headline": "Norway", "subtitle": "Spend your winter in Northern Norway"},
    {
      "photoUrl":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/KeizersgrachtReguliersgrachtAmsterdam.jpg/1280px-KeizersgrachtReguliersgrachtAmsterdam.jpg",
      "headline": "Amsterdam",
      "subtitle": "Planning your summer out? Try Amsterdam!"
    },
    {
      "photoUrl": "https://cdn.theculturetrip.com/wp-content/uploads/2018/10/prague-1845560_1920.jpg",
      "headline": "Prague",
      "subtitle": "The heart of Europe -- home of many wonderful sights"
    },
    {
      "photoUrl": "https://cdn-image.departures.com/sites/default/files/1576002985/header-tokyo-japan-LUXETOKYO1219.jpg",
      "headline": "Tokyo",
      "subtitle": "Like Cyberpunk? We're sure you'll LOVE Tokyo."
    },
  ];

  Map randomInfo = (info..shuffle()).first;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CachedNetworkImage(
              imageUrl: randomInfo['photoUrl'],
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                height: 20,
                width: 20,
              ),
              errorWidget: (context, url, error) => Icon(FeatherIcons.alertCircle),
            ),
          ),
        ),
        Container(
          height: 170,
          width: double.infinity,
          color: Color(0x44000000),
        ),
        Container(
          height: 170,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Text(
                  randomInfo['headline'],
                  style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.w700, color: Color(0xDDFFFFFF)),
                )),
                SizedBox(
                  height: 4,
                ),
                Flexible(
                  child: Text(randomInfo['subtitle'],
                      style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w500, color: Color(0xDDFFFFFF))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
