import 'package:flutter/material.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/sightpage.dart';

class SightsScroller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getSightsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sights = snapshot.data.documents;
            return Container(
              width: double.infinity,
              height: 230,
              child: ListView.builder(
                itemCount: sights.length,
                itemBuilder: (context, index) {
                  var sight = sights[index];
                  return Container(
                    margin: EdgeInsets.only(
                        left: index == 0 ? 25 : 17,
                        right: index == sights.length - 1 ? 25 : 0),
                    width: 205,
                    child: GestureDetector(
                      onTap: () {
                        Route r = MaterialPageRoute(
                            builder: (context) => Sightpage(
                                  sight,
                                  heroTagName: sight.id,
                                ));
                        Navigator.push(context, r);
                      },
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
                                          tag: sight.id,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                sight["imageUrl"],
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Align(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                sight["name"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                          color:
                                                              Color(0x77000000),
                                                          blurRadius: 3,
                                                          offset:
                                                              Offset(0.0, 2.0))
                                                    ]),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0,
                                                        right: 3,
                                                        bottom: 1),
                                                    child: Icon(
                                                      Icons.place,
                                                      size: 13,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          sight["location"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
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
                                                              ]),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          alignment: Alignment.bottomLeft,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 7),
                                  margin: EdgeInsets.only(top: 185),
                                  height: 45,
                                  child: Align(
                                    child: Text(sight["description"],
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF606060))),
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
