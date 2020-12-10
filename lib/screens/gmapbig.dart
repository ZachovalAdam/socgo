import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapBigScreen extends StatefulWidget {
  GMapBigScreen(this.sight);

  var sight;

  @override
  _GMapBigScreenState createState() => _GMapBigScreenState(sight);
}

class _GMapBigScreenState extends State<GMapBigScreen> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  var sight;

  _GMapBigScreenState(var s) {
    sight = s;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("0"),
          position: LatLng(sight["location"].latitude, sight["location"].longitude),
          infoWindow: InfoWindow(title: sight["name"], snippet: "Click the button in the bottom right corner to navigate.")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              rotateGesturesEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(target: LatLng(sight["location"].latitude, sight["location"].longitude), zoom: 12, tilt: 0),
              markers: _markers,
            ),
          ),
          Container(
            height: 56 + MediaQuery.of(context).padding.top,
            child: AppBar(
              toolbarHeight: 56,
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
