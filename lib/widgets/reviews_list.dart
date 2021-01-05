import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/widgets/user_button.dart';

class ReviewsList extends StatelessWidget {
  final sight;

  ReviewsList(this.sight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      width: double.infinity,
      color: Theme.of(context).cardTheme.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: sight["reviews"].length > 0
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: sight["reviews"].length,
                    itemBuilder: (context, index) {
                      var review = sight["reviews"][index];
                      return StreamBuilder(
                        stream: getUserData(review["reviewer"]),
                        builder: (reviewerContext, reviewerSnapshot) {
                          if (reviewerSnapshot.hasData) {
                            var reviewer = reviewerSnapshot.data.documents[0];
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          UserButton(
                                            userData: reviewer,
                                            textStyle: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
                                            avatarSize: 14,
                                            isTripUser: false,
                                            avatarPadding: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.star, color: Colors.orange),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Flexible(
                                                child: Text(review["rating"].toDouble().toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Posted on " + Moment.fromDate(review["date"].toDate()).format("DD MMM yyyy"),
                                                    style:
                                                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Theme.of(context).textTheme.caption.color),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(review["text"])
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 0,
                                              child: IconButton(
                                                icon: Icon(FeatherIcons.moreVertical),
                                                onPressed: () {
                                                  print("menu button pressed");
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FeatherIcons.edit,
                          color: Theme.of(context).textTheme.caption.color,
                          size: 60,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "No reviews yet",
                          style: TextStyle(color: Theme.of(context).textTheme.caption.color, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Rate this sight!",
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
          ),
          SizedBox(
            child: ElevatedButton(
              child: Text("Write a review"),
              onPressed: () {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("This feature is not implemented yet.")));
              },
            ),
            height: 50,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
