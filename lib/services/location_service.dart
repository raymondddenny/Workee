import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:workee/utils/utils.dart';

class LocationService {
  Location location = Location();

  late LocationData _locationData;

  Future<Map<String, double>?> initializeAndGetLocation(BuildContext context) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Utils.showSnackBar(context, 'Please enable location service');
        return null;
      }
    }

    // if service enabled then ask permission for user  location from user

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Utils.showSnackBar(context, 'Please enable location permission');
        return null;
      }
    }

    //after permission granted get location
    _locationData = await location.getLocation();

    return {
      'latitude': _locationData.latitude!,
      'longitude': _locationData.longitude!,
    };
  }
}
