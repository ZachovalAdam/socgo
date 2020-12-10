import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMap extends StatefulWidget {
  GMap(this.sight);

  var sight;

  @override
  _GMapState createState() => _GMapState(sight);
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  var sight;

  _GMapState(var s) {
    sight = s;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("0"),
        position:
            LatLng(sight["location"].latitude, sight["location"].longitude),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        zoomControlsEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
        rotateGesturesEnabled: false,
        initialCameraPosition: CameraPosition(
            target:
                LatLng(sight["location"].latitude, sight["location"].longitude),
            zoom: 12,
            tilt: 0),
        markers: _markers,
      ),
    );
  }
}
