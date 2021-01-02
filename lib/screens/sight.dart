import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:socgo/widgets/gmap.dart';
import 'package:socgo/screens/gmapbig.dart';
import 'package:socgo/widgets/trips_list.dart';

class SightScreen extends StatefulWidget {
  SightScreen(this.sight, {Key key, this.title, this.heroTagName}) : super(key: key);

  final String title;
  var sight;
  final String heroTagName;

  @override
  _SightScreenState createState() => _SightScreenState(sight, heroTag: heroTagName);
}

class _SightScreenState extends State<SightScreen> {
  var sight;
  String heroTagName;
  _SightScreenState(var s, {String heroTag}) {
    sight = s;
    heroTagName = heroTag;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 248,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                child: Hero(
                  tag: heroTagName,
                  child: ClipRRect(
                    child: Stack(
                      children: [
                        Container(
                            width: double.infinity,
                            height: 280,
                            child: CachedNetworkImage(
                              imageUrl: sight["imageUrl"],
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                                height: 20,
                                width: 20,
                              ),
                              errorWidget: (context, url, error) => Icon(FeatherIcons.alertCircle),
                            )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipRect(
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              child: ShaderMask(
                                shaderCallback: (rect) {
                                  return LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Color(0xFF000000), Colors.transparent],
                                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                                },
                                blendMode: BlendMode.dstIn,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(color: MediaQuery.platformBrightnessOf(context) == Brightness.dark ? Colors.black : Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ClipRect(
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              child: ShaderMask(
                                shaderCallback: (rect) {
                                  return LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.transparent, Color(0x77000000)],
                                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                                },
                                blendMode: BlendMode.dstIn,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(color: MediaQuery.platformBrightnessOf(context) == Brightness.dark ? Colors.black : Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.fromLTRB(25, 30, 25, 30),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sight["name"], style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: 10),
                    Text("Placeholder location",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).textTheme.headline1.color.withOpacity(0.7))),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Text(" 5.0", style: Theme.of(context).textTheme.headline6),
                            ],
                          ),
                        ),
                        Flexible(child: Text("24 reviews", style: Theme.of(context).textTheme.headline6)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(sight['description']),
                    SizedBox(height: 30),
                    Text(
                      "Reviews",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 10),
                    Placeholder(
                      fallbackHeight: 195,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Gallery",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 10),
                    Placeholder(
                      fallbackHeight: 160,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Trips",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: TripsList(sight.id),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Location",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              Route r = MaterialPageRoute(builder: (context) => GMapBigScreen(sight));
                              Navigator.push(context, r);
                            },
                            child: IgnorePointer(
                              child: GMap(sight),
                              ignoring: true,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 60),
          ])),
        ],
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton.extended(
          onPressed: () {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("This feature is not implemented yet.")));
          },
          label: Container(
            width: MediaQuery.of(context).size.width - 88,
            child: Text(
              "Make a trip",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
