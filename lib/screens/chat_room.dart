import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:socgo/globals.dart';

class ChatRoomScreen extends StatefulWidget {
  ChatRoomScreen(this.userData, this.chat);

  var userData;
  var chat;

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState(this.userData, this.chat);
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var userData;
  var chat;

  _ChatRoomScreenState(var uD, var ch) {
    userData = uD;
    chat = ch;
  }

  final TextEditingController chatFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chats").doc(chat["id"]).snapshots(),
        builder: (liveChatContext, liveChatSnapshot) {
          if (liveChatSnapshot.hasData) {
            var liveChat = liveChatSnapshot.data;
            return FutureBuilder(
              future: getParticipantsData(liveChat["participants"]),
              builder: (BuildContext partContext, partSnapshot) {
                if (partSnapshot.hasData) {
                  var participantsData = partSnapshot.data;
                  return Column(children: [
                    Flexible(
                      child: ListView.builder(
                        itemCount: liveChat["messages"].length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            child: chatBubble(
                                direction: liveChat["messages"][index]["from"] != auth.currentUser.uid ? "in" : "out",
                                message: liveChat["messages"][index],
                                partsData: participantsData),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        child: Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  controller: chatFieldController,
                                  onEditingComplete: () => {
                                        sendMessage(chatFieldController.text.trim()),
                                        chatFieldController.clear(),
                                      },
                                  decoration: InputDecoration(
                                    labelText: "Say something",
                                  )),
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () => {
                                sendMessage(chatFieldController.text.trim()),
                                chatFieldController.clear(),
                              },
                            ),
                          ],
                        ),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).cardTheme.color,
                        ),
                      ),
                    ),
                  ]);
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
    );
  }

  sendMessage(String message) async {
    if (message.length > 0) {
      await FirebaseFirestore.instance.collection("chats").doc(chat.id).update({
        "messages": FieldValue.arrayUnion([
          {"at": new DateTime.now(), "from": auth.currentUser.uid, "message": message}
        ])
      });
    }
  }

  Future getParticipantsData(List chatParticipants) async {
    Map chatParticipantData = {};
    await FirebaseFirestore.instance.collection("users").where("id", whereIn: chatParticipants).get().then((participants) => {
          for (var i = 0; i < participants.docs.length; ++i)
            {
              chatParticipantData[participants.docs[i].data()["id"]] = participants.docs[i].data(),
            }
        });
    return chatParticipantData;
  }

  Widget chatBubble({String direction, Map message, Map partsData}) {
    return Row(
      mainAxisAlignment: direction == "out"
          ? MainAxisAlignment.end
          : direction == "in"
              ? MainAxisAlignment.start
              : MainAxisAlignment.start,
      children: [
        direction == "in"
            ? CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(partsData[message["from"]]["pictureUrl"]),
              )
            : Container(),
        direction == "out" ? Text(Moment.fromDate(message["at"].toDate()).format("HH:mm"), style: Theme.of(context).textTheme.caption) : Container(),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(message["message"], style: Theme.of(context).textTheme.subtitle2),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        direction == "out"
            ? CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(partsData[message["from"]]["pictureUrl"]),
              )
            : Container(),
      ],
    );
  }
}
