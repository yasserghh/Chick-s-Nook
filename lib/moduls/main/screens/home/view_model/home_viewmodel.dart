import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodapp/app/shared_preferences.dart';
import 'package:foodapp/core/bases/base_viewmodel.dart';
import 'package:foodapp/core/common/state_rendrer/state_rendrer_impl.dart';
import 'package:foodapp/core/resources/color_manager.dart';
import 'package:foodapp/core/resources/routes_manager.dart';
import 'package:foodapp/core/resources/styles_manager.dart';
import 'package:foodapp/moduls/main/domain/models/home_models.dart';
import 'package:foodapp/moduls/main/domain/use_cases/use_caces.dart';
import 'package:foodapp/moduls/main/screens/location/view/location_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../core/local_data/remote_local_data.dart';
import 'package:foodapp/app/constants.dart';

import '../../../../../core/resources/fonts_manager.dart';

class HomeViewModel extends BaseViewModel {
  final StreamController _isLocationShowed = BehaviorSubject<bool>();
  final StreamController _getCatygory = BehaviorSubject<List<Caty>>();
  final StreamController _getItems = BehaviorSubject<List<Product>>();
  final StreamController _getsearch = BehaviorSubject<List<Product>>();
  final StreamController _counterCardStream = BehaviorSubject<int>();
  final StreamController _indexCategoryStream = BehaviorSubject<int>();
  final StreamController _locationStream = BehaviorSubject<String>();
  final HomeUseCace _homeUseCace;
  final SearchUseCase _searchUseCase;
  final RemoteLocalDataSource _dataSource;
  HomeViewModel(this._homeUseCace, this._dataSource, this._appPreferences,
      this._searchUseCase);
  final AppPreferences _appPreferences;
  bool isShowed = false;
  int counter = 0;
  String location = '';
  double? langi;
  double? lati;
  List<Product>? allProducts = [];
  List<Product>? products = [];
  List<Caty>? category = [];
  List<Baner>? banners = [];
  @override
  dispose() {}

  @override
  start() {
    if (location.isEmpty) {
      getLocation();
    }
    //updateLocation();
    getHomeData();
    getCounter();
    /*print(lati);
    print("------");
    print(langi);
    locationInput.add(location);*/
    counterCardInput.add(counter);
  }

  getCurrentPosition() async {
    LatLng? possistion =
        await Geolocator.getCurrentPosition().then((value) async {
      if (value.latitude != 0) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          value.latitude,
          value.longitude,
        );
        if (placemarks.isNotEmpty) {
          String locationName =
              "${placemarks[0].name},${placemarks[0].subLocality},${placemarks[0].administrativeArea},${placemarks[0].country}";
          locationInput.add(locationName);
          location = locationName;
          langi = value.longitude;
          lati = value.latitude;
        }
      }
    });
  }

  Future<bool> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
   await  getCurrentPosition();
    return true;
  }

  @override
  Sink get itemsInput => _getItems.sink;
  @override
  Sink get categoryInput => _getCatygory.sink;
  @override
  Sink get showLocationInput => _isLocationShowed.sink;
  @override
  Sink get counterCardInput => _counterCardStream.sink;
  @override
  Sink get locationInput => _locationStream.sink;
  @override
  Sink get searchInput => _getsearch.sink;
  @override
  Sink get indexCategoryInput => _indexCategoryStream.sink;

  @override
  Stream<int> get indexCategoryOutputs =>
      _indexCategoryStream.stream.map((index) => index);

  // outputs

  @override
  Stream<int> get counterCardOutputs =>
      _counterCardStream.stream.map((event) => event);
  @override
  Stream<List<Product>> get itemsOutputs =>
      _getItems.stream.map((item) => item);

  @override
  Stream<List<Caty>> get categoryOutputs =>
      _getCatygory.stream.map((offre) => offre);
  @override
  Stream<bool> get showLocationOutputs =>
      _isLocationShowed.stream.map((showed) => showed);
  @override
  Stream<String> get locationOutputs =>
      _locationStream.stream.map((event) => event);
  @override
  Stream<List<Product>> get searchOutputs =>
      _getsearch.stream.map((event) => event);

  // methods
  @override
  getHomeData() async {
    allProducts = [];
    products = [];
    flowStateInput.add(LoadingStateFullScreen(""));
    (await _homeUseCace.excute(HomeInpts())).fold(
        (faileur) =>
            {flowStateInput.add(ErrorStateFullScreen(faileur.message))},
        (data) => {
              data.baners?.forEach((element) {
                banners?.add(Baner(element.image));
              }),
              print("==============>${data.category}"),
              data.category?.forEach((element) {
                category?.add(Caty(element.images, element.title, element.id));
              }),
              data.products?.forEach((element) {
                allProducts?.add(Product(
                    name: element.name,
                    description: element.description,
                    image: element.image,
                    price: element.price,
                    type: element.type,
                    options: element.options,
                    id: element.id,
                    discount: element.discount,
                    category: element.category));
              }),
              changeCategory(data.category![0].id, 0),
              categoryInput.add(category),
              flowStateInput.add(ContentState()),
            });
  }

  @override
  goToPageLocation(BuildContext context, HomeViewModel homeViewModel) async {
    var status = await Permission.location.status;
  
    if (status.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LocationScreen(
                homeViewModel: homeViewModel,
              )));
    } else if (status.isDenied) {
      var result = await Permission.location.request();
     
      if (result.isGranted) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => LocationScreen(
                  homeViewModel: homeViewModel,
                )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.reed,
            duration: const Duration(seconds: 3),
            content: Text(
              "يجب السماح للتطبيق بالوصول الى نضام GPS",
              style: getSemiBoldStyle(14, ColorManager.white, ""),
            )));
      }
    }else if(status.isPermanentlyDenied){}else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.reed,
            duration: const Duration(seconds: 3),
            content: Text(
              "يجب السماح للتطبيق بالوصول الى نضام GPS",
              style: getSemiBoldStyle(14, ColorManager.white, ""),
            )));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LocationScreen(
                homeViewModel: homeViewModel,
              )));
    }
  }

  @override
  showLocation(bool showed) {
    showed == true ? showLocationInput.add(false) : showLocationInput.add(true);
  }

  updateLocation(double lat, double lang, String location) {
    location = location;
    lati = lat;
    langi = lang;
    locationInput.add(location);
  }

  @override
  getCounter() async {
    var response = await _dataSource.onReedDbCards();
    if (response != null) {
      counter = response.length;
      counterCardInput.add(counter);
    }
  }

  @override
  search(String title) async {
    if (title != null) {
      (await _searchUseCase.excute(SearchInputs(title))).fold(
          (l) => {searchInput.add([])}, (r) => {searchInput.add(r.products)});
    }
  }

  @override
  deleteAllCards(BuildContext context) async {
    await _dataSource.onDeleteDbAllCards();

    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.successOrder, (route) => false);
  }

  @override
  changeCategory(int caty, int index) {
    products = [];
    indexCategoryInput.add(index);
    allProducts?.forEach((element) {
      if (element.category == '$caty') {
        products?.add(element);
      }
    });
    itemsInput.add(products);
  }
}

abstract class HomeInputs {
  Sink get categoryInput;
  Sink get itemsInput;
  Sink get searchInput;
  Sink get showLocationInput;
  Sink get counterCardInput;
  Sink get locationInput;
  Sink get indexCategoryInput;
  getHomeData();
  changeCategory(int caty, int index);
  search(String title);
  showLocation(bool showed);
  goToPageLocation(BuildContext context, HomeViewModel homeViewModel);
  getCounter();
  deleteAllCards(BuildContext context);
}

abstract class HomeIOutPuts {
  Stream<List<Caty>> get categoryOutputs;
  Stream<List<Product>> get itemsOutputs;
  Stream<List<Product>> get searchOutputs;
  Stream<bool> get showLocationOutputs;
  Stream<String> get locationOutputs;
  Stream<int> get counterCardOutputs;
  Stream<int> get indexCategoryOutputs;
}
