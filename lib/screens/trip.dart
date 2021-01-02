import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:socgo/globals.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:socgo/widgets/user_button.dart';

class TripScreen extends StatefulWidget {
  TripScreen(this.trip, this.participants, this.sightId);

  var trip;
  var participants;
  var sightId;

  @override
  _TripScreenState createState() => _TripScreenState(trip, participants, sightId);
}

class _TripScreenState extends State<TripScreen> {
  var trip;
  var participants;
  var sightId;

  _TripScreenState(var t, var p, var s) {
    trip = t;
    participants = p;
    sightId = s;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getSightData(sightId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var sight = snapshot.data.documents[0];
          return Scaffold(
              body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 30, 25, 30),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Trip to " + sight["name"],
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 10),
                            Text("This trip is happening on " + Moment.parse(trip["date"].toDate().toString()).format('MMMM d, yyyy') + "."),
                            SizedBox(height: 30),
                            Text(
                              "Participants",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Column(
                                children: [
                                  for (var i = 0; i < (participants.length >= 7 ? 7 : participants.length); i++)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: i != (participants.length >= 7 ? 7 : participants.length) - 1 ? 15 : 0),
                                      child: UserButton(
                                        userData: participants[i],
                                        tripData: trip,
                                        textStyle: Theme.of(context).textTheme.subtitle1,
                                        avatarPadding: 10,
                                        avatarSize: 24,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  participants.length > 10 ? Divider() : Container(),
                                  participants.length > 10
                                      ? FlatButton(
                                          child: Text("Show more"),
                                          onPressed: () {},
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Placeholder",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 10),
                            Container(),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ));
        }
      },
    );
  }
}
