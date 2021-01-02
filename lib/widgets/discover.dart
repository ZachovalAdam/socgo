import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/setup.dart';
import 'package:socgo/services/authentication_service.dart';
import 'package:socgo/widgets/random_sight.dart';
import 'package:socgo/widgets/sights_scroller.dart';
import 'package:socgo/widgets/greeting.dart';
import 'package:socgo/widgets/info_panel.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:socgo/widgets/user_button.dart';

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
                brightness: MediaQuery.of(context).platformBrightness,
                backgroundColor: Theme.of(context).colorScheme.background,
                centerTitle: true,
                elevation: 1,
                leadingWidth: 75,
                leading: GestureDetector(
                  /*onLongPress: () {
                    context.read<AuthenticationService>().signOut();
                  },*/
                  child: IconButton(
                      icon: CircleAvatar(
                        backgroundImage: userData["pictureUrl"] != "null" ? CachedNetworkImageProvider(userData["pictureUrl"]) : null,
                        backgroundColor: Colors.grey,
                        radius: 16.0,
                      ),
                      constraints: BoxConstraints(minWidth: 75),
                      onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(18, 18, 18, 9),
                                  child: isProfileSetup
                                      ? UserButton(
                                          userData: userData,
                                          avatarSize: 20,
                                          avatarPadding: 15,
                                          textStyle: Theme.of(context).textTheme.headline6,
                                        )
                                      : Row(
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 20,
                                              backgroundColor: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Flexible(
                                              child: Text(FirebaseAuth.instance.currentUser.email, style: Theme.of(context).textTheme.headline6),
                                            ),
                                          ],
                                        ),
                                ),
                                Divider(),
                                isProfileSetup
                                    ? ListTile(
                                        leading: Container(
                                          child: Icon(
                                            Icons.people_outlined,
                                            color: Theme.of(context).iconTheme.color,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        title: Text('Friends', style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
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
                                            color: Theme.of(context).iconTheme.color,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        title: Text('Trips', style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
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
                                            color: Theme.of(context).iconTheme.color,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        title: Text('Settings', style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
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
                                            color: Theme.of(context).iconTheme.color,
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        title: Text('Admin Panel', style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
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
                                  title: Text('Sign out', style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
                                  onTap: () {
                                    context.read<AuthenticationService>().signOut();
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
                    icon: Icon(FeatherIcons.messageCircle),
                    onPressed: isProfileSetup
                        ? () {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("This feature is not implemented yet.")));
                          }
                        : null,
                    constraints: BoxConstraints(minWidth: 70),
                    color: Theme.of(context).iconTheme.color,
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
                            child: InkWell(
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: Color(0xFFF8E153), borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(children: [
                                        Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Your profile hasn't been set up yet. You won't have access to any features of the app until it's setup.",
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black)),
                                            TextSpan(
                                                text: " Click here to set up your profile.",
                                                style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black)),
                                          ]),
                                        )
                                      ]),
                                    )),
                                onTap: () {
                                  Route r = MaterialPageRoute(builder: (context) => SetupScreen());
                                  Navigator.push(context, r);
                                }))
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
                                  Text(userData["firstName"], style: Theme.of(context).textTheme.headline3),
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
                            Text('Best in ' + "*UNIMPLEMENTED*", style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ),
                    ),
                    isProfileSetup
                        ? SightsScroller()
                        : Container(
                            width: double.infinity,
                            height: 300,
                            child: ListView.builder(
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(left: index == 0 ? 25 : 17, right: index == 2 - 1 ? 25 : 0),
                                  width: 205,
                                  child: GestureDetector(
                                    onTap: null,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          color: Theme.of(context).cardTheme.color,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 44),
                                            child: Align(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  index == 0
                                                      ? Text(
                                                          "Set up your profile to use this service.",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              alignment: Alignment.bottomLeft,
                                            ),
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
                      child: RandomSight(),
                    ),
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
                            Text('Popular worldwide', style: Theme.of(context).textTheme.headline5),
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
