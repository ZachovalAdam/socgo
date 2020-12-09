import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/services/authentication_service.dart';
import 'package:socgo/widgets/sights_scroller.dart';
import 'package:socgo/widgets/greeting.dart';
import 'package:socgo/widgets/info_panel.dart';

class Discover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          var userData = snapshot.data;
          bool isProfileSetup = userData["setup"];
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                centerTitle: true,
                elevation: 1,
                leadingWidth: 75,
                leading: GestureDetector(
                  onLongPress: () {
                    context.read<AuthenticationService>().signOut();
                  },
                  child: IconButton(
                      icon: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: userData["pictureUrl"] != "null"
                              ? NetworkImage(userData["pictureUrl"])
                              : null,
                          radius: 16.0),
                      constraints: BoxConstraints(minWidth: 75),
                      onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(18, 18, 18, 9),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            userData["pictureUrl"] != "null"
                                                ? NetworkImage(
                                                    userData["pictureUrl"])
                                                : null,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Flexible(
                                        child: isProfileSetup
                                            ? Text(
                                                userData["firstName"] +
                                                    " " +
                                                    userData["lastName"],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6)
                                            : Text(
                                                FirebaseAuth
                                                    .instance.currentUser.email,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                      ),
                                      userData["admin"] == true
                                          ? SizedBox(
                                              width: 5,
                                            )
                                          : Container(),
                                      userData["admin"] == true
                                          ? Tooltip(
                                              message: "Administrator",
                                              child: Icon(
                                                Icons.verified_user,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                size: 18,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Divider(),
                                isProfileSetup
                                    ? ListTile(
                                        leading: Container(
                                          child: Icon(
                                            Icons.people_outlined,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        title: Text('Friends',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color)),
                                        onTap: () {
                                          print('friends');
                                        },
                                      )
                                    : Container(),
                                isProfileSetup
                                    ? ListTile(
                                        leading: Container(
                                          child: Icon(
                                            Icons.tour_outlined,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        title: Text('Trips',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color)),
                                        onTap: () {
                                          print('trips');
                                        },
                                      )
                                    : Container(),
                                isProfileSetup
                                    ? ListTile(
                                        leading: Container(
                                          child: Icon(
                                            Icons.settings_outlined,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        title: Text('Settings',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color)),
                                        onTap: () {
                                          print('settings');
                                        },
                                      )
                                    : Container(),
                                userData["admin"] == true
                                    ? ListTile(
                                        leading: Container(
                                          child: Icon(
                                            Icons.admin_panel_settings_outlined,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        title: Text('Admin Panel',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color)),
                                        onTap: () {
                                          print('admin panel');
                                        },
                                      )
                                    : Container(),
                                ListTile(
                                  leading: Container(
                                    child: Icon(
                                      Icons.logout,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  title: Text('Sign out',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .color)),
                                  onTap: () {
                                    context
                                        .read<AuthenticationService>()
                                        .signOut();
                                    Navigator.pop(context, true);
                                    print('sign out');
                                  },
                                ),
                              ],
                            );
                          })),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.chat_bubble_outline),
                    onPressed: isProfileSetup ? () {} : null,
                    constraints: BoxConstraints(minWidth: 70),
                    color: Colors.black,
                  )
                ],
                snap: true,
                floating: true,
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !isProfileSetup
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(25, 30, 25, 15),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xFFF8E153),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(children: [
                                    Icon(Icons.warning_amber_outlined),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                "Your profile hasn't been set up yet. You won't have access to any features of the app until it's setup.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2),
                                        TextSpan(
                                            text:
                                                " Click here to set up your profile.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ]),
                                    )
                                  ]),
                                )))
                        : Container(),
                    isProfileSetup
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Greeting(),
                                  Text(userData["firstName"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Text('Best in -',
                                style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ),
                    ),
                    isProfileSetup
                        ? SightsScroller()
                        : Container(
                            width: double.infinity,
                            height: 230,
                            child: ListView.builder(
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: index == 0 ? 25 : 0, right: 25),
                                  width: 205,
                                  child: GestureDetector(
                                    onTap: null,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          color: Color(0xFFF5F5F5),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 185,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 185,
                                                      width: double.infinity,
                                                      child: Hero(
                                                        tag: 'notsetup',
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: Container(
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      child: Align(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(),
                                                            Container(),
                                                          ],
                                                        ),
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 7),
                                                margin:
                                                    EdgeInsets.only(top: 185),
                                                height: 45,
                                                child: Align(
                                                  child: index == 0
                                                      ? Text(
                                                          "Set up your profile to continue.",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFF606060)))
                                                      : Container(),
                                                  alignment: Alignment.topLeft,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                );
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                          ), // Sights ListView gen
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 30, 25, 25),
                      child: InfoPanel(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Popular worldwide',
                                style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getCurrentUserData(),
    );
  }
}
