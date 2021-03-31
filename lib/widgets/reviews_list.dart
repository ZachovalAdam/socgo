import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/widgets/user_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsList extends StatelessWidget {
  final sight;

  ReviewsList(this.sight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      width: double.infinity,
      color: Theme.of(context).cardTheme.color,
      child: FutureBuilder(
        future: getCurrentUserData(),
        builder: (BuildContext userContext, userSnapshot) {
          if (userSnapshot.hasData) {
            var userData = userSnapshot.data;
            bool isAdmin = userData["admin"];
            return Column(
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
                                                          "Posted on " + Moment.fromDate(review["date"].toDate()).format("dd MMM yyyy"),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600, fontSize: 12, color: Theme.of(context).textTheme.caption.color),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(review["text"])
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 0,
                                                    child: auth.currentUser.uid == reviewer["id"] || isAdmin
                                                        ? IconButton(
                                                            icon: Icon(FeatherIcons.x),
                                                            onPressed: () async {
                                                              await showDialog(
                                                                context: context,
                                                                builder: (_) => AlertDialog(
                                                                  title: Text("Delete review"),
                                                                  content: Text("Are you sure you want to delete this review?"),
                                                                  actions: [
                                                                    FlatButton(
                                                                      child: Text("No"),
                                                                      onPressed: () {
                                                                        Navigator.pop(context, true);
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child: Text("Yes"),
                                                                      onPressed: () {
                                                                        deleteReview(sight["id"], review);
                                                                        Navigator.pop(context, true);
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : Container(),
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
                  child: !sight["reviews"].any((map) => map["reviewer"] == auth.currentUser.uid)
                      ? ElevatedButton(
                          child: Text("Write a review"),
                          onPressed: () async {
                            final TextEditingController reviewController = TextEditingController();
                            var starRating = 3.0;

                            await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text("Write a review"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          TextFormField(
                                              maxLength: 250,
                                              maxLines: 3,
                                              keyboardType: TextInputType.multiline,
                                              controller: reviewController,
                                              decoration: InputDecoration(
                                                labelText: "Review",
                                              )),
                                          RatingBar(
                                            initialRating: 3,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            ratingWidget: RatingWidget(
                                              full: Icon(Icons.star, color: Colors.orange),
                                              half: Icon(Icons.star, color: Colors.orange),
                                              empty: Icon(Icons.star, color: Colors.orange.withAlpha(70)),
                                            ),
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            onRatingUpdate: (rating) {
                                              starRating = rating;
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        FlatButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("Done"),
                                          onPressed: () async {
                                            if (reviewController.text.isEmpty) {
                                              Navigator.pop(context, true);
                                            } else {
                                              createReview(auth.currentUser.uid, sight["id"], reviewController.text, starRating);
                                              Navigator.pop(context, true);
                                              await showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        title: Text("Success"),
                                                        content: Text("You have successfully posted a review."),
                                                        actions: [
                                                          FlatButton(
                                                            child: Text("Ok"),
                                                            onPressed: () {
                                                              Navigator.pop(context, true);
                                                            },
                                                          )
                                                        ],
                                                      ));
                                            }
                                          },
                                        ),
                                      ],
                                    ));
                          },
                        )
                      : Container(),
                  height: 50,
                  width: double.infinity,
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
