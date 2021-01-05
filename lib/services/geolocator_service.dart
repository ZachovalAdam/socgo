import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position> getLocation() async {
    var geolocator = Geolocator();
    return await Geolocator.getCurrentPosition();
  }
}
