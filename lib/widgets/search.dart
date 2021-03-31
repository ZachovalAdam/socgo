import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/sight.dart';
import 'package:socgo/widgets/random_sight.dart';
import 'package:socgo/widgets/sights_scroller.dart';
import 'package:socgo/widgets/greeting.dart';
import 'package:socgo/widgets/info_panel.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  var sightsList = [];

  Widget build(BuildContext context) {
    final currentPos = Provider.of<Position>(context);

    final TextEditingController searchController = TextEditingController();

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
                        return !isProfileSetup
                            ? SearchNotSetup()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(25, 30, 25, 15),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextFormField(
                                              maxLength: 250,
                                              maxLines: null,
                                              keyboardType: TextInputType.name,
                                              controller: searchController,
                                              onEditingComplete: () => {handleSearch(searchController.text, sightsList)},
                                              decoration: InputDecoration(
                                                labelText: "Search for sights (case-sensitive)",
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: sightsList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          child: InkWell(
                                            onTap: () {
                                              Route r = MaterialPageRoute(
                                                  builder: (context) => SightScreen(
                                                        sightsList[index],
                                                        heroTagName: sightsList[index]["id"],
                                                      ));
                                              Navigator.push(context, r);
                                            },
                                            child: ListTile(
                                              title: Text(sightsList[index]["name"]),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
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

  handleSearch(String searchText, List sightsList) {
    if (searchText.isNotEmpty) {
      setState(() {
        sightsList.clear();
      });
      getSearchData(searchText).then((sights) => {
            for (var i = 0; i < sights.documents.length; ++i)
              {
                setState(() {
                  sightsList.add(sights.documents[i].data());
                  print(sightsList);
                })
              }
          });
    }
  }
}

class SearchNotSetup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.all(25),
            child: Text(
              "Your profile hasn't been set up yet. You won't have access to any features of the app until it's setup.",
              textAlign: TextAlign.center,
            )),
      ],
    );
  }
}
