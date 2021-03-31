import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}
