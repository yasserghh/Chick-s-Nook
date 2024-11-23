import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodapp/app/constants.dart';
import 'package:foodapp/app/dependency_injection.dart';
import 'package:foodapp/app/shared_preferences.dart';
import 'package:foodapp/core/bases/base_viewmodel.dart';
import 'package:foodapp/core/resources/color_manager.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../core/resources/image_manager.dart';
import '../../../../../core/resources/styles_manager.dart';
import '../../home/view_model/home_viewmodel.dart';

class LocationViewModel extends BaseViewModel {
  final StreamController _currentPossitionController =
      BehaviorSubject<GoogleMapInputs>();
  final StreamController _currentPossitionTextController =
      BehaviorSubject<String>();
  TextEditingController textFormController = TextEditingController();
  GoogleMapController? controller;
  final AppPreferences _appPreferences = inectance<AppPreferences>();
  Set<Marker> myMark = Set.from([]);
  late BitmapDescriptor _myIcon;
  double lati = 0;
  double langi = 0;

  bool _isDisposed = false; // this is String for langitude
  _addIconMarker() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(30.0, 50.0)),
      ImageManager.locationIcon,
    ).then((val) {
      _myIcon = val;
    });
  }

  @override
  dispose() {
    controller?.dispose();
    _currentPossitionController.close();
    _currentPossitionTextController.close();
    _isDisposed = true;
  }

  @override
  start() {
    getCurrentLocation();
    _addIconMarker();
  }

  @override
  Sink get currentLocationTextInput => _currentPossitionTextController.sink;

  @override
  Stream<String> get currentLocationTextOutput =>
      _currentPossitionTextController.stream
          .map((locationText) => locationText);

  @override
  getCurrentLocation() async {
    await Geolocator.requestPermission();

    LatLng? possistion = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .then((value) async {
      Marker mark = Marker(
          markerId: const MarkerId("user"),
          icon: _myIcon,
          position: LatLng(value.latitude, value.longitude),
          draggable: true,
          onDragEnd: (val) {});
      myMark.add(mark);
      controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          zoom: 16, target: LatLng(value.latitude, value.longitude))));
      List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      langi = value.longitude;
      lati = value.latitude;
      langiI = value.longitude;
      latiI = value.latitude;

      if (_isDisposed) {
        return;
      }

      currentLocationTextInput.add(
          "${placemarks.first.locality} , ${placemarks.first.subLocality} , ${placemarks.first.street}");
      currentDataInput.add(GoogleMapInputs(
          LatLng(value.latitude, value.longitude), myMark, _myIcon));
    });
    return possistion;
  }

  @override
  getLocationFromSearch(BuildContext context, String locationName) async {
    try {
      List<Location> locations = await locationFromAddress(locationName);
      if (locations.isNotEmpty && locations != null) {
        if (locations.first.latitude != null &&
            locations.first.longitude != null) {
          controller?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  zoom: 15,
                  target: LatLng(
                      locations.first.latitude, locations.first.longitude))));
          List<Placemark> placemarks = await placemarkFromCoordinates(
              locations.first.latitude, locations.first.longitude);
          Marker mark = Marker(
              markerId: const MarkerId("user"),
              icon: _myIcon,
              position:
                  LatLng(locations.first.latitude, locations.first.longitude),
              draggable: true,
              onDragEnd: (val) {});
          myMark.add(mark);
          langi = locations.first.longitude;
          lati = locations.first.latitude;
          latiI = locations.first.latitude;
          langiI = locations.first.longitude;

          if (_isDisposed) {
            return;
          }
          currentLocationTextInput.add(
              "${placemarks.first.locality} , ${placemarks.first.subLocality} , ${placemarks.first.street}");

          currentDataInput.add(GoogleMapInputs(
              LatLng(locations.first.latitude, locations.first.longitude),
              myMark,
              _myIcon));

          locations.clear();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          dismissDirection: DismissDirection.none,
          elevation: 1000,
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 2 - 50,
              right: 20,
              left: 20),
          content: Container(
            alignment: Alignment.center,
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorManager.reed,
                borderRadius: BorderRadius.circular(30)),
            child: const Text(
                textAlign: TextAlign.center,
                "العنوان غير صحيح , يرجى ادخال عنوان موجود"),
          )));
    }
  }

  @override
  saveData(BuildContext context, HomeViewModel homeViewModel, String location,
      double lang, double lat) {
    if (location.isNotEmpty) {
      showToast('تم تحديث العنوان بنجاح',
          context: context,
          fullWidth: true,
          position: StyledToastPosition.top,
          textStyle: getSemiBoldStyle(14, ColorManager.white, ''),
          duration: const Duration(seconds: 4),
          animDuration: const Duration(milliseconds: 200),
          backgroundColor: Colors.green);
      homeViewModel.updateLocation(lat, lang, location);
      Navigator.of(context).pop();
    } else {
      showToast('يجب اختيار العنوان',
          context: context,
          fullWidth: true,
          position: StyledToastPosition.top,
          textStyle: getSemiBoldStyle(14, ColorManager.white, ''),
          duration: const Duration(seconds: 4),
          animDuration: const Duration(milliseconds: 200),
          backgroundColor: Colors.red);
    }
  }

  @override
  updateLocation(LatLng latlng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    langi = latlng.longitude;
    lati = latlng.latitude;
    latiI = latlng.latitude;
    langiI = latlng.longitude;
    Marker mark = Marker(
        markerId: const MarkerId("user"),
        icon: _myIcon,
        position: latlng,
        draggable: true,
        onDragEnd: (val) {});
    myMark.add(mark);

    location =
        "${placemarks.first.locality} , ${placemarks.first.subLocality} , ${placemarks.first.street}";
    if (_isDisposed) {
      return;
    }
    currentLocationTextInput.add(
        "${placemarks.first.locality} , ${placemarks.first.subLocality} , ${placemarks.first.street}");
    currentDataInput.add(GoogleMapInputs(
        LatLng(latlng.latitude, latlng.longitude), myMark, _myIcon));
  }

  @override
  Sink get currentDataInput => _currentPossitionController.sink;

  @override
  Stream<GoogleMapInputs> get currentDataOutput =>
      _currentPossitionController.stream.map((data) => data);
}

abstract class LocationInputs {
  getLocationFromSearch(BuildContext context, String locationName);
  getCurrentLocation();
  updateLocation(LatLng latlng);
  Sink get currentDataInput;
  Sink get currentLocationTextInput;
  saveData(BuildContext context, HomeViewModel homeViewModel, String location,
      double lang, double lat);
}

abstract class LocationOutputs {
  Stream<GoogleMapInputs> get currentDataOutput;
  Stream<String> get currentLocationTextOutput;
}

class GoogleMapInputs {
  LatLng latlang;
  Set<Marker> marker;
  BitmapDescriptor icon;
  GoogleMapInputs(this.latlang, this.marker, this.icon);
}
