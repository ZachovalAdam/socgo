import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geocoder/geocoder.dart';
import 'package:socgo/screens/sight.dart';

import 'package:socgo/globals.dart';

class RandomSight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getRandomSight(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var sights = snapshot.data.documents;
          QueryDocumentSnapshot randomSight = (sights..shuffle()).first;
          var rating =
              randomSight["reviews"].length > 0 ? randomSight["reviews"].map((r) => r["rating"]).reduce((a, b) => a + b) / randomSight["reviews"].length : "-";
          return FutureBuilder(
            future: getAddress(Coordinates(randomSight["location"].latitude, randomSight["location"].longitude)),
            builder: (locContext, locSnapshot) {
              if (locSnapshot.hasData) {
                return StreamBuilder(
                  stream: getTripsData(randomSight["id"]),
                  builder: (tripContext, tripSnapshot) {
                    if (tripSnapshot.hasData) {
                      Address addr = locSnapshot.data.first;
                      var trips = tripSnapshot.data.documents;
                      int people = 0;
                      trips.forEach((trip) => people = people + trip["participants"].length);
                      return Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: InkWell(
                          onTap: () {
                            Route r = MaterialPageRoute(
                                builder: (context) => SightScreen(
                                      randomSight,
                                      addr,
                                      heroTagName: randomSight.id + "_rand",
                                    ));
                            Navigator.push(context, r);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 100 /* * MediaQuery.of(context).devicePixelRatio*/,
                            child: Row(
                              children: [
                                ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl: randomSight["imageUrl"],
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                randomSight["name"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                ),
                                                textScaleFactor: 1,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.star, color: Colors.orange),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    rating == 0 ? "-" : rating.toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                    textScaleFactor: 1,
                                                  )
                                                ],
                                              )
                                            ],
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
                                                  color: Theme.of(context).textTheme.headline1.color.withOpacity(.75),
                                                ),
                                              ),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    FittedBox(
                                                      child: Text(
                                                        addr.locality + ", " + addr.countryName,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          color: Theme.of(context).textTheme.headline1.color.withOpacity(.75),
                                                        ),
                                                        textScaleFactor: 1,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                FeatherIcons.flag,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                trips.length.toString() + " trips",
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                                textScaleFactor: 1,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                FeatherIcons.users,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                people.toString() + " people",
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                                textScaleFactor: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              } else {
                return Container(
                  height: 100,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              ;
            },
          );
        } else {
          return Container(
            height: 100,
            width: double.infinity,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
