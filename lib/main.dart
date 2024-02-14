import 'package:chatify/app/constants/text_theme.dart';
import 'package:chatify/app/modules/home/views/home_view.dart';
import 'package:chatify/app/modules/login/controllers/login_controller.dart';
import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
import 'package:chatify/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print("Firebase initialization error: $e");
    // Handle initialization error, e.g., show an error message and exit the app.
    return;
  }

  // Initialize LoginController
  Get.put(LoginController());

  runApp(
    GetMaterialApp(
      theme: theme,
      title: "Chatify",
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for connection");
            return CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            print("User is logged in: ${snapshot.data}");
            return const HomeView();
          } else {
            print("User is not logged in");
            return LoginView();
          }
        },
      ),
    ),
  );
}


//  Widget weatherContainer(context) {
//     return Container(
//       margin: const EdgeInsets.all(15),
//       padding: const EdgeInsets.all(10),
//       color: Colors.black26,
//       width: 120,
//       height: 150,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.sunny,color: Colors.white,),
//                 const Spacer(),
//                 Text(controller.temperature.value.toStringAsFixed(2),style: TextStyle(color: AppTheme.whiteFFFFFF),)
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.wind_power,color: Colors.white,),
//                 const Spacer(),
//                 Text(controller.windSpeed.value.toStringAsFixed(2),style: TextStyle(color: AppTheme.whiteFFFFFF),)
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.cloud,color: Colors.white,),
//                 const Spacer(),
//                 Text(controller.clouds.value.toString(),style: TextStyle(color: AppTheme.whiteFFFFFF),)
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }


//import 'dart:async';
// import 'dart:convert';
//
// import 'package:eye_sea/app/modules/home/controllers/home_controller.dart';
// import 'package:eye_sea/app/modules/map/model/weather_data.dart';
// import 'package:eye_sea/app/services/EyeSeaCommen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../../data/model/attachment_display_model.dart';
// import '../../../data/model/fetchTrashv2RequestModel.dart';
// import '../../../data/model/filter_request_model.dart';
// import '../../../data/repository/eyeSea_repository.dart';
// import '../../../routes/app_pages.dart';
// import '../../../services/APIService.dart';
// import '../../AppConstants.dart';
// import '../../common widgets/common_widget.dart';
// import '../model/MapMarker.dart';
// import 'package:vector_map_tiles/vector_map_tiles.dart' as vector;
// import 'package:vector_tile_renderer/vector_tile_renderer.dart' hide TileLayer;
// import '../model/trash_category_model.dart';
// import '../model/trash_details_model.dart';
// import 'package:intl/intl.dart';
//
// class MapBoxController extends GetxController with GetTickerProviderStateMixin {
//   final EyeSeaRepository repository;
//   MapBoxController({required this.repository});
//   RxList<FilterDisplayModel> filterData = <FilterDisplayModel>[].obs;
//   RxList<FilterDisplayModel> tmp_filterData = <FilterDisplayModel>[].obs;
//   RxList<TrashDetailsModel> trashDetails = <TrashDetailsModel>[].obs;
//   var lang = AppConstants.myCurrentLocationLat.obs;
//   var long = AppConstants.myCurrentLocationLan.obs;
//   final count = 0.obs;
//   final MapController mapController = MapController();
//   final pageController = PageController();
//   var infoWindowVisible = false;
//   final List<Marker> mMarkers = List.empty(growable: true);
//   var recoverItemBool = 0.obs;
//   Timer? movementTimer;
//   var tmp_recoverItemBool = 0.obs;
//   var top100bool = false.obs;
//   int pageViewHeight = 0;
//   RxList<MapMarker> mapMarkers = <MapMarker>[].obs;
//   List<MapMarker> mapMarkersTemp = List.empty(growable: true);
//   List<MapMarker> mapMarkersTempWithRecoveredList = List.empty(growable: true);
//   RxList<TrashCategoryModel> categoryList = <TrashCategoryModel>[].obs;
//   var tabIndex = 0;
//   var northEast = LatLng(0.0, 0.0).obs;
//   var southWest = LatLng(0.0, 0.0).obs;
//   var southEast = LatLng(0.0, 0.0).obs;
//   var northWest = LatLng(0.0, 0.0).obs;
//   int selectedIndex = 0;
//   var currentLocation =
//       LatLng(AppConstants.myLocationLat, AppConstants.myLocationLan);
//   //var filterEnabled = false.obs;
//   var filterDataLength = 0.obs;
//   var isDoneTrashPage = false.obs;
//   var sliderButtonShow = true.obs;
//   var directory = "".obs;
//   var filterButtonShow = true.obs;
//   var fromTrashDetailsPage = false.obs;
//   var toTrashMapIndex = 0;
//   var marker = MapMarker(
//           image: "",
//           imageURL: "",
//           title: "",
//           address: "",
//           location: LatLng(0, 0),
//           rating: 0,
//           isMytrash: true,
//           isRecovered: false,
//           recoveredDate: "",
//           categoryId: 0,
//           reportedDate: "",
//           userName: "",
//           showLocation: "",
//           transactionId: 0,
//           imagepath: "")
//       .obs;
//   int fromReportTrash = 0;
//   var zoom = 13.obs;
//   vector.Style? style = AppConstants.style;
//   var searchTextVisibility = false.obs;
//   //var recoveredItemCount = 0.obs;
//   var isLoading = false.obs;
//   Object? _error;
//   var isShowPopup = false.obs;
//   var filterIconShow = false.obs;
//   var tempIndexForBtmTabChange = 0;
//   var clouds = 0.obs;
//   RxDouble temperature = 0.0.obs;
//   RxDouble windSpeed = 0.0.obs;
//
//
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     // _initStyle();
//     var dir = await getApplicationDocumentsDirectory();
//     directory.value = "${dir.path}/attachments";
//     //offlineMap();
//     myTrashTabChange(tabIndex, false);
//     mapInit();
//     filterDataFetch();
//     print("RRRR onit function");
//   }
//
//   void _initStyle() async {
//     try {
//       style = await _readStyle();
//     } catch (e, stack) {
//       // ignore: avoid_print
//       print(e);
//       // ignore: avoid_print
//       print(stack);
//       _error = e;
//     }
//   }
//
//   Future<vector.Style> _readStyle() => vector.StyleReader(
//           uri:
//               'mapbox://styles/msuteu/cllnjn3u5001f01pe07y3e03b?access_token=pk.eyJ1IjoibXN1dGV1IiwiYSI6ImNsNjBtcmZtaDAxdWIzZXAzaXh2MWpjNnoifQ.L5xob1M0ve9CSDs_Upje-A',
//           // ignore: undefined_identifier
//           apiKey:
//               "pk.eyJ1IjoibXN1dGV1IiwiYSI6ImNsNjBtcmZtaDAxdWIzZXAzaXh2MWpjNnoifQ.L5xob1M0ve9CSDs_Upje-A",
//           // apiKey: "access_token=pk.eyJ1IjoibXN1dGV1IiwiYSI6ImNsNjBtcmZtaDAxdWIzZXAzaXh2MWpjNnoifQ.L5xob1M0ve9CSDs_Upje-A%22",
//           logger: Logger.console())
//       .read();
//
//   @override
//   Future<void> onReady() async {
//     super.onReady();
//     print("RRRR on ready function");
//     await getPosition();
//     isDoneTrashPage.listen((p0) async {
//       if (p0) {
//         print("RRRR ready function");
//         findAndLoadLastTrash();
//         isDoneTrashPage.value = false;
//       }
//     });
//   }
//
//   void startMovementTimer() {
//     print("timer called");
//     // Cancel the previous timer
//     movementTimer?.cancel();
//
//     // Start a new timer for 500 milliseconds (adjust the duration as needed)
//     movementTimer = Timer(Duration(milliseconds: 500), () {
//       // Call getFourCorners when movement has stopped
//       getFourCorners();
//     });
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   getMarkers() {
//     mMarkers.clear();
//     // getFourCorners();
//     mMarkers.add(Marker(
//       key: const Key("location"),
//       height: 40,
//       width: 40,
//       point: LatLng(lang.value, long.value),
//       builder: (ctx) =>
//           Container(child: Image.asset('assets/images/bluedot.gif')),
//     ));
//     for (int i = 0; i < mapMarkers.length; i++) {
//       mMarkers.add(Marker(
//         key: UniqueKey(),
//         height: 40,
//         width: 40,
//         point: mapMarkers[i].location ??
//             LatLng(AppConstants.myLocationLan, AppConstants.myLocationLan),
//         builder: (_) {
//           return GestureDetector(
//             onTap: () {
//               pageController.animateToPage(
//                 i,
//                 duration: const Duration(milliseconds: 400),
//                 curve: Curves.easeInOut,
//               );
//               selectedIndex = i;
//               currentLocation = mapMarkers[i].location ??
//                   LatLng(
//                       AppConstants.myLocationLat, AppConstants.myLocationLan);
//               // animatedMapMove(currentLocation, 13);
//             },
//             child: AnimatedScale(
//               duration: const Duration(milliseconds: 500),
//               scale: selectedIndex == i ? 1 : 0.7,
//               child: AnimatedOpacity(
//                 duration: const Duration(milliseconds: 500),
//                 opacity: selectedIndex == i ? 1 : 0.5,
//                 child: SvgPicture.asset(
//                   mapMarkers[i].isRecovered!
//                       ? 'assets/icons/recovered_map_marker.svg'
//                       : 'assets/icons/map_marker.svg',
//                 ),
//               ),
//             ),
//           );
//         },
//       ));
//
//       pageController.animateToPage(
//         0,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//     return mMarkers;
//   }
//
//   // API call to calculate weather
//   Future<Map<String, dynamic>> calculateWeather(double lat, double lng) async {
//     const API = "b7e9010beabd8a74c0f3959dd7660bd1";
//     final String apiUrl =
//         'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lng&appid=$API';
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final List<dynamic> weatherList = jsonResponse['list'];
//         WeatherData weatherData = WeatherData.fromJson(weatherList[0]);
//         return {
//           'status': 1,
//           'DateTime': weatherData.dateTime,
//           'Temperature': weatherData.temperature - 273.15,
//           'Wind Speed': weatherData.windSpeed,
//           'Clouds': weatherData.clouds,
//         };
//       } else {
//         print('Error: ${response.statusCode}');
//         return {'status': 0};
//       }
//     } catch (error) {
//       print('Error: $error');
//       return {'status': 0};
//     }
//   }
//
//   void increment() => count.value++;
//
//   void animatedMapMove(LatLng destLocation, double destZoom) {
//     // getFourCorners();
//     // startMovementTimer();
//     final latTween = Tween<double>(
//         begin: mapController.center.latitude, end: destLocation.latitude);
//     final lngTween = Tween<double>(
//         begin: mapController.center.longitude, end: destLocation.longitude);
//     final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
//
//     // Create a animation controller that has a duration and a TickerProvider.
//     var mAnimationController = AnimationController(
//         duration: const Duration(milliseconds: 1300), vsync: this);
//     // The animation determines what path the animation will take. You can try different Curves values, although I found
//     // fastOutSlowIn to be my favorite.
//     Animation<double> animation = CurvedAnimation(
//         parent: mAnimationController, curve: Curves.fastOutSlowIn);
//
//     mAnimationController.addListener(() {
//       mapController.move(
//         LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
//         zoomTween.evaluate(animation),
//       );
//     });
//
//     animation.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         mAnimationController.dispose();
//       } else if (status == AnimationStatus.dismissed) {
//         mAnimationController.dispose();
//       }
//     });
//
//     mAnimationController.forward();
//     startMovementTimer();
//     // getFourCorners();
//   }
//
//   void updateWeather(position) async{
//     final response = await calculateWeather(
//         position.latitude, position.longitude);
//
//     temperature.value = response['Temperature'];
//     windSpeed.value = response['Wind Speed'];
//     clouds.value = response['Clouds'];
//   }
//
//   getFourCorners() {
//     if (tabIndex == 1) {
//       searchTextVisibility.value = true;
//     } else {
//       searchTextVisibility.value = false;
//     }
//     print("Current Zoom Level: ${mapController.zoom}");
//     print("Current Center Point: ${mapController.center}");
//     // Get the bounds of the visible map area
//     var bounds = mapController.bounds;
//
//     // Function to update the weather in the UI
//     updateWeather(mapController.center);
//
//     // Get the four corners of the map in LatLng coordinates
//     northEast.value = bounds!.northEast;
//     southWest.value = bounds!.southWest;
//     southEast.value = bounds!.southEast;
//     northWest.value = bounds!.northWest;
//     print("NE : ${northEast.value.latitude}\n${northEast.value.longitude}");
//     print("SW : ${southWest.value.latitude}\n${southWest.value.longitude}");
//     print("SE : ${southEast.value.latitude}\n${southEast.value.longitude}");
//     print("NW : ${northWest.value.latitude}\n${northWest.value.longitude}");
//   }
//
//   Future<void> mapInit() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permissions are denied');
//       } else if (permission == LocationPermission.deniedForever) {
//         print("'Location permissions are permanently denied");
//       }
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       long.value = position.longitude;
//       lang.value = position.latitude;
//       AppConstants.myCurrentLocationLat = lang.value;
//       AppConstants.myCurrentLocationLan = long.value;
//       AppConstants.myLocationLat = lang.value;
//       AppConstants.myLocationLan = long.value;
//     } else {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       long.value = position.longitude;
//       lang.value = position.latitude;
//       AppConstants.myCurrentLocationLat = lang.value;
//       AppConstants.myCurrentLocationLan = long.value;
//       AppConstants.myLocationLat = lang.value;
//       AppConstants.myLocationLan = long.value;
//     }
//   }
//
//   void getCurrentPosition() async {
//     // isLoading.value = true;
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permissions are denied');
//       } else if (permission == LocationPermission.deniedForever) {
//         print("'Location permissions are permanently denied");
//       }
//       Loader("Fetching Location...");
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       long.value = position.longitude;
//       lang.value = position.latitude;
//       AppConstants.myCurrentLocationLat = position.latitude;
//       AppConstants.myCurrentLocationLan = position.longitude;
//       AppConstants.myLocationLat = position.latitude;
//       AppConstants.myLocationLan = position.longitude;
//
//       /*for (var element in mMarkers) {
//         var key = ValueKey("location");
//         if(element.key == key) {
//           element.point.latitude = position.longitude;
//           element.point.longitude = position.latitude;
//           currentLocation = AppConstants.myLocation;
//           animatedMapMove(currentLocation, 13);
//         }
//       }*/
//       mMarkers.insert(
//           0,
//           Marker(
//             height: 40,
//             width: 40,
//             point: LatLng(lang.value, long.value),
//             builder: (ctx) =>
//                 Container(child: Image.asset('assets/images/bluedot.gif')),
//           ));
//       currentLocation =
//           LatLng(AppConstants.myLocationLat, AppConstants.myLocationLan);
//       animatedMapMove(currentLocation, 13);
//       print("on denied Latvalue ${lang.value} Longvalue ${long.value}");
//       Get.back();
//     } else {
//       Loader("Fetching Location...");
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       long.value = position.longitude;
//       lang.value = position.latitude;
//       AppConstants.myCurrentLocationLat = position.latitude;
//       AppConstants.myCurrentLocationLan = position.longitude;
//       AppConstants.myLocationLat = position.latitude;
//       AppConstants.myLocationLan = position.longitude;
//       /*for (var element in mMarkers) {
//         var key = ValueKey("location");
//         if(element.key == key) {
//           element.point.latitude = position.longitude;
//           element.point.longitude = position.latitude;
//           currentLocation = AppConstants.myLocation;
//           animatedMapMove(currentLocation, 13);
//         }
//       }*/
//       mMarkers.insert(
//           0,
//           Marker(
//             height: 40,
//             width: 40,
//             point: LatLng(lang.value, long.value),
//             builder: (ctx) =>
//                 Container(child: Image.asset('assets/images/bluedot.gif')),
//           ));
//       currentLocation =
//           LatLng(AppConstants.myLocationLat, AppConstants.myLocationLan);
//       animatedMapMove(currentLocation, 13);
//       print("on granted Latvalue ${lang.value} Longvalue ${long.value}");
//       Get.back();
//     }
//     // isLoading.value = false;
//   }
//
//   Future<void> getPosition() async {
//     // isLoading.value = true;
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permissions are denied');
//       } else if (permission == LocationPermission.deniedForever) {
//         print("'Location permissions are permanently denied");
//       }
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       long.value = position.longitude;
//       lang.value = position.latitude;
//       AppConstants.myCurrentLocationLat = position.latitude;
//       AppConstants.myCurrentLocationLan = position.longitude;
//       AppConstants.myLocationLat = position.latitude;
//       AppConstants.myLocationLan = position.longitude;
//       /*for (var element in mMarkers) {
//         var key = ValueKey("location");
//         if(element.key == key) {
//           element.point.latitude = position.longitude;
//           element.point.longitude = position.latitude;
//           currentLocation = AppConstants.myLocation;
//           animatedMapMove(currentLocation, 13);
//         }
//       }*/
//       mMarkers.insert(
//           0,
//           Marker(
//             height: 40,
//             width: 40,
//             point: LatLng(lang.value, long.value),
//             builder: (ctx) =>
//                 Container(child: Image.asset('assets/images/bluedot.gif')),
//           ));
//       currentLocation =
//           LatLng(AppConstants.myLocationLat, AppConstants.myLocationLan);
//       print("on denied Latvalue ${lang.value} Longvalue ${long.value}");
//     } else {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       long.value = position.longitude;
//       lang.value = position.latitude;
//       AppConstants.myCurrentLocationLat = position.latitude;
//       AppConstants.myCurrentLocationLan = position.longitude;
//       AppConstants.myLocationLat = position.latitude;
//       AppConstants.myLocationLan = position.longitude;
//       /*for (var element in mMarkers) {
//         var key = ValueKey("location");
//         if(element.key == key) {
//           element.point.latitude = position.longitude;
//           element.point.longitude = position.latitude;
//           currentLocation = AppConstants.myLocation;
//           animatedMapMove(currentLocation, 13);
//         }
//       }*/
//       mMarkers.insert(
//           0,
//           Marker(
//             height: 40,
//             width: 40,
//             point: LatLng(lang.value, long.value),
//             builder: (ctx) =>
//                 Container(child: Image.asset('assets/images/bluedot.gif')),
//           ));
//       currentLocation =
//           LatLng(AppConstants.myLocationLat, AppConstants.myLocationLan);
//       print("on granted Latvalue ${lang.value} Longvalue ${long.value}");
//     }
//     // isLoading.value = false;
//   }
//
//   void Loader(String text) {
//     Get.dialog(
//         WillPopScope(
//             child: Center(
//               child: Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: DefaultTextStyle(
//                         style: TextStyle(),
//                         child: Text(text),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             onWillPop: () {
//               return Future(() => false);
//             }),
//         barrierDismissible: false);
//   }
//
//   filterDataFetch() async {
//     categoryList.value = await repository.fetchAllTrashCategoryList();
//     //categoryList.value =  await repository.fetchFilteredCategoryDetails();
//     //recoveredItemCount.value = await repository.fetchRecoveredItemCount();
//     // var dataFrom = await repository.fetchRecoveredItemCount() ?? "0";
//     //recoveredItemCount.value = int.parse(dataFrom);
//     // print("RRR recoveredItemCount ::: "+recoveredItemCount.value.toString());
//     categoryList.value.forEach((element) {
//       filterData.add(FilterDisplayModel(
//           id: element.id,
//           iconPath: element.iconPath,
//           categoryName: element.categoryName,
//           isSelected: false));
//     });
//     List<FilterDisplayModel> tmpFilter = [];
//     filterData.value.forEach((element) {
//       tmpFilter.add(new FilterDisplayModel(
//           id: element.id,
//           iconPath: element.iconPath,
//           categoryName: element.categoryName,
//           isSelected: element.isSelected));
//     });
//     tmp_filterData.value = tmpFilter.toList();
//   }
//
//   void recoverItemSelection() {
//     if (tmp_recoverItemBool.value == 0) {
//       tmp_recoverItemBool.value = 1;
//     } else {
//       tmp_recoverItemBool.value = 0;
//     }
//   }
//
//   void top100ItemSelection() {
//     if (top100bool.value) {
//       top100bool.value = false;
//     } else {
//       top100bool.value = true;
//     }
//   }
//
//   void filtercloseButtonAction() {
//     List<FilterDisplayModel> tmpFilter = [];
//     filterData.value.forEach((element) {
//       tmpFilter.add(new FilterDisplayModel(
//           id: element.id,
//           iconPath: element.iconPath,
//           categoryName: element.categoryName,
//           isSelected: element.isSelected));
//     });
//     tmp_filterData.value = tmpFilter.toList();
//     tmp_recoverItemBool.value = recoverItemBool.value;
//   }
//
//   void filterDataSelection(int? id) {
//     for (var i = 0; i < tmp_filterData.value.length; i++) {
//       if (tmp_filterData.value[i].id == id) {
//         if (tmp_filterData.value[i].isSelected == true) {
//           tmp_filterData.value[i].isSelected = false;
//         } else {
//           tmp_filterData.value[i].isSelected = true;
//         }
//       }
//     }
//     tmp_filterData.refresh();
//   }
//
//   myTrashTabChange(int trashIndex, bool fromTab) async {
//     searchTextVisibility.value = false;
//     var bounds = mapController.bounds;
//
//     // Get the four corners of the map in LatLng coordinates
//     northEast.value = bounds!.northEast;
//     southWest.value = bounds!.southWest;
//     southEast.value = bounds!.southEast;
//     northWest.value = bounds!.northWest;
//     await Get.find<HomeController>().fetchTrashV2(
//         zoom: mapController.zoom,
//         NeLat: northEast.value.latitude,
//         NeLon: northEast.value.longitude,
//         NwLon: northWest.value.longitude,
//         NwLat: northWest.value.latitude,
//         SeLat: southEast.value.latitude,
//         SeLon: southEast.value.longitude,
//         SwLat: southWest.value.latitude,
//         SwLon: southWest.value.longitude);
//     //print("WWW tab index ::: "+trashIndex.toString()+"::: from tab "+fromTab.toString());
//     long.value = AppConstants.myCurrentLocationLan;
//     lang.value = AppConstants.myCurrentLocationLat;
//     if (fromTab) {
//       filterDataLength.value = 0;
//       categoryList.length = 0;
//       filterData.length = 0;
//       recoverItemBool.value = 0;
//       tmp_recoverItemBool.value = 0;
//       tempIndexForBtmTabChange = trashIndex;
//       await filterDataFetch();
//     } else {
//       print("PPP ::: inside else");
//       //this is for if bottom tab changes and came back to this window my trash will call default need to change
//       trashIndex = tempIndexForBtmTabChange;
//       //print("WWW tab index else inside::: "+trashIndex.toString()+"::: from tab "+fromTab.toString());
//     }
//     //var dataFrom = await repository.fetchRecoveredItemCount() ?? "0";  //for show and hide
//     //recoveredItemCount.value = int.parse(dataFrom);
//     //print("RRR recoveredItemCount RRR ::: "+recoveredItemCount.value.toString());
//
//     trashDetails.value = await repository.fetchTrashDetails();
//     tabIndex = trashIndex;
//     mapMarkers.clear();
//     print("YYY myTrashTabChange called");
//     if (trashIndex == 0) {
//       trashDetails.value.forEach((element) {
//         if (element.isMyTrash!) {
//           mapMarkers.add(MapMarker(
//               image: element.filename,
//               imageURL: element.imageURL,
//               title: element.remarks,
//               address: "",
//               location:
//                   LatLng(element.latitude ?? 0.0, element.longitude ?? 0.0),
//               rating: 0,
//               isMytrash: element.isMyTrash,
//               isRecovered: element.isRecovered,
//               recoveredDate: dateformatChanger(element.recoveredDate),
//               categoryId: element.categoryId,
//               reportedDate: dateformatChanger(element.reportedDate),
//               userName: element.userName,
//               showLocation: showLocationDisplay(
//                   element.latitude.toString(), element.longitude.toString()),
//               transactionId: element.transactionId,
//               imagepath: element.imagePath));
//         }
//       });
//     } else {
//       trashDetails.value.forEach((element) {
//         mapMarkers.add(MapMarker(
//             image: element.filename,
//             imageURL: element.imageURL,
//             title: element.remarks,
//             address: "",
//             location: LatLng(element.latitude ?? 0.0, element.longitude ?? 0.0),
//             rating: 0,
//             isMytrash: element.isMyTrash,
//             isRecovered: element.isRecovered,
//             recoveredDate: dateformatChanger(element.recoveredDate),
//             categoryId: element.categoryId,
//             reportedDate: dateformatChanger(element.reportedDate),
//             userName: element.userName,
//             showLocation: showLocationDisplay(
//                 element.latitude.toString(), element.longitude.toString()),
//             transactionId: element.transactionId,
//             imagepath: element.imagePath));
//       });
//     }
//
//     if (mapMarkers.length == 0) {
//       print("RRR mapmarker length 0");
//       sliderButtonShow.value = false;
//       filterButtonShow.value = false;
//       //await curentLocationMapMarker();
//     } else {
//       sliderButtonShow.value = true;
//       filterButtonShow.value = true;
//     }
//     mapMarkers.refresh();
//     getMarkers();
//     mapMarkers.value.length >= 1
//         ? animatedMapMove(mapMarkers[0].location!, 13)
//         : animatedMapMove(
//             LatLng(AppConstants.myCurrentLocationLat,
//                 AppConstants.myCurrentLocationLan),
//             13);
//   }
//
//   getTrashes(BuildContext context) async {
//     await fetchTrashV2(
//         zoom: mapController.zoom,
//         NeLat: northEast.value.latitude,
//         NeLon: northEast.value.longitude,
//         NwLon: northWest.value.longitude,
//         NwLat: northWest.value.latitude,
//         SeLat: southEast.value.latitude,
//         SeLon: southEast.value.longitude,
//         SwLat: southWest.value.latitude,
//         SwLon: southWest.value.longitude,
//         context: context);
//     // // await getLocationTrash();
//   }
//
//   getLocationTrash() async {
//     var bounds = mapController.bounds;
//
//     // Get the four corners of the map in LatLng coordinates
//     northEast.value = bounds!.northEast;
//     southWest.value = bounds!.southWest;
//     southEast.value = bounds!.southEast;
//     northWest.value = bounds!.northWest;
//
//     trashDetails.value = await repository.fetchTrashDetails();
//     mapMarkers.clear();
//     trashDetails.value.forEach((element) {
//       mapMarkers.add(MapMarker(
//           image: element.filename,
//           imageURL: element.imageURL,
//           title: element.remarks,
//           address: "",
//           location: LatLng(element.latitude ?? 0.0, element.longitude ?? 0.0),
//           rating: 0,
//           isMytrash: element.isMyTrash,
//           isRecovered: element.isRecovered,
//           recoveredDate: dateformatChanger(element.recoveredDate),
//           categoryId: element.categoryId,
//           reportedDate: dateformatChanger(element.reportedDate),
//           userName: element.userName,
//           showLocation: showLocationDisplay(
//               element.latitude.toString(), element.longitude.toString()),
//           transactionId: element.transactionId,
//           imagepath: element.imagePath));
//     });
//     if (mapMarkers.length == 0) {
//       print("RRR mapmarker length 0");
//       sliderButtonShow.value = false;
//       filterButtonShow.value = false;
//       //await curentLocationMapMarker();
//     } else {
//       sliderButtonShow.value = true;
//       filterButtonShow.value = true;
//     }
//     mapMarkers.refresh();
//     isLoading.value = false;
//     getMarkers();
//   }
//
//   fetchTrashV2(
//       {required double NeLat,
//       required double NwLat,
//       required double NeLon,
//       required double NwLon,
//       required double SeLat,
//       required double SwLat,
//       required double SeLon,
//       required double SwLon,
//       required double zoom,
//       required BuildContext context}) async {
//     final storage = GetStorage();
//     isLoading.value = true;
//     var id = storage.read('UserId');
//     var token = storage.read('Token');
//     var deviceId = storage.read('DeviceId');
//     var timeStamp = storage.read('TrashTimeStampv2');
//     var request = fetchTrashDetailsv2Request(
//         userId: id,
//         timestamp: timeStamp ?? "",
//         nELatitude: NeLat,
//         nELongitude: NeLon,
//         nWLatitude: NwLat,
//         nWLongitude: NwLon,
//         sELatitude: SeLat,
//         sELongitude: SeLon,
//         sWLatitude: SwLat,
//         sWLongitude: SwLon,
//         zoom: zoom);
//     repository.fetchTrashV2(request).then((value) async {
//       print(
//           'Fetch Request Success . Insert into DB ${jsonEncode(value.trashDetailsEntity)}');
//       storage.write("TrashTimeStampv2", value.commonEntity?.timeStamp);
//       if (value.trashDetailsEntity.length > 0) {
//         var trashList = value.trashDetailsEntity;
//         var attachmentList = <AttachmentDisplayModel>[];
//         /*for (var items in trashList) {
//           var response = await get(Uri.parse(items.imageUrl!));
//           var filename = basename(File(items.imageUrl!).path);
//           var documentDirectory = await getApplicationDocumentsDirectory();
//           var firstPath = documentDirectory.path + "/images";
//           var filePathAndName = documentDirectory.path + '/images/$filename';
//           if (!Directory(firstPath).existsSync()) {
//             await Directory(firstPath).create(recursive: true);
//           }
//           File file2 = new File(filePathAndName);
//           file2.writeAsBytesSync(response.bodyBytes);
//           items.imagePath = file2.path;
//         }*/
//         // await Future.delayed(Duration(seconds: 15));
//         await repository.insertTrash(trashList);
//         if (value.attachmentEntity != null) {
//           for (var items in value.attachmentEntity) {
//             String url =
//                 "${APIService.baseUrls}${APIService.getAttachments}${items.fileName}";
//             var path = await repository
//                 .getAttachmentLocalPath(items.attachmentTransactionId!);
//             var attachment = AttachmentDisplayModel(
//                 attachmentTransactionId: items.attachmentTransactionId,
//                 attachmentId: items.attachmentId,
//                 trashId: items.trashId,
//                 transactionId: items.transactionId,
//                 attachmentType: items.attachmentType,
//                 fileName: items.fileName,
//                 fileURL: url,
//                 localURL: path != "" ? path : "",
//                 isActive: items.isActive);
//             attachmentList.add(attachment);
//           }
//           await repository.insertAttachments(attachmentList);
//         }
//         // await Future.delayed(Duration(seconds: 1));
//         print("Trash Inserted");
//         // Get.find<MapBoxController>().myTrashTabChange(0, false);
//         getLocationTrash();
//         // Get.find<MapBoxController>().isLoading.value = false;
//         // isLoading.value =false;
//         print("Trash Updated");
//       } else {
//         BeautifulToast.showShortToast(context, "No Data Found...");
//
//         getLocationTrash();
//         // isLoading.value =false;
//         // Get.find<MapBoxController>().myTrashTabChange(0, false);
//         // Get.find<MapBoxController>().isLoading.value = false;
//       }
//     }, onError: (err) {
//       // Get.find<MapBoxController>().isLoading.value = false;
//       isLoading.value = false;
//       print('Fetch Request Error .$err');
//     });
//     // Get.find<MapBoxController>().isLoading.value = false;
//     // isLoading.value =false;
//   }
//
//   void saveTempFilterData() {
//     filterData.value.clear();
//     tmp_filterData.value.forEach((element) {
//       filterData.value.add(element);
//     });
//     recoverItemBool.value = tmp_recoverItemBool.value;
//     categoryFilterData();
//   }
//
//   Future<void> categoryFilterData() async {
//     List<int?> catids = List.empty(growable: true);
//     isLoading.value = true;
//     await myTrashTabChange(tabIndex, false);
//     filterDataLength.value = 0;
//     var filterApplied = false;
//     //print("RRR recoverItemBool ouside"+recoverItemBool.value.toString());
//     filterData.value.forEach((element) {
//       if (element.isSelected == true) {
//         filterApplied = true;
//         print("SSS ::: " +
//             element.categoryName.toString() +
//             ":::" +
//             element.id.toString());
//         catids.add(element.id);
//       }
//     });
//
//     print("QQQ recoverItemBool :::" + recoverItemBool.value.toString());
//     print("QQQ tab index :::" + tabIndex.toString());
//     print("QQQ catids :::" + catids.toString());
//
//     final storage = GetStorage();
//     List<TrashDetailsModel> trashFilteredList;
//     List<TrashDetailsModel1> trashFilteredList1;
//     if (top100bool.value) {
//       var userId = storage.read('UserId');
//       var timestamp = DateTime.now().toString();
//       var request = FilterRequestModel();
//       request.userId = userId;
//       request.timestamp = timestamp;
//       request.isRecovered = recoverItemBool.value == 0 ? true : false;
//       request.isTop100 = top100bool.value;
//       request.categoryIds = catids;
//
//       var response = await repository.fetchFilteredTrash(request);
//       print("In try block");
//       print("Filtered data ${json.encode(response.trashDetails)}");
//       trashFilteredList1 = response.trashDetails!;
//       Get.back();
//       if (trashFilteredList1.isNotEmpty) {
//         sliderButtonShow.value = true;
//         filterDataLength++;
//         mapMarkers.clear();
//         trashFilteredList1.forEach((element) {
//           try {
//             print("YYY  trashFilteredList :: " + element.remarks.toString());
//             mapMarkers.add(MapMarker(
//                 image: element.filename,
//                 imageURL:
//                     "${APIService.baseUrls}${APIService.getAttachments}${element.filename}",
//                 title: element.remarks,
//                 address: "",
//                 location:
//                     LatLng(element.latitude ?? 0.0, element.longitude ?? 0.0),
//                 rating: 0,
//                 isMytrash: element.isMyTrash,
//                 id: element.id,
//                 isRecovered: element.isRecovered,
//                 recoveredDate: dateformatChanger(element.recoveredDate),
//                 categoryId: element.categoryId,
//                 reportedDate: dateformatChanger(element.reportedDate),
//                 userName: element.userName,
//                 showLocation: showLocationDisplay(
//                     element.latitude.toString(), element.longitude.toString()),
//                 transactionId: element.transactionId,
//                 imagepath: element.imagePath));
//           } catch (e) {
//             print("Error is ${e}");
//           }
//         });
//         print("Map markers count ${mapMarkers.length}");
//         try {
//           animatedMapMove(mapMarkers.first.location!, 13);
//         } catch (e) {
//           isLoading.value = false;
//         }
//       } else {
//         //clearSlection();
//         sliderButtonShow.value = false;
//         mapMarkers.clear();
//         isShowPopup.value = true;
//         filterIconShow.value = true;
//         print("YYY  else mapMarkersTemp");
//       }
//     } else {
//       trashFilteredList = await repository.fetchFilteredTrashDetails(
//           catids, recoverItemBool.value, tabIndex);
//       Get.back();
//       if (trashFilteredList.isNotEmpty) {
//         sliderButtonShow.value = true;
//         filterDataLength++;
//         mapMarkers.clear();
//         trashFilteredList.forEach((element) {
//           print("YYY  trashFilteredList :: " + element.remarks.toString());
//           print("YYY  trashFilteredList :: " + element.reportedDate.toString());
//           print(
//               "YYY  trashFilteredList :: " + element.recoveredDate.toString());
//           mapMarkers.add(MapMarker(
//               image: element.filename,
//               imageURL: element.imageURL,
//               title: element.remarks,
//               address: "",
//               location:
//                   LatLng(element.latitude ?? 0.0, element.longitude ?? 0.0),
//               rating: 0,
//               isMytrash: element.isMyTrash,
//               isRecovered: element.isRecovered,
//               id: element.id,
//               recoveredDate: dateformatChanger(element.recoveredDate),
//               categoryId: element.categoryId,
//               reportedDate: dateformatChanger(element.reportedDate),
//               userName: element.userName,
//               showLocation: showLocationDisplay(
//                   element.latitude.toString(), element.longitude.toString()),
//               transactionId: element.transactionId,
//               imagepath: element.imagePath));
//         });
//         animatedMapMove(mapMarkers.first.location!, 13);
//         isLoading.value = false;
//       } else {
//         //clearSlection();
//         sliderButtonShow.value = false;
//         mapMarkers.clear();
//         isShowPopup.value = true;
//         filterIconShow.value = true;
//         print("YYY  else mapMarkersTemp");
//       }
//     }
//
//     if (catids.isEmpty && recoverItemBool.value == 0) {
//       filterDataLength.value = 0;
//     }
//
//     isLoading.value = false;
//   }
//
//   String dateformatChanger(String? dates) {
//     if (dates != null && dates != "") {
//       var dateTime = DateTime.parse(dates);
//       var validFrom = DateFormat('dd-MMM-yyyy').format(dateTime);
//       return validFrom;
//     }
//     return "";
//   }
//
//   void navigateToTrashDetailPage(MapMarker mapMarker, int index) {
//     toTrashMapIndex =
//         index; //for point to corresponding map index data after recovered
//     marker.value = mapMarker;
//     print("Map marker ${mapMarker.isRecovered}");
//     Get.toNamed(Routes.TRASH_DETAILS, arguments: [
//       mapMarker.transactionId,
//       false,
//       mapMarker.isRecovered,
//       top100bool.value,
//       mapMarker,
//       index
//     ]);
//   }
//
//   navigateToLinks() {
//     Get.toNamed(Routes.LINKS);
//   }
//
//   Future<void> clearSlection() async {
//     filterIconShow.value = false;
//     isLoading.value = true;
//     filterDataLength.value = 0;
//     categoryList.length = 0;
//     filterData.length = 0;
//     tmp_filterData.length = 0;
//     top100bool.value = false;
//     recoverItemBool.value = 0;
//     tmp_recoverItemBool.value = 0;
//     await filterDataFetch();
//     await myTrashTabChange(tabIndex, false);
//     animatedMapMove(mapMarkers.first.location!, 13);
//     isLoading.value = false;
//   }
//
//   String showLocationDisplay(String latitude, String longitude) {
//     String locationString = EyeSeaCommen.getLocationSeaferarName(
//         double.parse(latitude), double.parse(longitude));
//     // String locationString = "N $latitude , W $longitude";
//     return locationString;
//   }
//
//   findAndLoadLastTrash() async {
//     print("PPP ::: " + isDoneTrashPage.value.toString());
//     isLoading.value = true;
//     //trashDetails.value = await repository.fetchTrashDetails();
//     // await getMarkers();
//     //print("RRR Save Done find last");
//     await myTrashTabChange(tabIndex, false);
//     await Future.delayed(const Duration(seconds: 1));
//     //saveTempFilterData();
//     //var dataLength = mapMarkers.length;
//     animatedMapMove(mapMarkers.first.location!, 13);
//     // selectedIndex = dataLength;
//     // if(fromTrashDetailsPage.value){
//     //  // print("RRR toTrashMapIndex  ::: $toTrashMapIndex");
//     //   selectedIndex = toTrashMapIndex;
//     // }
//     // //print("RRR selectedIndex  ::: $selectedIndex");
//     // pageController.animateToPage(
//     //   selectedIndex,
//     //   duration: const Duration(milliseconds: 400),
//     //   curve: Curves.easeInOut,
//     // );
//     fromTrashDetailsPage.value = false;
//     isLoading.value = false;
//   }
// }

//import 'package:eye_sea/app/data/model/award_request_model.dart';
// import 'package:eye_sea/app/modules/AppConstants.dart';
// import 'package:eye_sea/app/modules/rank/Model/rank_display_model.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../../../data/model/award_display_model.dart';
// import '../../../data/repository/eyeSea_repository.dart';
// import '../../../routes/app_pages.dart';
// import '../../network/controllers/NetworkController.dart';
// import '../Model/rank_view_display_model.dart';
//
// class RankController extends GetxController {
//   final EyeSeaRepository repository;
//   RankController({required this.repository});
//   final storage = GetStorage();
//   final List<String> tabs = [
//     AppConstants.Personal,
//     AppConstants.Vessel,
//     AppConstants.Organization
//   ];
//   var tabIndex = 0.obs;
//   var connectionType = Get.find<NetworkControllers>().connectionType.obs;
//   // Rx<RankViewDisplayModel> myRank = new Rx<RankViewDisplayModel>(
//   //     RankViewDisplayModel(type:"personal",rank: 0,name: "",score: 0,level: 0));
//   //Rx<List<RankViewDisplayModel>> awardTabList = Rx<List<RankViewDisplayModel>>([]);
//   //var awardList = <RankViewDisplayModel>[];
//   //final scrollPostionController = ScrollController();
//   //var listHeight = 240.obs;
//   Rx<List<AwardDisplayModel>> awardsList = Rx<List<AwardDisplayModel>>([]);
//   Rx<List<AwardDisplayModel>> currentUser = Rx<List<AwardDisplayModel>>([]);
//   var isLoading = false.obs;
//   var userid = "";
//   var isGuestUser = "".obs;
//   var token = "";
//   var deviceId = "";
//   AwardRequest request = AwardRequest();
//
//   final count = 0.obs;
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     //myRank.value = RankViewDisplayModel.getMyRank();
//     //awardList.value = RankViewDisplayModel.getAllRank();
//     //awardList = await repository.fetchAllRankList();
//     //scrollPostionController.addListener(checkForScrollPostion);
//     updateTabs(tabIndex.value);
//     userid = storage.read('UserId');
//     isGuestUser.value = storage.read('isGuestUser');
//     token = storage.read('Token') ?? "";
//     deviceId = storage.read('DeviceId');
//     print("id ::: " +
//         userid.toString() +
//         ":::" +
//         token.toString() +
//         ":::" +
//         deviceId.toString());
//     //currentUser.value.last = AwardDisplayModel(name: "",rank: 0,score: 0,level: 3);
//     request = AwardRequest(
//         deviceId: deviceId, apiToken: token, userId: userid, timestamp: "");
//
//     personalAwardSelection();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     //updateTabs(tabIndex.value);
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   navigateToLinks() {
//     Get.toNamed(Routes.LINKS);
//   }
//
//   updateTabs(int index) {
//     tabIndex.value = index;
//     switch (index) {
//       case 0:
//         personalAwardSelection();
//         break;
//       case 1:
//         vesselawardSelection();
//         break;
//       case 2:
//         organizationSelection();
//         break;
//     }
//   }
//
//   Future<void> personalAwardSelection() async {
//     print("RRR clicked tab" + tabIndex.value.toString());
//
//     userid = storage.read('UserId');
//     // token = storage.read('Token');
//     deviceId = storage.read('DeviceId');
//
//     request = AwardRequest(
//         deviceId: deviceId, apiToken: token, userId: userid, timestamp: "");
//     if (tabIndex.value == 1) {
//       vesselawardSelection();
//     } else if (tabIndex.value == 2) {
//       organizationSelection();
//     } else {
//       isLoading.value = true;
//       if (connectionType.value == 1) {
//         await repository.fetchPersonalAwards(request).then((value) async {
//           if (value.personalAwardEntity.length > 0) {
//             await repository.deletepersonalAwardsData();
//             value.personalAwardEntity.asMap().forEach((index, el) =>
//                 print('$index element is  Rank ${el.rank} for ${el.userName}'));
//             await repository.insertPersonalAwards(value.personalAwardEntity);
//           }
//         }, onError: (err) {
//           print('QQQ Sync Request Error .$err');
//         });
//       }
//
//       awardsList.value = await repository.fetchPersonalAwardsDataFromDb();
//       currentUser.value = await repository.fetchCurrentUserDataFromDb();
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> vesselawardSelection() async {
//     isLoading.value = true;
//     if (connectionType.value == 1) {
//       await repository.fetchVesselAwards(request).then((value) async {
//         //print('YYY Sync Request Success . Insert into DB');
//         if (value.vesselAwardEntity.length > 0) {
//           await repository.deleteVesselAwardsData();
//           await repository.insertVesselAwards(value.vesselAwardEntity);
//         }
//       }, onError: (err) {
//         print('QQQ Sync Request Error .$err');
//       });
//     }
//     awardsList.value = await repository.fetchVesselAwardsDataFromDb();
//     isLoading.value = false;
//   }
//
//   Future<void> organizationSelection() async {
//     isLoading.value = true;
//     if (connectionType.value == 1) {
//       await repository.fetchOrganizationAwards(request).then((value) async {
//         //print('YYY Sync Request Success . Insert into DB');
//         if (value.organizationAwardEntity.length > 0) {
//           await repository.deleteOrganizationAwardsData();
//           await repository
//               .insertOrganizationAwards(value.organizationAwardEntity);
//         }
//       }, onError: (err) {
//         print('QQQ Sync Request Error .$err');
//       });
//     }
//
//     awardsList.value = await repository.fetchOrganizationAwardsDataFromDb();
//     isLoading.value = false;
//   }
//
//   /*checkForScrollPostion(){
//     print("RRRRRRRRR");
//     print(scrollPostionController.position.minScrollExtent);
//     print(scrollPostionController.position.maxScrollExtent);
//
//     if (scrollPostionController.offset == scrollPostionController.position.maxScrollExtent){
//       print("MAX POINT REACHED");
//       print(scrollPostionController.position.maxScrollExtent);
//       listHeight.value = 10;
//     }
//     else if (scrollPostionController.offset < scrollPostionController.position.maxScrollExtent){
//       listHeight.value = 240;
//     }
//   }*/
// }