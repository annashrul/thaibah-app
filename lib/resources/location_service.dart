
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:thaibah/DBHELPER/userDBHelper.dart';
import 'package:thaibah/Model/user_location.dart';

class LocationService  with ChangeNotifier  {
  UserLocation _currentLocation;
  Location location = Location();

  StreamController<UserLocation> _locationController = StreamController<UserLocation>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted) {
        location.onLocationChanged().listen((locationData) async {

          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
          }
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } catch (e) {
      print('Could not get the location: $e');
    }

    return _currentLocation!=null?_currentLocation:'';
  }
}
