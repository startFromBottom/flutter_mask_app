import 'package:mask_app/domain/model/location.dart';

abstract interface class LocationRepository {
  Future<Location> getLocation();
}
