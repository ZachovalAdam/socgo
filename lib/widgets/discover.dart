import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/chat.dart';
import 'package:socgo/screens/menu_settings.dart';
import 'package:socgo/screens/setup.dart';
import 'package:socgo/services/authentication_service.dart';
import 'package:socgo/widgets/random_sight.dart';
import 'package:socgo/widgets/sights_scroller.dart';
import 'package:socgo/widgets/greeting.dart';
import 'package:socgo/widgets/info_panel.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:socgo/widgets/user_button.dart';
import 'package:socgo/screens/menu_trips.dart';
import 'package:socgo/screens/menu_requests.dart';

class Discover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPos = Provider.of<Position>(context);

    return (currentPos != null)
        ? FutureBuilder(
            future: getCurrentUserData(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                var userData = snapshot.data;
                bool isProfileSetup = userData["setup"];
                return FutureBuilder(
                    future: getAddress(Coordinates(currentPos.latitude, currentPos.longitude)),
                    builder: (BuildContext locContext, locSnapshot) {
                      if (locSnapshot.hasData) {
                        // Address currentAddr = locSnapshot.data.first;
                        return StreamBuilder(
                            stream: getPersonalRequests(),
                            builder: (BuildContext reqContext, reqSnapshot) {
                              if (reqSnapshot.hasData) {
                                var requests = reqSnapshot.data.documents;
                                return CustomScrollView(
                                  slivers: [
                                    SliverAppBar(
                                      brightness: MediaQuery.of(context).platformBrightness,
                                      backgroundColor: Theme.of(context).colorScheme.background,
                                      centerTitle: true,
                                      elevation: 1,
                                      leadingWidth: 75,
                                      leading: IconButton(
                                          icon: Stack(
                                            children: [
                                              Align(
                                                child: CircleAvatar(
                                                  backgroundImage: userData["pictureUrl"] != "null" ? CachedNetworkImageProvider(userData["pictureUrl"]) : null,
                                                  backgroundColor: Colors.grey,
                                                  radius: 16.0,
                                                ),
                                                alignment: Alignment.center,
                                              ),
                                              requests.length > 0
                                                  ? Stack(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment(0.55, 0.9),
                                                          child: CircleAvatar(
                                                            backgroundColor: Theme.of(context).colorScheme.background,
                                                            radius: 7.0,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment(0.5, 0.8),
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.red,
                                                            radius: 5.0,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
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
                                                                  child: Text(FirebaseAuth.instance.currentUser.email,
                                                                      style: Theme.of(context).textTheme.headline6),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                    Divider(),
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
                                                              Navigator.pop(context, true);
                                                              Route r = MaterialPageRoute(
                                                                  builder: (context) => TripsMenuScreen(
                                                                        userData,
                                                                      ));
                                                              Navigator.push(context, r);
                                                            },
                                                          )
                                                        : Container(),
                                                    isProfileSetup
                                                        ? ListTile(
                                                            leading: Container(
                                                              child: Icon(
                                                                Icons.live_help_outlined,
                                                                color: Theme.of(context).iconTheme.color,
                                                              ),
                                                              padding: EdgeInsets.only(left: 10),
                                                            ),
                                                            title: Row(
                                                              children: [
                                                                Text('Requests', style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
                                                                SizedBox(width: 5),
                                                                requests.length > 0
                                                                    ? CircleAvatar(
                                                                        backgroundColor: Colors.red,
                                                                        radius: 6.0,
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Navigator.pop(context, true);
                                                              Route r = MaterialPageRoute(builder: (context) => RequestsMenuScreen(userData));
                                                              Navigator.push(context, r);
                                                            },
                                                          )
                                                        : Container(),
                                                    ListTile(
                                                      leading: Container(
                                                        child: Icon(
                                                          Icons.settings_outlined,
                                                          color: Theme.of(context).iconTheme.color,
                                                        ),
                                                        padding: EdgeInsets.only(left: 10),
                                                      ),
                                                      title: Text('Settings', style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
                                                      onTap: () {
                                                        Navigator.pop(context, true);
                                                        Route r = MaterialPageRoute(
                                                            builder: (context) => SettingsMenuScreen(
                                                                  userData,
                                                                ));
                                                        Navigator.push(context, r);
                                                      },
                                                    ),
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
                                      actions: [
                                        IconButton(
                                          icon: Icon(FeatherIcons.messageCircle),
                                          onPressed: isProfileSetup
                                              ? () {
                                                  Route r = MaterialPageRoute(
                                                      builder: (context) => ChatScreen(
                                                            userData,
                                                          ));
                                                  Navigator.push(context, r);
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
                                      child: !isProfileSetup
                                          ? DiscoverNotSetup()
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
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
                                                ),
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
                                                        Text('Sights near you', style: Theme.of(context).textTheme.headline5),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SightsScroller(), // Sights ListView gen
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
                                                        Text('Most rated worldwide', style: Theme.of(context).textTheme.headline5),
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
                            });
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(FeatherIcons.compass, size: 40),
                            SizedBox(height: 15),
                            Text(
                              "We're searching for your location.",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "If this is taking too long, it's likely that the application won't function correctly in your area.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        );
                      }
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Padding(
                  child: Text(
                    "You might need to allow location permissions for this app.",
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(25)),
            ],
          );
  }
}

class DiscoverNotSetup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
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
                            TextSpan(text: " Click here to set up your profile.", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black)),
                          ]),
                        ),
                      ]),
                    )),
                onTap: () {
                  Route r = MaterialPageRoute(builder: (context) => SetupScreen());
                  Navigator.push(context, r);
                })),
      ],
    );
  }
}
