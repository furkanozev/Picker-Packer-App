import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:picker_packer/provider/geolocator_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();

  ApplicationBloc() {
    setCurrentLocation();
  }
  //Variables

  Position currentLocation;

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }
}
