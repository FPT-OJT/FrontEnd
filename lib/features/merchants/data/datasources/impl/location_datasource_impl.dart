import 'package:fpt_ojt/features/merchants/data/datasources/location_datasource.dart';
import 'package:fpt_ojt/features/merchants/data/models/location_model.dart';
import 'package:geolocator/geolocator.dart';

class LocationDatasourceImpl extends LocationDataSource {
  @override
  Future<LocationModel> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    final position = await Geolocator.getCurrentPosition();
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
