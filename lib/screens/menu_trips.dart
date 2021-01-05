import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/trip.dart';

class TripsMenuScreen extends StatefulWidget {
  TripsMenuScreen(this.userData);

  var userData;

  @override
  _TripsMenuScreenState createState() => _TripsMenuScreenState(this.userData);
}

class _TripsMenuScreenState extends State<TripsMenuScreen> {
  var userData;

  _TripsMenuScreenState(var uD) {
    userData = uD;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getUsersTrips(userData["id"]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var trips = snapshot.data.documents;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 30, 25, 30),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trips you're going to",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(height: 10),
                          if (trips.length != 0)
                            for (var index = 0; index < trips.length; index++)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: StreamBuilder(
                                    stream: getSightFromTrip(trips[index]),
                                    builder: (sightContext, sightSnapshot) {
                                      if (sightSnapshot.hasData) {
                                        var sight = sightSnapshot.data.documents.first;
                                        return StreamBuilder(
                                          stream: getTripParticipantsData(trips[index]["participants"]),
                                          builder: (participantContext, participantSnapshot) {
                                            if (participantSnapshot.hasData) {
                                              var participants = participantSnapshot.data.documents;
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: 20),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: Theme(
                                                    data: Theme.of(context).copyWith(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Route r = MaterialPageRoute(builder: (context) => TripScreen(trips[index], participants, sight["id"]));
                                                        Navigator.push(context, r);
                                                      },
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: sight["imageUrl"],
                                                              fit: BoxFit.cover,
                                                              height: 175,
                                                              width: double.infinity,
                                                              progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                                child: Center(
                                                                  child: CircularProgressIndicator(),
                                                                ),
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              errorWidget: (context, url, error) => Icon(FeatherIcons.alertCircle),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.fromLTRB(18, 15, 18, 5),
                                                              child: Text(sight["name"], style: Theme.of(context).textTheme.headline6),
                                                            ),
                                                            ListTile(
                                                              title: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      for (var i = 0; i < participants.length; i++)
                                                                        if (i < 5)
                                                                          Container(
                                                                            padding: EdgeInsets.fromLTRB(i.toDouble() * 23, 0, 0, 0),
                                                                            child: CircleAvatar(
                                                                              maxRadius: 18,
                                                                              backgroundColor: Theme.of(context).cardTheme.color,
                                                                              child: CircleAvatar(
                                                                                maxRadius: 16,
                                                                                backgroundImage: CachedNetworkImageProvider(participants[i]["pictureUrl"]),
                                                                                backgroundColor: Colors.grey,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        color: Theme.of(context).cardTheme.color,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
