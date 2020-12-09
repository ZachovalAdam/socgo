import 'package:flutter/material.dart';

class SightScreen extends StatefulWidget {
  SightScreen(this.sight, {Key key, this.title, this.heroTagName})
      : super(key: key);

  final String title;
  var sight;
  final String heroTagName;

  @override
  _SightScreenState createState() =>
      _SightScreenState(sight, heroTag: heroTagName);
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
            expandedHeight: 468,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                child: Hero(
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
                          alignment: Alignment.bottomCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              child: ShaderMask(
                                shaderCallback: (rect) {
                                  return LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Color(0x66000000),
                                      Colors.transparent
                                    ],
                                  ).createShader(Rect.fromLTRB(
                                      0, 0, rect.width, rect.height));
                                },
                                blendMode: BlendMode.dstIn,
                                child: Container(
                                  height: 120,
                                  decoration:
                                      BoxDecoration(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 500,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                            child: Text(sight["name"],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    .copyWith(
                                                        color: Colors.white,
                                                        shadows: [
                                                      Shadow(
                                                          color:
                                                              Color(0x77000000),
                                                          blurRadius: 3,
                                                          offset:
                                                              Offset(0.0, 2.0))
                                                    ]))),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 32,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: SizedBox(
                                                        width: 10,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text("5.0",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline5
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  shadows: [
                                                                Shadow(
                                                                    color: Color(
                                                                        0x77000000),
                                                                    blurRadius:
                                                                        3,
                                                                    offset:
                                                                        Offset(
                                                                            0.0,
                                                                            2.0))
                                                              ])),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text("21 reviews",
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(
                                                          color: Colors.white,
                                                          shadows: [
                                                        Shadow(
                                                            color: Color(
                                                                0x77000000),
                                                            blurRadius: 3,
                                                            offset: Offset(
                                                                0.0, 2.0))
                                                      ]))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
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
                        Text(sight['description']),
                      ],
                    ),
                  ),
                ),
              ])),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Container(
          width: MediaQuery.of(context).size.width - 70,
          child: Text("Make a trip", textAlign: TextAlign.center),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
