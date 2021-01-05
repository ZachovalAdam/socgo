import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/trip.dart';

class RequestsMenuScreen extends StatefulWidget {
  RequestsMenuScreen(this.userData);

  var userData;

  @override
  _RequestsMenuScreenState createState() => _RequestsMenuScreenState(this.userData);
}

class _RequestsMenuScreenState extends State<RequestsMenuScreen> {
  var userData;

  _RequestsMenuScreenState(var uD) {
    userData = uD;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getPersonalRequests(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var requests = snapshot.data.documents;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: true,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 30, 25, 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your requests",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      if (requests.length != 0)
                        for (var index = 0; index < requests.length; index++)
                          requests[index]["type"] == "friend"
                              ? StreamBuilder(
                                  stream: getUserData(requests[index]["from"]),
                                  builder: (frContext, frSnapshot) {
                                    if (frSnapshot.hasData) {
                                      var user = frSnapshot.data.documents[0];
                                      return Material(
                                        type: MaterialType.transparency,
                                        child: ListTile(
                                          title: Padding(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Friend request",
                                                    style:
                                                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Theme.of(context).textTheme.caption.color)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(user["firstName"] + " " + user["lastName"] + " would like to become your friend."),
                                              ],
                                            ),
                                            padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  FeatherIcons.x,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () {
                                                  denyFriendRequest(requests[index].id);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(FeatherIcons.check, color: Colors.greenAccent),
                                                onPressed: () {
                                                  acceptFriendRequest(requests[index]);
                                                },
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            // open profile
                                          },
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              : StreamBuilder(
                                  stream: getTripData(requests[index]["tripId"]),
                                  builder: (trContext, trSnapshot) {
                                    if (trSnapshot.hasData) {
                                      var trip = trSnapshot.data;
                                      return StreamBuilder(
                                        stream: getUserData(requests[index]["from"]),
                                        builder: (trReqContext, trReqSnapshot) {
                                          if (trReqSnapshot.hasData) {
                                            var user = trReqSnapshot.data.documents[0];
                                            return StreamBuilder(
                                              stream: getSightData(trip["sight"]),
                                              builder: (sContext, sSnapshot) {
                                                if (sSnapshot.hasData) {
                                                  var sight = sSnapshot.data.documents[0];
                                                  return StreamBuilder(
                                                    stream: getTripParticipantsData(trip["participants"]),
                                                    builder: (trPartContext, trPartSnapshot) {
                                                      if (trPartSnapshot.hasData) {
                                                        var participants = trPartSnapshot.data.documents;
                                                        return Material(
                                                          type: MaterialType.transparency,
                                                          child: ListTile(
                                                            title: Padding(
                                                              padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Trip request",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 12,
                                                                          color: Theme.of(context).textTheme.caption.color)),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(user["firstName"] +
                                                                      " " +
                                                                      user["lastName"] +
                                                                      " would like to join your trip to " +
                                                                      sight["name"] +
                                                                      "."),
                                                                ],
                                                              ),
                                                            ),
                                                            trailing: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(
                                                                    FeatherIcons.x,
                                                                    color: Colors.redAccent,
                                                                  ),
                                                                  onPressed: () {
                                                                    deleteRequest(requests[index].id);
                                                                  },
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(FeatherIcons.check, color: Colors.greenAccent),
                                                                  onPressed: () {
                                                                    approveRequest(requests[index]);
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Route r = MaterialPageRoute(builder: (context) => TripScreen(trip, participants, sight.id));
                                                              Navigator.push(context, r);
                                                            },
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
                                )
                      else
                        Container(child: Text("You have no requests.")),
                    ],
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
