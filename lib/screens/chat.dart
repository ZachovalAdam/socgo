import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/chat_room.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.userData);

  var userData;

  @override
  _ChatScreenState createState() => _ChatScreenState(this.userData);
}

class _ChatScreenState extends State<ChatScreen> {
  var userData;

  _ChatScreenState(var uD) {
    userData = uD;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chats").where("participants", arrayContains: userData["id"]).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            var chats = snapshot.data.documents;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext chatContext, index) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection("trips").doc(chats[index]["trip"]).get(),
                  builder: (BuildContext sightContext, tripSnapshot) {
                    if (tripSnapshot.hasData) {
                      var trip = tripSnapshot.data;
                      return FutureBuilder(
                          future: FirebaseFirestore.instance.collection("sights").doc(trip["sight"]).get(),
                          builder: (BuildContext sightContext, sightSnapshot) {
                            if (sightSnapshot.hasData) {
                              var sight = sightSnapshot.data;
                              return InkWell(
                                onTap: () {
                                  Route r = MaterialPageRoute(builder: (context) => ChatRoomScreen(userData, chats[index]));
                                  Navigator.push(context, r);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                  ),
                                  title: Text(
                                    "Trip to " + sight["name"] + " with " + (chats[index]["participants"].length - 1).toString() + " other people",
                                  ),
                                  subtitle: Text(chats[index]["messages"].length > 0 ? chats[index]["messages"].last["message"] : "No prior messages"),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Text("Loading");
                    }
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
