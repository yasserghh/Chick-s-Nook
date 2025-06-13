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
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
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
      if (permission == LocationPermission.denied) {}
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    await getCurrentPosition();
    return true;
  }
Future<bool> isInsideCustomZone() async {
  // Get user location
  mp.LatLng userLocation = mp.LatLng(lati!, langi!);
final dangerZoneChragaPolygon = <mp.LatLng>[
  const mp.LatLng(36.72505885300879, 2.9899278934587414),
const mp.LatLng(36.725610836497026, 2.9658565686958127),
const mp.LatLng(36.70887206950515, 2.9630677834965695),
const mp.LatLng(36.707561845940944, 2.9855616772538838),
const mp.LatLng(36.71997575179087, 2.9865652624897905),
const mp.LatLng(36.72493629586144, 2.9898514717012574),
];

  final chragaPolygon = <mp.LatLng>[
     const mp.LatLng(36.716727492805816, 2.8275594683729537),
  const mp.LatLng(36.71311089578879, 2.8331701522301103),
  const mp.LatLng(36.710030755143734, 2.832019133334285),
  const mp.LatLng(36.70789313255338, 2.8366420954580747),
  const mp.LatLng(36.70804372910389, 2.8386851494949497),
  const mp.LatLng(36.70132377775276, 2.8408205753521543),
  const mp.LatLng(36.701457100431625, 2.840704715103641),
  const mp.LatLng(36.695895361628615, 2.8431163999005094),
  const mp.LatLng(36.69475247754568, 2.845888847022195),
  const mp.LatLng(36.69251076923446, 2.8473454623594705),
  const mp.LatLng(36.68959088807139, 2.8500312690908345),
  const mp.LatLng(36.68895814511737, 2.8482300751267076),
  const mp.LatLng(36.685197721387865, 2.848898515014781),
  const mp.LatLng(36.68272179060695, 2.852298488587735),
  const mp.LatLng(36.68290284409815, 2.852159747683345),
  const mp.LatLng(36.690551208478055, 2.8621636123743315),
  const mp.LatLng(36.69432236886668, 2.857383492772243),
  const mp.LatLng(36.69383909532506, 2.8479414135985905),
  const mp.LatLng(36.70219715743836, 2.844863342031715),
  const mp.LatLng(36.707233114730954, 2.852025190517452),
  const mp.LatLng(36.713549060777524, 2.8540854700575835),
  const mp.LatLng(36.712289981054425, 2.854201516726249),
  const mp.LatLng(36.71306400888211, 2.854625775357649),
    const mp.LatLng(36.72782522245352, 2.8681309670539292),
  const mp.LatLng(36.722524376082745, 2.875159493292699),
  const mp.LatLng(36.71849624420514, 2.8998843135368872),
  const mp.LatLng(36.71883996174388, 2.90751694590233),
  const mp.LatLng(36.71878839914196, 2.907324640487218),
  const mp.LatLng(36.712298530243515, 2.9064393531834583),
  const mp.LatLng(36.70749045489973, 2.910255650065068),
  const mp.LatLng(36.70611105580657, 2.9131771900541708),
  const mp.LatLng(36.70615226445882, 2.9130989387454918),
  const mp.LatLng(36.71704791461383, 2.922416406662535),
  const mp.LatLng(36.71700951566088, 2.922149552549371),
  const mp.LatLng(36.724250357858935, 2.9188884489636564),
  const mp.LatLng(36.72876314967, 2.922335377160408),
  const mp.LatLng(36.72546186712617, 2.9305217496406613),
  const mp.LatLng(36.729156205744715, 2.9349510514275607),
  const mp.LatLng(36.729191642975906, 2.9347153774308197),
  const mp.LatLng(36.73186884822164, 2.9261269667280487),
  const mp.LatLng(36.731933380573835, 2.9338878243432305),
  const mp.LatLng(36.724475159001344, 2.937647585693128),
  const mp.LatLng(36.722914567230504, 2.9431902814386888),
  const mp.LatLng(36.72295996587911, 2.9430426614364933),
  const mp.LatLng(36.72247290923853, 2.950147516824387),
  const mp.LatLng(36.71880115208647, 2.9426219792103154),
  const mp.LatLng(36.718858508058844, 2.9426717910227467),
  const mp.LatLng(36.714134137158354, 2.9457453552978734),
  const mp.LatLng(36.722532171617715, 2.9547589466220643),
const mp.LatLng(36.722425468054396, 2.9544632598569365),
const mp.LatLng(36.702013215864355, 2.9656440972850646),
const mp.LatLng(36.68747542886851, 2.9519619475694014),
const mp.LatLng(36.687582178439584, 2.9520746313644395),
const mp.LatLng(36.681183640508706, 2.937901375659294),
const mp.LatLng(36.678464025790575, 2.9362913378271003),
const mp.LatLng(36.67330380073447, 2.940870997084261),
const mp.LatLng(36.672626956731705, 2.9418029849048537),
const mp.LatLng(36.67264524964091, 2.94175141972957),
const mp.LatLng(36.66785987321805, 2.9367752732779877),
const mp.LatLng(36.66472518587639, 2.939615063660426),
const mp.LatLng(36.664766984509654, 2.939589013536505),
const mp.LatLng(36.66583279195264, 2.951729768752415),
const mp.LatLng(36.665804128681884, 2.951568763476473),
const mp.LatLng(36.666668867118375, 2.959854996708316),
const mp.LatLng(36.6666728218261, 2.959796088946632),
const mp.LatLng(36.66548592350911, 2.9628822880588643),
const mp.LatLng(36.66796451591324, 2.967452015130391),
const mp.LatLng(36.66797838883342, 2.9674481716767787),
const mp.LatLng(36.67130155036482, 2.967046543024594),
const mp.LatLng(36.67125080362814, 2.9670940317959946),
const mp.LatLng(36.67861603346893, 2.9636504517527555),
const mp.LatLng(36.67861607356957, 2.9636005197733084),
const mp.LatLng(36.68474005058832, 2.9753297311974904),
const mp.LatLng(36.68471784654936, 2.9752434866708484),
const mp.LatLng(36.68270712548899, 2.9861773085104915),
const mp.LatLng(36.68549995486936, 2.988687398134715),
const mp.LatLng(36.68548431882324, 2.9886927839328052),
const mp.LatLng(36.696928781411444, 2.9843581339768264),
const mp.LatLng(36.69683855722201, 2.9873465165089783),
const mp.LatLng(36.696891363945895, 2.9872760758575225),
const mp.LatLng(36.69735696309553, 2.9931244365415353),
const mp.LatLng(36.700948633181554, 2.993290347482912),
const mp.LatLng(36.70088623317858, 2.993264558990404),
const mp.LatLng(36.694192024088196, 3.013735572857968),
const mp.LatLng(36.69467479905464, 3.015180585601911),
const mp.LatLng(36.7085130589699, 3.0057478635258974),
const mp.LatLng(36.708478357823694, 3.005787430412539),
const mp.LatLng(36.71941580556836, 3.0030660846378794),
const mp.LatLng(36.719325621708606, 3.003068221537063),
const mp.LatLng(36.72936640590325, 3.0040938420380314),
const mp.LatLng(36.72931813558341, 3.004125173693353),
const mp.LatLng(36.73032231568115, 3.011594572911207),
const mp.LatLng(36.73379822230032, 3.0104380207746715),
const mp.LatLng(36.735883690737964, 3.010245262085249),
const mp.LatLng(36.73619264420675, 3.012461987013552),
const mp.LatLng(36.73599954843493, 3.013859487512434),
const mp.LatLng(36.738239429532314, 3.0130884527547437),
const mp.LatLng(36.74121296380375, 3.009666986015816),
const mp.LatLng(36.74306653727035, 3.0065346573122156),
const mp.LatLng(36.74453391784962, 3.002293966143867),
const mp.LatLng(36.74453066204154, 3.002364227235006),
const mp.LatLng(36.75117301159071, 3.004471781214221),
const mp.LatLng(36.75114486529394, 3.004436659283158),
const mp.LatLng(36.75184847059445, 3.010408062223547),
const mp.LatLng(36.75108857659119, 3.0140260298876456),
const mp.LatLng(36.747711178854075, 3.0144475406841877),
const mp.LatLng(36.74568466885526, 3.016484842863264),
const mp.LatLng(36.74410845741271, 3.019400292534584),
const mp.LatLng(36.743658105340316, 3.020348691825262),
const mp.LatLng(36.74367931731837, 3.0203433245358156),
const mp.LatLng(36.74062520594953, 3.0248935208434204),
const mp.LatLng(36.738607578057994, 3.0249039815329013),
const mp.LatLng(36.737329186563045, 3.025701600883991),
const mp.LatLng(36.737343837124854, 3.025704268970884),
const mp.LatLng(36.73623263916785, 3.027346277768828),
const mp.LatLng(36.73180230847211, 3.028440950299938),
const mp.LatLng(36.73184617123361, 3.028422707217487),
const mp.LatLng(36.72737011232975, 3.0304269709696428),
const mp.LatLng(36.72730274524088, 3.0303747474039824),
const mp.LatLng(36.72945324373609, 3.031418198820859),
const mp.LatLng(36.72937359671755, 3.0340516714436205),
const mp.LatLng(36.73367441748938, 3.036983273044342),
const mp.LatLng(36.73371021179855, 3.0368696785943996),
  const mp.LatLng(36.734493745836005, 3.036800095603951),
  const mp.LatLng(36.734607215010186, 3.03274794935092),
  const mp.LatLng(36.73869268725707, 3.0330981185047676),
  const mp.LatLng(36.73867222459657, 3.0330905193289937),
  const mp.LatLng(36.74061927339426, 3.040409173606662),
  const mp.LatLng(36.740637904706446, 3.040320303617392),
  const mp.LatLng(36.74897166312098, 3.035549844756133),
  const mp.LatLng(36.74905800719364, 3.0356230143468395),
  const mp.LatLng(36.76500621848943, 3.023903061509941),
  const mp.LatLng(36.76495063799226, 3.023933365749599),
  const mp.LatLng(36.76938322748826, 3.033494916624619),
  const mp.LatLng(36.770624306630765, 3.0402234153885956),
  const mp.LatLng(36.77289365653698, 3.0441188620415005),
  const mp.LatLng(36.772866662881654, 3.0440852990689393),
  const mp.LatLng(36.77528826851906, 3.0427550825760363),
  const mp.LatLng(36.77396446691611, 3.0349350219778444),
  const mp.LatLng(36.77401164672996, 3.035011093023087),
  const mp.LatLng(36.77255866833096, 3.0311010627249857),
  const mp.LatLng(36.773495035343274, 3.0218701664524588),
  const mp.LatLng(36.77026613530141, 3.0113896728685177),
  const mp.LatLng(36.77037217974363, 3.0114873761329193),
  const mp.LatLng(36.785250133512605, 3.0139425741005255),
  const mp.LatLng(36.7899090898827, 3.017198205274383),
  const mp.LatLng(36.790247705741606, 3.0183132502599506),
  const mp.LatLng(36.79092586969135, 3.0176835586909476),
  const mp.LatLng(36.79071720449973, 3.0163807485470784),
  const mp.LatLng(36.786943744230456, 3.0134711392276756),
  const mp.LatLng(36.78701674355426, 3.0133796918227063),
  const mp.LatLng(36.7852772812232, 3.011283951421632),
  const mp.LatLng(36.78164564487727, 2.9854872923093865),
  const mp.LatLng(36.78168945508075, 2.9856123576746256),
  const mp.LatLng(36.785495536828236, 2.968016063926399),
  const mp.LatLng(36.78551424591916, 2.9681403956663814),
  const mp.LatLng(36.78793882026163, 2.9702670141588214),
  const mp.LatLng(36.7891237800678, 2.971104523395212),
  const mp.LatLng(36.78994706214279, 2.9765020015774724),
  const mp.LatLng(36.79333892022224, 2.979835910355831),
  const mp.LatLng(36.794673332352474, 2.982784770701244),
  const mp.LatLng(36.795542095309884, 2.984636520607438),
  const mp.LatLng(36.79620706882599, 2.988990637113659),
  const mp.LatLng(36.7933333744767, 2.98918514143287),
  const mp.LatLng(36.79307661321248, 2.9939923463819014),
  const mp.LatLng(36.797032780933066, 2.99464367643958),
  const mp.LatLng(36.79661991979167, 2.9843794434973177),
  const mp.LatLng(36.79323899473016, 2.9767579023925634),
  const mp.LatLng(36.787629185770825, 2.96627649405022),
  const mp.LatLng(36.78762831238714, 2.9662736773175027),
  const mp.LatLng(36.78685589419922, 2.964988667710287),
  const mp.LatLng(36.78727077551349, 2.961773494178999),
  const mp.LatLng(36.784587314851805, 2.9613874271067004),
  const mp.LatLng(36.78489700425858, 2.959389621158067),
  const mp.LatLng(36.781849809421146, 2.958680877093286),
  const mp.LatLng(36.78236763575107, 2.962354486833533),
  const mp.LatLng(36.7802018532812, 2.9637052894879616),
  const mp.LatLng(36.77901797169058, 2.9649260426860735),
  const mp.LatLng(36.778349737389505, 2.966532957043995),
  const mp.LatLng(36.77706207208067, 2.9662742620832034),
  const mp.LatLng(36.775462119168836, 2.9650529109800345),
  const mp.LatLng(36.77211070561191, 2.9655678628443525),
  const mp.LatLng(36.772325679027134, 2.9654756362082253),
  const mp.LatLng(36.77165662682273, 2.9533659162198376),
  const mp.LatLng(36.7770098668439, 2.952988515088805),
  const mp.LatLng(36.77773171009834, 2.951448541646215),
  const mp.LatLng(36.78067356447957, 2.9537742860757703),
  const mp.LatLng(36.78329308068149, 2.9498422259282506),
  const mp.LatLng(36.7833219995389, 2.9500140962977923),
  const mp.LatLng(36.78799918702023, 2.950277465024101),
  const mp.LatLng(36.798150483766506, 2.9298728956235323),
  const mp.LatLng(36.80113948784269, 2.9299756171662636),
  const mp.LatLng(36.799040877044106, 2.920786040427089),
  const mp.LatLng(36.80054326628226, 2.919603884171579),
  const mp.LatLng(36.80061912933695, 2.919606274933244),
  const mp.LatLng(36.801962557446984, 2.915738246361201),
  const mp.LatLng(36.801073061564594, 2.9033831342274254),
  const mp.LatLng(36.80108049645054, 2.9035514022331768),
  const mp.LatLng(36.80550617822972, 2.9035514022331768),
const mp.LatLng(36.80663425228572, 2.903578496777385),
const mp.LatLng(36.80664546507657, 2.903586001084136),
const mp.LatLng(36.80565768721273, 2.901844315922716),
const mp.LatLng(36.805685345260116, 2.901987704986169),
const mp.LatLng(36.80469755501163, 2.8979963431563647),
const mp.LatLng(36.80516239906888, 2.8944766877235395),
const mp.LatLng(36.803332059274766, 2.8934969898205907),
const mp.LatLng(36.799264480881405, 2.8969803601444255),
const mp.LatLng(36.79914826118103, 2.9002097347168387),
const mp.LatLng(36.79426687454149, 2.898286624016805),
const mp.LatLng(36.79095432787571, 2.8994840325653115),
const mp.LatLng(36.79092175320581, 2.8994332407825425),
const mp.LatLng(36.79045682271581, 2.898235832234036),
const mp.LatLng(36.78929448414718, 2.8980544066963887),
const mp.LatLng(36.78859707254196, 2.89711099390027),
const mp.LatLng(36.78766718052782, 2.89711099390027),
const mp.LatLng(36.78696975411063, 2.8951515980922977),
const mp.LatLng(36.78569112252525, 2.8943170406190006),
const mp.LatLng(36.78531334092851, 2.895042742769533),
const mp.LatLng(36.78080887840571, 2.8923576448109998),
const mp.LatLng(36.780808777447646, 2.892439266016453),
const mp.LatLng(36.7783675387478, 2.8893550318747714),
const mp.LatLng(36.774502085122805, 2.884891963646936),
const mp.LatLng(36.773601086717974, 2.8847105381082656),
const mp.LatLng(36.76889247117991, 2.8791226315467213),
const mp.LatLng(36.76885672768384, 2.8791226296231685),
const mp.LatLng(36.76345018034857, 2.8697973569832413),
const mp.LatLng(36.76144442876023, 2.8632660376245838),
const mp.LatLng(36.76010723189327, 2.8585852587511624),
const mp.LatLng(36.76129908240405, 2.856771003373865),
const mp.LatLng(36.7612700492582, 2.8568435850664002),
const mp.LatLng(36.76065959132292, 2.852416801945452),
const mp.LatLng(36.761531672600555, 2.8516185295791274),
const mp.LatLng(36.760688660858904, 2.8508565423206846),
const mp.LatLng(36.76103749442716, 2.8490060018353915),
const mp.LatLng(36.76240374396137, 2.8482802996849728),
const mp.LatLng(36.76336301100619, 2.8503848359226254),
const mp.LatLng(36.765601254115396, 2.848352869899827),
const mp.LatLng(36.765601254115396, 2.8451234953284654),
const mp.LatLng(36.764554810922505, 2.841712695219428),
const mp.LatLng(36.76202584758896, 2.8373584823132774),
const mp.LatLng(36.761066563819924, 2.838301895109396),
const mp.LatLng(36.76150260338409, 2.839862154734192),
const mp.LatLng(36.76042703464094, 2.8410595632826983),
const mp.LatLng(36.75967122055488, 2.840406431347077),
const mp.LatLng(36.75967122055488, 2.841785265434254),
const mp.LatLng(36.755892038407055, 2.8449783548976484),
const mp.LatLng(36.752723196026395, 2.845849197478856),
const mp.LatLng(36.75277368982697, 2.845844981685957),
const mp.LatLng(36.75076270374581, 2.8455182851104723),
const mp.LatLng(36.75067862169571, 2.843524442552308),
const mp.LatLng(36.74929125457112, 2.8427373994379366),
const mp.LatLng(36.74802998996222, 2.843524442552308),
const mp.LatLng(36.7477777345523, 2.8453084069472823),
const mp.LatLng(36.746306228135666, 2.845465815568957),
const mp.LatLng(36.74575966142264, 2.8442590161266423),
const mp.LatLng(36.74084038582896, 2.8422127040283556),
const mp.LatLng(36.739999452462484, 2.842684929897871),
const mp.LatLng(36.739873288461894, 2.8426849319242535),
const mp.LatLng(36.74008352301283, 2.8420552974330917),
const mp.LatLng(36.73920053402884, 2.841215784777148),
const mp.LatLng(36.738822107069225, 2.842370114677948),
const mp.LatLng(36.73705608992242, 2.841530602021976),
const mp.LatLng(36.73705608992242, 2.8403762721212047),
const mp.LatLng(36.73524798265595, 2.839274411760499),
const mp.LatLng(36.734701337191865, 2.8401139244164426),
const mp.LatLng(36.73015982438591, 2.8368083433342974),
const mp.LatLng(36.73037008553885, 2.835496604808867),
const mp.LatLng(36.72763664563942, 2.8334502927106087),
const mp.LatLng(36.727700399029075, 2.8333978530741035),
const mp.LatLng(36.72571175787266, 2.831673658127812),
const mp.LatLng(36.72523986936076, 2.832430621762768),
const mp.LatLng(36.7242286699278, 2.832430621762768),
const mp.LatLng(36.718060065074596, 2.8264590197520647),
const mp.LatLng(36.717043484052226, 2.827472932739937),
const mp.LatLng(36.716727492805816, 2.8275594683729537),

  ];
   final babezawarePolygon = <mp.LatLng>[
  const mp.LatLng(36.77381502315288, 3.0639569976538894),
  const mp.LatLng(36.77168852528291, 3.0536820220836205),
  const mp.LatLng(36.76064767528645, 3.0503843252527076),
  const mp.LatLng(36.76075029352626, 3.0504027641021025),
  const mp.LatLng(36.759592680019765, 3.0517070499659837),
  const mp.LatLng(36.7613342158339, 3.0563615603063283),
  const mp.LatLng(36.76121128519162, 3.0565277928180876),
  const mp.LatLng(36.75922387912614, 3.055504823511825),
  const mp.LatLng(36.75844529363981, 3.055747778722292),
  const mp.LatLng(36.75205599998989, 3.062840555253871),
  const mp.LatLng(36.75210212686156, 3.0627793602400573),
  const mp.LatLng(36.75160523934734, 3.062754554141577),
  const mp.LatLng(36.75083008840001, 3.064838266389387),
  const mp.LatLng(36.74633803385953, 3.0642677261305096),
  const mp.LatLng(36.7444298249202, 3.0697250677331738),
  const mp.LatLng(36.7423765135899, 3.071903754852741),
  const mp.LatLng(36.74263500113534, 3.071721309918047),
  const mp.LatLng(36.73580180992572, 3.075451839677868),
  const mp.LatLng(36.73630655508255, 3.0700740630114183),
  const mp.LatLng(36.73553002269725, 3.064114905084381),
  const mp.LatLng(36.73257912799781, 3.054715908027134),
  const mp.LatLng(36.732593607495815, 3.054724966008365),
  const mp.LatLng(36.73116417320428, 3.0547549420704456),
  const mp.LatLng(36.73031130477435, 3.0560738888260914),
  const mp.LatLng(36.731212221847855, 3.0562237691390806),
  const mp.LatLng(36.73170471871224, 3.056898230547489),
  const mp.LatLng(36.73095996613286, 3.059056507055999),
  const mp.LatLng(36.73095995998382, 3.0590415169246796),
  const mp.LatLng(36.728365281670975, 3.0618592668101883),
  const mp.LatLng(36.72438900728231, 3.064826897008629),
  const mp.LatLng(36.723319096510366, 3.0654714923165614),
  const mp.LatLng(36.72272926350169, 3.063325037757636),
  const mp.LatLng(36.724253024996, 3.05731522009512),
  const mp.LatLng(36.72371233889429, 3.054371635933677),
  const mp.LatLng(36.71855105270326, 3.0568246227348936),
  const mp.LatLng(36.718609781814536, 3.0567973330349503),
  const mp.LatLng(36.7034522359631, 3.0714305274798903),
  const mp.LatLng(36.70344479687384, 3.0714273864861354),
  const mp.LatLng(36.689370375481744, 3.079131703924986),
  const mp.LatLng(36.68944210305314, 3.0791304175742766),
  const mp.LatLng(36.66874099467262, 3.0883960447519314),
  const mp.LatLng(36.668870570943525, 3.088267279193701),
  const mp.LatLng(36.66564159670335, 3.0907900339895775),
  const mp.LatLng(36.66599456997102, 3.0904170250294953),
  const mp.LatLng(36.66163336017192, 3.105128262136674),
  const mp.LatLng(36.66168631790897, 3.1049738787807826),
  const mp.LatLng(36.661688057435256, 3.106924020779047),
  const mp.LatLng(36.66169108219388, 3.1069184861380563),
  const mp.LatLng(36.66338611372454, 3.120184420957969),
  const mp.LatLng(36.664277893765885, 3.128498605644751),
  const mp.LatLng(36.667778041035945, 3.127321365753801),
  const mp.LatLng(36.66781289265528, 3.136641411953633),
  const mp.LatLng(36.657875631656864, 3.137945774573268),
  const mp.LatLng(36.65926874349951, 3.1455909880295394),
  const mp.LatLng(36.65291819894286, 3.1469461272855312),
  const mp.LatLng(36.652932156051165, 3.146976547421758),
  const mp.LatLng(36.64903589375669, 3.1429271601764697),
  const mp.LatLng(36.64686486417989, 3.151299035942742),
  const mp.LatLng(36.6455607470848, 3.159052742070145),
  const mp.LatLng(36.646207339672756, 3.1639452509257637),
  const mp.LatLng(36.64774756254367, 3.1692550744574817),
  const mp.LatLng(36.645038017229226, 3.178874371176846),
  const mp.LatLng(36.644189534588094, 3.1782355938490525),
  const mp.LatLng(36.63848986477454, 3.2071523911262148),
  const mp.LatLng(36.64643310932348, 3.2383978584194892),
  const mp.LatLng(36.6539943630749, 3.249230552518327),
  const mp.LatLng(36.65909433236567, 3.2671756692715803),
  const mp.LatLng(36.664226831193744, 3.286354955368097),
  const mp.LatLng(36.67739672219318, 3.302941428033307),
  const mp.LatLng(36.72181127870017, 3.2541395547584955),
  const mp.LatLng(36.721659984964305, 3.254470294476704),
  const mp.LatLng(36.71648893856256, 3.28520401925536),
  const mp.LatLng(36.73745874993459, 3.2843783917618055),
  const mp.LatLng(36.73285648909906, 3.2496582864910977),
  const mp.LatLng(36.733099328916424, 3.250061102002519),
  const mp.LatLng(36.74305140683835, 3.2542498980036214),
  const mp.LatLng(36.761843765647, 3.249783976768839),
  const mp.LatLng(36.76441631699416, 3.26849337535819),
  const mp.LatLng(36.77212703757648, 3.2682067490507904),
  const mp.LatLng(36.77651012094084, 3.226875018532297),
  const mp.LatLng(36.77449567277587, 3.228691335469364),
  const mp.LatLng(36.76767053105981, 3.221285326141839),
  const mp.LatLng(36.7663280184169, 3.2156957261096863),
  const mp.LatLng(36.76420157783235, 3.2162541843007375),
  const mp.LatLng(36.75871587560171, 3.2041035723944162),
  const mp.LatLng(36.75088077780444, 3.190139064493792),
  const mp.LatLng(36.751124587043876, 3.190623473677533),
  const mp.LatLng(36.74281288194379, 3.1463269912559326),
  const mp.LatLng(36.74528519454368, 3.107350976245243),
  const mp.LatLng(36.75224997075762, 3.0815530961296247),
  const mp.LatLng(36.76236244065356, 3.0717357106590555),
  const mp.LatLng(36.76370919511953, 3.0652871595379168),
  const mp.LatLng(36.7738194981668, 3.0678095933066345),
  const mp.LatLng(36.77357814873679, 3.063899617887671),
  const mp.LatLng(36.77381502315288, 3.0639569976538894),
  ];
   if (mp.PolygonUtil.containsLocation(userLocation, dangerZoneChragaPolygon, true)) {
      return false;
    }
 if (mp.PolygonUtil.containsLocation(userLocation, chragaPolygon, true)) {
      return true;
    }
    if (mp.PolygonUtil.containsLocation(userLocation, babezawarePolygon, true)) {
      return true;
    }
  return false;
}
/*   Future<bool> isWithinOneKilometer() async {
    // Position currentPosition = await Geolocator.getCurrentPosition();

    double chragaDistanceInMeters = Geolocator.distanceBetween(
      lati!,
      langi!,
      36.7554271,
      2.9514455,
    );
    double babezawareDistanceInMeters = Geolocator.distanceBetween(
      lati!,
      langi!,
      36.7147726,
      3.1892265,
    );
    if (chragaDistanceInMeters <= 14000) {
      return true;
    }
    if (babezawareDistanceInMeters <= 14000) {
      return true;
    }
    return false;
  } */

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

/*   @override
  goToPageLocation(BuildContext context, HomeViewModel homeViewModel) async {
    var status = await Permission.location.status;

    if (status.isGranted || status.isLimited) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LocationScreen(
                homeViewModel: homeViewModel,
              )));
    } else if (status.isDenied) {
      var result = await Permission.location.request();

      if (result.isGranted || status.isLimited) {
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
    } else if (status.isPermanentlyDenied) {
    } else {
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
  } */
 @override
goToPageLocation(BuildContext context, HomeViewModel homeViewModel) async {


  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorManager.reed,
        duration: const Duration(seconds: 3),
        content: Text(
          "يجب السماح للتطبيق بالوصول إلى نظام GPS",
          style: getSemiBoldStyle(14, ColorManager.white, ""),
        ),
      ));
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ColorManager.reed,
      duration: const Duration(seconds: 3),
      content: Text(
        "تم رفض صلاحية الموقع بشكل دائم. يرجى تفعيلها من إعدادات التطبيق.",
        style: getSemiBoldStyle(14, ColorManager.white, ""),
      ),
    ));
    await Geolocator.openAppSettings();
    return;
  }

 
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => LocationScreen(homeViewModel: homeViewModel),
  ));
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
