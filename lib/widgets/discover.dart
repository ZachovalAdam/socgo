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
                          backgroundImage: NetworkImage(userData["pictureUrl"]),
                          radius: 16.0),
                      constraints: BoxConstraints(minWidth: 75),
                      onPressed: () {}),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.chat_bubble_outline),
                    onPressed: () {},
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 30, 25, 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Greeting(),
                            Text(userData["firstName"],
                                style: Theme.of(context).textTheme.headline3),
                            SizedBox(
                              height: 40,
                            ),
                            Text('Popular',
                                style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ),
                    ),
                    SightsScroller(),
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
                            Text('Newly added',
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
