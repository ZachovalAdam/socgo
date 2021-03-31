import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/sight.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SightsScroller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPos = Provider.of<Position>(context);

    return StreamBuilder(
        stream: getNearSightsData(currentPos),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sights = snapshot.data.documents;
            return Container(
              width: double.infinity,
              height: 300,
              child: ListView.builder(
                itemCount: sights.length,
                itemBuilder: (context, index) {
                  var sight = sights[index];
                  return FutureBuilder(
                      future: getAddress(Coordinates(sight["location"].latitude, sight["location"].longitude)),
                      builder: (locContext, locSnapshot) {
                        if (locSnapshot.hasData) {
                          Address addr = locSnapshot.data.first;
                          return Container(
                            margin: EdgeInsets.only(left: index == 0 ? 25 : 17, right: index == sights.length - 1 ? 25 : 0),
                            width: 205,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Route r = MaterialPageRoute(
                                    builder: (context) => SightScreen(
                                          sight,
                                          heroTagName: sight["id"],
                                        ));
                                Navigator.push(context, r);
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    color: Theme.of(context).cardTheme.color,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 300,
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 300,
                                                width: double.infinity,
                                                child: Hero(
                                                  tag: sight["id"],
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: CachedNetworkImage(
                                                        imageUrl: sight["imageUrl"],
                                                        fit: BoxFit.cover,
                                                        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                          child: Center(
                                                            child: CircularProgressIndicator(),
                                                          ),
                                                          height: 20,
                                                          width: 20,
                                                        ),
                                                        errorWidget: (context, url, error) => Icon(FeatherIcons.alertCircle),
                                                      )),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 120,
                                                    child: ShaderMask(
                                                      shaderCallback: (rect) {
                                                        return LinearGradient(
                                                          begin: Alignment.bottomCenter,
                                                          end: Alignment.topCenter,
                                                          colors: [Color(0x77000000), Colors.transparent],
                                                        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                                                      },
                                                      blendMode: BlendMode.dstIn,
                                                      child: Container(
                                                        height: 120,
                                                        decoration: BoxDecoration(color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                                                child: Align(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        sight["name"],
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                        ),
                                                        maxLines: 8,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 0, right: 3, bottom: 0),
                                                            child: Icon(
                                                              Icons.place,
                                                              size: 13,
                                                              color: Color(0xBBFFFFFF),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(addr.locality + ", " + addr.countryName,
                                                                    //"Placeholder location",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 14,
                                                                      color: Color(0xBBFFFFFF),
                                                                    ),
                                                                    textScaleFactor: 1,
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis)
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  alignment: Alignment.bottomLeft,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(left: index == 0 ? 25 : 17, right: index == sights.length - 1 ? 25 : 0),
                            width: 205,
                            height: 300,
                          );
                        }
                      });
                },
                scrollDirection: Axis.horizontal,
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              width: 205,
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
