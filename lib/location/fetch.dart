import 'package:location/location.dart';
import 'package:geocode/geocode.dart';

class CurrentLocation {
  String? street1;
  String? street2;
  String? city;
  String? country;
  double? latitude;
  double? longitude;

  CurrentLocation.create(this.street1, this.street2, this.city, this.country,
      this.latitude, this.longitude);
}

const internalError = "internal_error";
const locationDisabled = "location_disabled";
const permissionError = "no_permission";


Future<CurrentLocation> fetchLocation() async {
  Location location = Location();

  bool serviceEnabled = false;
  PermissionStatus permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return Future.error(locationDisabled);
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return Future.error(permissionError);
    }
  }
  LocationData? locationData;

  try {
    locationData = await location.getLocation();
  } catch (err) {
    return Future.error(internalError);
  }

  try {
    var reverseGeocoding = await GeoCode().reverseGeocoding(
        latitude: locationData.latitude!, longitude: locationData.longitude!);

    return CurrentLocation.create(
        reverseGeocoding.region,
        reverseGeocoding.streetAddress,
        reverseGeocoding.city,
        reverseGeocoding.countryName,
        locationData.latitude,
        locationData.longitude);
  } catch (err) {
    return Future.error(internalError);
  }
}
