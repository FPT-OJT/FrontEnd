import 'package:fpt_ojt/features/merchants/data/models/location_model.dart';

abstract class LocationDataSource {
  Future<LocationModel> getCurrentLocation();
}
