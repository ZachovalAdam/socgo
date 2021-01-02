import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:socgo/screens/sight.dart';

class RandomSight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: InkWell(
        onTap: () {
          Route r = MaterialPageRoute(
              builder: (context) => SightScreen(
                    "",
                    heroTagName: "VsjBg4doyM5ddJH8srvA_rand",
                  ));
          Navigator.push(context, r);
        },
        child: Hero(
          tag: "test",
          child: Container(
            width: double.infinity,
            height: 100,
            child: Row(
              children: [
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: "https://zptacihopohledu.cz/wp-content/uploads/2016/10/DJI_0026-copy.jpg",
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Text(
                                "Chapel of St. John the Baptist",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.orange),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text("4.7",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ))
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 0, right: 3, bottom: 0),
                                child: Icon(
                                  Icons.place,
                                  size: 13,
                                  color: Theme.of(context).textTheme.headline1.color.withOpacity(.75),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "Radvanice, Czechia",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Theme.of(context).textTheme.headline1.color.withOpacity(.75),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                FeatherIcons.flag,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "5 trips",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                FeatherIcons.users,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "16 people",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
