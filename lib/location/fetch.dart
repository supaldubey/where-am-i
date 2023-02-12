import 'package:location/location.dart';
import 'package:geocode/geocode.dart';

const internalError = "internal_error";
const locationDisabled = "location_disabled";
const permissionError = "no_permission";

// replace your keys here or else use GeoCode()
// instead of GeoCode(apiKey: geoCodeApiKey)
const geoCodeApiKey = "";

class CurrentLocation {
  String? streetAddress;
  String? city;
  String? country;
  double? latitude;
  double? longitude;
  double? accuracy;

  CurrentLocation.create(this.streetAddress, this.city, this.country,
      this.latitude, this.longitude, this.accuracy);
}

// Its bad but its probably only hack that works?
// https://github.com/Lyokone/flutterlocation/issues/568
Future<void> initLocation(Location loc, {int limit = 13}) async {
  for (int i = 0; i < limit; i++) {
    try {
      await loc.serviceEnabled();
      return;
    } catch (err) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}

Future<CurrentLocation> fetchLocation() async {
  Location location = Location();
  await initLocation(location);
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
    var reverseGeocoding = await GeoCode(apiKey: geoCodeApiKey)
        .reverseGeocoding(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!);

    return CurrentLocation.create(
        findAddress(reverseGeocoding),
        reverseGeocoding.city,
        reverseGeocoding.countryCode,
        locationData.latitude,
        locationData.longitude,
        locationData.accuracy);
  } catch (err) {
    return Future.error(err);
  }
}

String? findAddress(Address reverseGeocoding) {
  int? streetNumber = reverseGeocoding.streetNumber;
  String? streetAddress = reverseGeocoding.streetAddress;

  return '$streetNumber, $streetAddress';
}
