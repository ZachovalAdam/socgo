import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:socgo/globals.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:socgo/screens/trip.dart';

class TripsList extends StatelessWidget {
  final sight;

  TripsList(this.sight);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getTripsData(sight),
      builder: (tripContext, tripSnapshot) {
        if (tripSnapshot.hasData) {
          var trips = tripSnapshot.data.documents;
          return Container(
            height: 230,
            width: double.infinity,
            color: Theme.of(context).cardTheme.color,
            child: trips.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      var trip = trips[index];
                      return Material(
                        type: MaterialType.transparency,
                        child: StreamBuilder(
                          stream: getTripParticipantsData(trip["participants"]),
                          builder: (participantContext, participantSnapshot) {
                            if (participantSnapshot.hasData) {
                              var participants = participantSnapshot.data.documents;
                              return ListTile(
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
                                    Expanded(child: Container()),
                                    Text(
                                      Moment.now().from(trip["date"].toDate()),
                                    ),
                                    SizedBox(width: 10),
                                    trip["open"] ? Icon(FeatherIcons.checkCircle) : Icon(FeatherIcons.xCircle),
                                  ],
                                ),
                                onTap: () {
                                  Route r = MaterialPageRoute(builder: (context) => TripScreen(trip, participants, sight));
                                  Navigator.push(context, r);
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FeatherIcons.frown,
                          color: Theme.of(context).textTheme.caption.color,
                          size: 60,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "No trips here",
                          style: TextStyle(color: Theme.of(context).textTheme.caption.color, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Be the first one!",
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
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
