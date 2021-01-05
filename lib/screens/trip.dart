import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    bool isHost = trip["host"] == FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder(
      stream: getSightData(sightId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var sight = snapshot.data.documents[0];
          return StreamBuilder(
            stream: getUserData(FirebaseAuth.instance.currentUser.uid),
            builder: (userDataContext, userDataSnapshot) {
              if (userDataSnapshot.hasData) {
                var user = userDataSnapshot.data.documents[0];
                bool isAdmin = user["admin"];
                return StreamBuilder(
                    stream: getTripJoinRequests(trip.id),
                    builder: (tripReqContext, tripReqSnapshot) {
                      if (tripReqSnapshot.hasData) {
                        var tripRequests = tripReqSnapshot.data.documents;
                        return StreamBuilder(
                            stream: getUserTripRequest(user["id"], trip["host"], trip.id),
                            builder: (tripUserReqContext, tripUserReqSnapshot) {
                              if (tripUserReqSnapshot.hasData) {
                                var joinReq = tripUserReqSnapshot.data.documents.length != 0 ? tripUserReqSnapshot.data.documents[0] : null;
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
                                              padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Trip to " + sight["name"],
                                                      style: Theme.of(context).textTheme.headline5,
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text("This trip is happening on " +
                                                        Moment.parse(trip["date"].toDate().toString()).format('MMMM d, yyyy') +
                                                        "."),
                                                    SizedBox(height: 30),
                                                    Text(
                                                      "Description from host",
                                                      style: Theme.of(context).textTheme.headline6,
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(trip["description"]),
                                                    SizedBox(height: 30),
                                                    Text(
                                                      "Participants (max. " + trip["participantLimit"].toString() + ")",
                                                      style: Theme.of(context).textTheme.headline6,
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          for (var i = 0; i < (participants.length >= 7 ? 7 : participants.length); i++)
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  bottom: i != (participants.length >= 7 ? 7 : participants.length) - 1 ? 15 : 0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  UserButton(
                                                                    userData: participants[i],
                                                                    tripData: trip,
                                                                    textStyle: Theme.of(context).textTheme.subtitle1,
                                                                    avatarPadding: 10,
                                                                    avatarSize: 24,
                                                                  ),
                                                                  isHost || isAdmin
                                                                      ? participants[i].id != trip["host"] && participants[i].id != user.id
                                                                          ? IconButton(
                                                                              icon: Icon(FeatherIcons.x),
                                                                              onPressed: () {
                                                                                BuildContext tripContext = context;
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (_) => AlertDialog(
                                                                                          title: Text("Remove participant"),
                                                                                          content: Text("By doing this, you will remove " +
                                                                                              participants[i]["firstName"] +
                                                                                              " " +
                                                                                              participants[i]["lastName"] +
                                                                                              " from the trip."),
                                                                                          actions: [
                                                                                            FlatButton(
                                                                                              child: Text("No"),
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context, true);
                                                                                              },
                                                                                            ),
                                                                                            FlatButton(
                                                                                              child: Text("Yes"),
                                                                                              onPressed: () {
                                                                                                deleteTripParticipant(trip.id, participants[i].id);
                                                                                                Navigator.pop(context, true);
                                                                                                Navigator.pop(tripContext, true);
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ));
                                                                              },
                                                                            )
                                                                          : Container()
                                                                      : Container(),
                                                                ],
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
                                                          tripRequests.length > 0
                                                              ? Text(
                                                                  tripRequests.length.toString() + " pending join requests.",
                                                                  style: Theme.of(context).textTheme.caption,
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 30),
                                                    isAdmin || isHost
                                                        ? isAdmin
                                                            ? Text(
                                                                "Options (admin actions)",
                                                                style: Theme.of(context).textTheme.headline6,
                                                              )
                                                            : Text(
                                                                "Options",
                                                                style: Theme.of(context).textTheme.headline6,
                                                              )
                                                        : trip["participants"].contains(user.id)
                                                            ? Text(
                                                                "Options",
                                                                style: Theme.of(context).textTheme.headline6,
                                                              )
                                                            : Container(),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                children: [
                                                  isHost || isAdmin
                                                      ? Column(
                                                          children: [
                                                            Material(
                                                              type: MaterialType.transparency,
                                                              child: ListTile(
                                                                leading: Container(
                                                                  padding: EdgeInsets.only(left: 10),
                                                                  child: Icon(
                                                                    FeatherIcons.edit,
                                                                    color: Theme.of(context).textTheme.headline1.color,
                                                                  ),
                                                                ),
                                                                title: Text(
                                                                  "Edit trip",
                                                                ),
                                                                onTap: () {},
                                                              ),
                                                            ),
                                                            if (!isHost)
                                                              if (!participants.map((p) => p.id).toList().contains(user["id"]))
                                                                isAdmin
                                                                    ? joinReq == null
                                                                        ? Material(
                                                                            type: MaterialType.transparency,
                                                                            child: ListTile(
                                                                              leading: Container(
                                                                                padding: EdgeInsets.only(left: 10),
                                                                                child: Icon(
                                                                                  FeatherIcons.userPlus,
                                                                                  color: Theme.of(context).textTheme.headline1.color,
                                                                                ),
                                                                              ),
                                                                              title: Text(
                                                                                "Join trip",
                                                                              ),
                                                                              onTap: () {
                                                                                BuildContext tripContext = context;
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (_) => AlertDialog(
                                                                                          title: Text("Force-join trip"),
                                                                                          content: Text('''You\'re force-joining the trip.
                                                                          Do you want to continue?'''),
                                                                                          actions: [
                                                                                            FlatButton(
                                                                                              child: Text("No"),
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context, true);
                                                                                              },
                                                                                            ),
                                                                                            FlatButton(
                                                                                              child: Text("Yes"),
                                                                                              onPressed: () {
                                                                                                forceJoinTrip(trip.id);
                                                                                                Navigator.pop(context, true);
                                                                                                Navigator.pop(tripContext, true);
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ));
                                                                              },
                                                                            ),
                                                                          )
                                                                        : Container()
                                                                    : Container()
                                                              else
                                                                isAdmin
                                                                    ? Material(
                                                                        type: MaterialType.transparency,
                                                                        child: ListTile(
                                                                          leading: Container(
                                                                            padding: EdgeInsets.only(left: 10),
                                                                            child: Icon(
                                                                              FeatherIcons.userMinus,
                                                                              color: Theme.of(context).textTheme.headline1.color,
                                                                            ),
                                                                          ),
                                                                          title: Text(
                                                                            "Leave trip",
                                                                          ),
                                                                          onTap: () {
                                                                            BuildContext tripContext = context;
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (_) => AlertDialog(
                                                                                      title: Text("Leave trip"),
                                                                                      content: Text('''You\'re leaving the trip.
                                                                          Do you want to continue?'''),
                                                                                      actions: [
                                                                                        FlatButton(
                                                                                          child: Text("No"),
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context, true);
                                                                                          },
                                                                                        ),
                                                                                        FlatButton(
                                                                                          child: Text("Yes"),
                                                                                          onPressed: () {
                                                                                            deleteTripParticipant(trip.id, user.id);
                                                                                            Navigator.pop(context, true);
                                                                                            Navigator.pop(tripContext, true);
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ));
                                                                          },
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                            Material(
                                                              type: MaterialType.transparency,
                                                              child: ListTile(
                                                                leading: Container(
                                                                  padding: EdgeInsets.only(left: 10),
                                                                  child: Icon(
                                                                    FeatherIcons.trash2,
                                                                    color: Colors.redAccent,
                                                                  ),
                                                                ),
                                                                title: Text(
                                                                  "Delete trip",
                                                                  style: TextStyle(color: Colors.redAccent),
                                                                ),
                                                                onTap: () {
                                                                  BuildContext tripContext = context;
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (_) => AlertDialog(
                                                                            title: Text("Delete trip"),
                                                                            content: Text('''Are you sure you want to delete the trip?
                                                                          This action is irreversible.'''),
                                                                            actions: [
                                                                              FlatButton(
                                                                                child: Text("No"),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context, true);
                                                                                },
                                                                              ),
                                                                              FlatButton(
                                                                                child: Text(
                                                                                  "Yes",
                                                                                  style: TextStyle(color: Colors.redAccent),
                                                                                ),
                                                                                onPressed: () {
                                                                                  deleteTrip(trip.id);
                                                                                  Navigator.pop(context, true);
                                                                                  Navigator.pop(tripContext, true);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ));
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : trip["participants"].contains(user.id)
                                                          ? Column(children: [
                                                              Material(
                                                                type: MaterialType.transparency,
                                                                child: ListTile(
                                                                  leading: Container(
                                                                    padding: EdgeInsets.only(left: 10),
                                                                    child: Icon(
                                                                      FeatherIcons.userMinus,
                                                                      color: Theme.of(context).textTheme.headline1.color,
                                                                    ),
                                                                  ),
                                                                  title: Text(
                                                                    "Leave trip",
                                                                  ),
                                                                  onTap: () {
                                                                    BuildContext tripContext = context;
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (_) => AlertDialog(
                                                                              title: Text("Leave trip"),
                                                                              content: Text('''You\'re leaving the trip.
                                                                          Do you want to continue?'''),
                                                                              actions: [
                                                                                FlatButton(
                                                                                  child: Text("No"),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context, true);
                                                                                  },
                                                                                ),
                                                                                FlatButton(
                                                                                  child: Text("Yes"),
                                                                                  onPressed: () {
                                                                                    deleteTripParticipant(trip.id, user.id);
                                                                                    Navigator.pop(context, true);
                                                                                    Navigator.pop(tripContext, true);
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ));
                                                                  },
                                                                ),
                                                              )
                                                            ])
                                                          : Container(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  floatingActionButton: trip["open"] && !trip["participants"].contains(FirebaseAuth.instance.currentUser.uid)
                                      ? Builder(builder: (BuildContext context) {
                                          return joinReq != null
                                              ? FloatingActionButton.extended(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) => AlertDialog(
                                                              title: Text("Cancel join request"),
                                                              content: Text('''Are you sure you want to cancel your join request?'''),
                                                              actions: [
                                                                FlatButton(
                                                                  child: Text("No"),
                                                                  onPressed: () {
                                                                    Navigator.pop(context, true);
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text(
                                                                    "Yes",
                                                                    style: TextStyle(color: Colors.redAccent),
                                                                  ),
                                                                  onPressed: () async {
                                                                    await deleteRequest(joinReq.id);
                                                                    Navigator.pop(context, true);
                                                                  },
                                                                ),
                                                              ],
                                                            ));
                                                  },
                                                  label: Container(
                                                    width: MediaQuery.of(context).size.width - 88,
                                                    child: Text(
                                                      "Cancel join request",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                  elevation: 0,
                                                  backgroundColor: Colors.redAccent,
                                                  foregroundColor: Colors.white,
                                                )
                                              : trip["participants"].length + tripRequests.length >= trip["participantLimit"]
                                                  ? Container(
                                                      height: 30,
                                                      child: Text(
                                                        "This trip has reached it's participant limit.",
                                                        style: Theme.of(context).textTheme.caption,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  : FloatingActionButton.extended(
                                                      onPressed: () async {
                                                        await createTripRequest(trip["host"], trip.id);
                                                      },
                                                      label: Container(
                                                        width: MediaQuery.of(context).size.width - 88,
                                                        child: Text(
                                                          "Request invite",
                                                          textAlign: TextAlign.center,
                                                          style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                                        ),
                                                      ),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                      elevation: 0,
                                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                                      foregroundColor: Colors.white,
                                                    );
                                        })
                                      : !trip["open"]
                                          ? joinReq != null
                                              ? FloatingActionButton.extended(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) => AlertDialog(
                                                              title: Text("Cancel join request"),
                                                              content: Text('''Are you sure you want to cancel your join request?'''),
                                                              actions: [
                                                                FlatButton(
                                                                  child: Text("No"),
                                                                  onPressed: () {
                                                                    Navigator.pop(context, true);
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text(
                                                                    "Yes",
                                                                    style: TextStyle(color: Colors.redAccent),
                                                                  ),
                                                                  onPressed: () async {
                                                                    await deleteRequest(joinReq.id);
                                                                    Navigator.pop(context, true);
                                                                  },
                                                                ),
                                                              ],
                                                            ));
                                                  },
                                                  label: Container(
                                                    width: MediaQuery.of(context).size.width - 88,
                                                    child: Text(
                                                      "Cancel join request",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                  elevation: 0,
                                                  backgroundColor: Colors.redAccent,
                                                  foregroundColor: Colors.white,
                                                )
                                              : Container(
                                                  height: 30,
                                                  child: Text(
                                                    "This trip is not accepting any more participants.",
                                                    style: Theme.of(context).textTheme.caption,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                          : null,
                                  floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
                                );
                              } else {
                                return Container();
                              }
                            });
                      } else {
                        return Container();
                      }
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
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
