import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/services/authentication_service.dart';
import 'package:socgo/widgets/sights_scroller.dart';
import 'package:socgo/widgets/greeting.dart';

class Sightpage extends StatefulWidget {
  Sightpage(this.sight, {Key key, this.title, this.heroTagName})
      : super(key: key);

  final String title;
  var sight;
  final String heroTagName;

  @override
  _SightpageState createState() => _SightpageState(sight, heroTag: heroTagName);
}

class _SightpageState extends State<Sightpage> {
  var sight;
  String heroTagName;
  _SightpageState(var s, {String heroTag}) {
    sight = s;
    heroTagName = heroTag;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: 500,
          child: Hero(
              flightShuttleBuilder: (BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext) =>
                  Material(child: toHeroContext.widget),
              tag: heroTagName,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                    child: Container(
                      width: double.infinity,
                      height: 500,
                      child: Image.network(
                        sight['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            //color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                  Container(
                    height: 500,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(sight["name"],
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: Colors.white, shadows: [
                              Shadow(
                                  color: Color(0x77000000),
                                  blurRadius: 3,
                                  offset: Offset(0.0, 2.0))
                            ])),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
