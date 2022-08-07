import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

// import 'package:another_xlider/another_xlider.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:klossr/Constant/constants.dart';
import 'package:klossr/Models/UserModel.dart';
import 'package:klossr/Screens/NearbyUserCardScreen/RequestChatScreen.dart';
import 'package:klossr/SessionManager/SessionManager.dart';
import 'package:klossr/UseCases/UserUseCase.dart';
import 'package:klossr/Utilities/Utilities.dart';
import 'package:klossr/Utilities/toast+klossr.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as myPermission;
import 'dart:ui' as ui;
import 'package:image/image.dart' as Images;
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double min = 0;
  double max = 900000000;
  double selectedDistance = 0;
  Location _location = Location();
  GoogleMapController? _controller;
  LatLng? currentLatLng;
  BitmapDescriptor? _markerIcon;
  LatLng _initialcameraposition = LatLng(56.1304, 106.3468);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  myPermission.PermissionStatus? permissionStatus;
  int _markerIdCounter = 1;
  // final Set<Polyline> _polyline = {};
  // Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  List<UserModel> allUsers = [];
  int index = 0;

  UserUseCase userUseCase = new UserUseCase();
  double ageMin = 18;
  double ageMax = 80;
  var ghostMode = false;
  // CustomInfoWindowController _customInfoWindowController =
  //     CustomInfoWindowController();

  int selectedGender = 1;
  var userId;
  var token;
  @override
  void initState() {
    super.initState();
    getSessionValue();
    getUserId();
  }

  getUserId() async {
    userId = await SessionManager().getUserId();
    print("userId");
    print(userId);

    token = await SessionManager().getUserToken();
  }

  getSessionValue() async {
    var cloakMode = await SessionManager().getGhostMode();
    setState(() {
      ghostMode = cloakMode;
    });
    print("cloakMode $cloakMode");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0,
        toolbarHeight: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) async {
                // _customInfoWindowController.googleMapController = controller;
                _onMapCreated(controller);
              }, //_onMapCreated,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: Set<Marker>.of(markers.values),
              onTap: (position) {
                // _customInfoWindowController.hideInfoWindow();
              },
              onCameraMove: (position) {
                // _customInfoWindowController.onCameraMove();
              },
              // polylines: _polyline,
              // polygons: Set<Polygon>.of(polygons.values),
            ),
            // CustomInfoWindow(
            //   controller: _customInfoWindowController,
            //   height: 40,
            //   width: 80,
            //   offset: 70,
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text('Filter'), Icon(Icons.tune)],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Column(
                              children: [
                                Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                    horizontal: 90,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Cloak mode',
                                          style: TextStyle(fontSize: 18.0)),
                                      Transform.scale(
                                        scale: 0.6,
                                        child: CupertinoSwitch(
                                          activeColor: Colors.black,
                                          value: ghostMode,
                                          onChanged: (value) {
                                            setState(() {
                                              ghostMode = value;
                                            });
                                            print(
                                                'this is the value of ghost mode $value');
                                            ghostModeModel(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Dialog(
                                  insetPadding: EdgeInsets.only(
                                      // top:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.45,
                                      left: 10,
                                      right: 10,
                                      bottom: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Constants.padding),
                                  ),
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            top: Constants.padding,
                                            right: Constants.padding,
                                            bottom: Constants.padding),
                                        margin: EdgeInsets.only(
                                            top: Constants.avatarRadius),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                Constants.padding),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0, 10),
                                                  blurRadius: 10),
                                            ]),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'I\'m interested in...',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black26),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedGender = 1;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              selectedGender ==
                                                                      1
                                                                  ? Colors.black
                                                                  : Color
                                                                      .fromRGBO(
                                                                          239,
                                                                          236,
                                                                          236,
                                                                          100)),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      18.0,
                                                                  vertical:
                                                                      8.0),
                                                          child: Text('Male',
                                                              style: TextStyle(
                                                                  color: selectedGender ==
                                                                          1
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                        ),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedGender = 2;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              selectedGender ==
                                                                      2
                                                                  ? Colors.black
                                                                  : Color
                                                                      .fromRGBO(
                                                                          239,
                                                                          236,
                                                                          236,
                                                                          100)),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      18.0,
                                                                  vertical:
                                                                      9.0),
                                                          child: Text('Female',
                                                              style: TextStyle(
                                                                  color: selectedGender ==
                                                                          2
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                        ),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedGender = 3;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              selectedGender ==
                                                                      3
                                                                  ? Colors.black
                                                                  : Color
                                                                      .fromRGBO(
                                                                          239,
                                                                          236,
                                                                          236,
                                                                          100)),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      33.0,
                                                                  vertical:
                                                                      9.0),
                                                          child: Text('All',
                                                              style: TextStyle(
                                                                  color: selectedGender ==
                                                                          3
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              'Distance (m)',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black26),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTrackColor: Colors.black,
                                                inactiveTrackColor:
                                                    Color.fromRGBO(
                                                        239, 236, 236, 100),
                                                trackShape:
                                                    RectangularSliderTrackShape(),
                                                trackHeight: 4.0,
                                                thumbColor: Colors.black,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                        enabledThumbRadius:
                                                            7.0),
                                                overlayColor:
                                                    Colors.transparent,
                                                // overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                                              ),
                                              child: Row(
                                                children: [
                                                  buildSideLabel(
                                                    // (selectedDistance / 1000)
                                                    //     .round()
                                                    //     .toString(),

                                                    selectedDistance
                                                                .round()
                                                                .toString()
                                                                .length <
                                                            4
                                                        ? selectedDistance
                                                            .round()
                                                            .toString()
                                                        : selectedDistance
                                                                    .round()
                                                                    .toString()
                                                                    .length <
                                                                7
                                                            ? "${(selectedDistance / 1000).round().toString()} K"
                                                            : "${(selectedDistance / 1000000).round().toString()} M",
                                                  ),
                                                  Expanded(
                                                    child: Slider(
                                                        min: min,
                                                        max: max,
                                                        value: selectedDistance,
                                                        // divisions: 1,
                                                        // label: selectedDistance
                                                        //     .round()
                                                        //     .toString(),
                                                        onChanged: (value) {
                                                          print(value
                                                              .round()
                                                              .toString()
                                                              .length
                                                              .toString());
                                                          print(value
                                                              .round()
                                                              .toString());
                                                          setState(() {
                                                            selectedDistance =
                                                                value;
                                                            // min = value;
                                                          });
                                                        }),
                                                  ),
                                                  buildSideLabel("900 M"),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            Text(
                                              'Age',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black26),
                                            ),
                                            Row(
                                              children: [
                                                buildSideLabel(
                                                    ageMin.round().toString()),
                                                SizedBox(
                                                  width: 10.0,
                                                ),

                                                ///todo:comment Kya hai
                                                ///
                                                Expanded(
                                                  child: RangeSliderFlutter(
                                                    // key: Key('3343'),

                                                    values: [ageMin, ageMax],
                                                    rangeSlider: true,
                                                    max: 80,
                                                    handlerHeight: 15,
                                                    tooltip:
                                                        RangeSliderFlutterTooltip(
                                                      // alwaysShowTooltip: true,
                                                      disabled: true,
                                                    ),
                                                    trackBar:
                                                        RangeSliderFlutterTrackBar(
                                                      activeTrackBar:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black,
                                                      ),
                                                      inactiveTrackBar:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Color.fromRGBO(
                                                            239, 236, 236, 100),
                                                      ),
                                                    ),

                                                    min: 18,
                                                    fontSize: 15,
                                                    touchSize: 5.0,
                                                    textBackgroundColor:
                                                        Colors.black,
                                                    onDragging: (handlerIndex,
                                                        lowerValue,
                                                        upperValue) {
                                                      ageMin = lowerValue;
                                                      ageMax = upperValue;
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),

                                                // Expanded(
                                                //   child: Slider(
                                                //       min: 18,
                                                //       max: 80,
                                                //       value: selectedDistance,
                                                //       // divisions: 1,
                                                //       label: selectedDistance
                                                //           .round()
                                                //           .toString(),
                                                //       onChanged: (value) {
                                                //         print(value);
                                                //         setState(() {
                                                //           selectedDistance =
                                                //               value;
                                                //           // min = value;
                                                //         });
                                                //       }),
                                                // ),
                                                // Expanded(
                                                //   child: FlutterSlider(
                                                //     values: [ageMin, ageMax],
                                                //     rangeSlider: true,
                                                //     max: 80,
                                                //     min: 18,
                                                //     handlerHeight: 18.0,
                                                //     handler:
                                                //         FlutterSliderHandler(
                                                //       decoration:
                                                //           BoxDecoration(
                                                //         color: Colors.black,
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(10),
                                                //       ),
                                                //     ),
                                                //     rightHandler:
                                                //         FlutterSliderHandler(
                                                //       decoration:
                                                //           BoxDecoration(
                                                //         color: Colors.black,
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(10),
                                                //       ),
                                                //     ),
                                                //     trackBar:
                                                //         FlutterSliderTrackBar(
                                                //       inactiveTrackBar:
                                                //           BoxDecoration(
                                                //         // borderRadius:
                                                //         //     BorderRadius
                                                //         //         .circular(20),
                                                //         color: Color.fromRGBO(
                                                //             239,
                                                //             236,
                                                //             236,
                                                //             100),
                                                //       ),
                                                //       activeTrackBar:
                                                //           BoxDecoration(
                                                //               color: Colors
                                                //                   .black),
                                                //     ),
                                                //     onDragging: (handlerIndex,
                                                //         lowerValue,
                                                //         upperValue) {
                                                //       ageMin = lowerValue;
                                                //       ageMax = upperValue;
                                                //       setState(() {});
                                                //     },
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  width: 30.0,
                                                ),
                                                buildSideLabel(
                                                    ageMax.round().toString()),
                                              ],
                                            ),
                                            Align(
                                                alignment: Alignment.center,
                                                // ignore: deprecated_member_use
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          applyFilterMethod();
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color:
                                                                  Colors.black),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20.0,
                                                                  vertical:
                                                                      15.0),
                                                              child: Text(
                                                                  'Apply Filters',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        )),
                                                    TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedGender = 1;
                                                            selectedDistance =
                                                                0;
                                                            ageMin = 18.0;
                                                            ageMax = 80.0;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          _refreshAllNearByZones();
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      35.0,
                                                                  vertical:
                                                                      15.0),
                                                              child: Text(
                                                                  'Reset',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    _controller = _cntlr;
    // _controller.setMapStyle(
    // '[{"featureType": "all","stylers": [{ "color": "#C0C0C0" }]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{ "color": "#CCFFFF" }]},{"featureType": "landscape","elementType": "labels","stylers": [{ "visibility": "off" }]}]');

    _controller!.setMapStyle('''
    [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "on"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#080808"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
    ''');

    await myPermission.Permission.location.request();
    permissionStatus = await myPermission.Permission.location.status;

    if (permissionStatus!.isGranted) {
      final post = await _location.getLocation();
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(post.latitude!, post.longitude!),
            zoom: 18,
          ),
        ),
      );
      saveCurrentLocation(post.latitude!, post.longitude!);
    } else {
      permissionDeniedMethod(
        context,
        "Location",
      );
      // await myPermission.openAppSettings();
    }
  }

  saveCurrentLocation(double latitude, double longitude) {
    checkInternet().then((value) async {
      if (value) {
        userUseCase.saveCurrentLocation(latitude, longitude).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            print(value.data!.message);
            _refreshAllNearByZones();
          } else
            showToast("Something went wrong", context);
        });
      } else
        noInternetConnectionMethod(context);
    });
  }

  _refreshAllNearByZones() async {
    checkInternet().then((value) async {
      if (value) {
        showEasyloaging();
        final pos = await _location.getLocation().then((cLoc) {
          double? lat = cLoc.latitude;
          double? long = cLoc.longitude;

          print("lat: $lat, $long");
          userUseCase
              .getNearbyZones(lat.toString(), long.toString())
              .then((value) {
            hideEasyLoading();
            if (value.statusCode == 200) {
              print(value.data!.data);
              print("values: ${value.data!.data.length}");
              // setState(() {
              markers.clear();
              // });
              createMarker(value.data!.data);
            } else
              showToast("Something went wrong", context);
          });
        });
      } else
        noInternetConnectionMethod(context);
    });
  }

  createMarker(List<UserModel> lstZones) async {
    // String markerPath = "assets/images/person.jpg";
    if (lstZones != null && lstZones.length > 0) {
      for (int x = 0; x < lstZones.length; x++) {
        if (lstZones[x] != null &&
            lstZones[x].latitude != null &&
            lstZones[x].longitude != null) {
          var iconUrl = lstZones[x].profile_image;

          //get image data from network
          var dataBytes;
          var request = await http.get(Uri.parse(iconUrl));
          var bytes = request.bodyBytes;

          // setState(() {
          dataBytes = bytes;
          // });

          //save image data in temp file
          String dir = (await getApplicationDocumentsDirectory()).path;
          File file = new File('$dir/$_markerIdCounter.png');
          await file.writeAsBytes(bytes);
          print("imageiCon : ${file.path}");

          _markerIdCounter++;
          final MarkerId markerId = MarkerId(_markerIdCounter.toString());

          double lat, long;
          lat = lstZones[x].latitude;
          long = lstZones[x].longitude;

          // creating a new MARKER
          final Marker marker = Marker(
            markerId: markerId,
            position: LatLng(lat, long),
            icon: await getMarkerIcon(file.path, Size(200.0, 200.0)),
            // infoWindow: InfoWindow(
            //   title: lstZones[x].name,
            // ),
            onTap: () {
              animateToLocation(lat, long);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestChatScreen(
                            lstZones[x],
                            userId,
                            token: token,
                          )));
              // _customInfoWindowController.addInfoWindow(
              //   GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) =>
              //                   RequestChatScreen(lstZones[x])));
              //     },
              //     child: Container(
              //       height: 20.0,
              //       width: 60.0,
              //       decoration: BoxDecoration(
              //         color: Colors.black,
              //         borderRadius: BorderRadius.circular(5.0),
              //       ),
              //       child: Center(
              //         child: Text(
              //           "${lstZones[x].name.capitalize()}",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16.0,
              //               fontWeight: FontWeight.w600),
              //         ),
              //       ),
              //     ),
              //   ),
              //   LatLng(lat, long),
              // );

              // lstZones[x].latitude == null && lstZones[x].longitude == null
              //     ? showToast("Something went wrong", context)
              //     : showGeneralDialog(
              //         context: context,
              //         pageBuilder: (
              //           dialogContext,
              //           animation,
              //           secondaryAnimation,
              //         ) =>
              //             myDialogDeletedialogContext(
              //           dialogContext,
              //           animation,
              //           secondaryAnimation,
              //           lstZones[x],
              //         ),
              //         transitionBuilder: (context, anim1, anim2, child) {
              //           return SlideTransition(
              //             position: Tween(
              //               begin: Offset(0, 1),
              //               end: Offset(0, 0),
              //             ).animate(anim1),
              //             child: child,
              //           );
              //         },
              //         transitionDuration: Duration(milliseconds: 500),
              //       );
            },
          );
          setState(() {
            markers[markerId] = marker;
          });
        }
      }
    } else
      showToast("No Users", context);
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    File imageFile = File(imagePath);

    Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()
      ..color =
          hexToColor(appGreenColor); //hexToColor(primaryColor).withAlpha(100);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.green;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // // Add tag circle
    // canvas.drawRRect(
    //     RRect.fromRectAndCorners(
    //       Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
    //       topLeft: radius,
    //       topRight: radius,
    //       bottomLeft: radius,
    //       bottomRight: radius,
    //     ),
    //     tagPaint);

    // // Add tag text
    // TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    // textPainter.text = TextSpan(
    //   text: '1',
    //   style: TextStyle(fontSize: 20.0, color: Colors.white),
    // );

    // textPainter.layout();
    // textPainter.paint(
    //     canvas,
    //     Offset(size.width - tagWidth / 2 - textPainter.width / 2,
    //         tagWidth / 2 - textPainter.height / 2));

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await getImageFromPath(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes

    ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  void animateToLocation(double lat, double long) {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 19,
          ),
        ),
      );
    } else
      showToast("Map Is Not Working Properly", context);
  }

  ghostModeModel(bool mode) {
    var cloakMode = mode ? "on" : "off";

    UserUseCase userUseCase = new UserUseCase();
    checkInternet().then((value) {
      ToastContext().init(context);
      if (value) {
        showEasyloaging();
        userUseCase.ghostMode(cloakMode).then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            setState(() {
              ghostMode = mode;
            });
            SessionManager().setGhostMode(mode);
            Toast.show("Cloak mode is updated successfully",
                textStyle: TextStyle(color: Colors.white),
                duration: Toast.lengthLong,
                gravity: Toast.center);
          } else if (value.statusCode == 422) {
            print("value: ${value.data}");
            Toast.show("Cannot update",
               textStyle: TextStyle(color: Colors.white),
                duration: Toast.lengthLong,
                gravity: Toast.center);
          } else {
            Toast.show("Something went wrong!",
                textStyle: TextStyle(color: Colors.white),
                duration: Toast.lengthLong,
                gravity: Toast.center);
          }
        });
      } else {
        noInternetConnectionMethod(context);
      }
    });
  }

  makeReceiptImage(String iconurl) async {
    // load avatar image
    ByteData imageData = await rootBundle.load('assets/images/av.png');
    List<int> bytes = Uint8List.view(imageData.buffer);
    var avatarImage = Images.decodeImage(bytes);

    //load marker image
    imageData = await rootBundle.load('assets/images/ma.png');
    bytes = Uint8List.view(imageData.buffer);
    var markerImage = Images.decodeImage(bytes);

    // var request = await http.get(iconurl);
    // var reqBytes = request.bodyBytes;
    // var markerImage = Images.decodeImage(reqBytes);

    //resize the avatar image to fit inside the marker image
    avatarImage = Images.copyResize(avatarImage!,
        width: markerImage!.width ~/ 1.1, height: markerImage.height ~/ 1.4);

    var radius = 90;
    int originX = avatarImage.width ~/ 2, originY = avatarImage.height ~/ 2;

    //draw the avatar image cropped as a circle inside the marker image
    for (int y = -radius; y <= radius; y++)
      for (int x = -radius; x <= radius; x++)
        if (x * x + y * y <= radius * radius)
          markerImage.setPixelSafe(originX + x + 8, originY + y + 10,
              avatarImage.getPixelSafe(originX + x, originY + y));

    return Images.encodePng(markerImage);
  }

  Widget buildSideLabel(value) => Container(
        // width: 25,
        child: Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      );

  applyFilterMethod() {
    var _gender = selectedGender == 1
        ? "male"
        : selectedGender == 2
            ? "female"
            : "all";

    if (selectedDistance.round() <= 0) {
      ToastContext().init(context);
      Toast.show("Please select distance value.",
          textStyle: TextStyle(color: Colors.white),
          duration: Toast.lengthLong,
          gravity: Toast.center);
      return;
    }

    // if (ageMin <= 0.0 || ageMax > 80.0) {
    //   Toast.show("Please select age between 18 to 80", context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //   return;
    // }

    print("Gender : $_gender");
    print("Distance : ${selectedDistance.round()}");
    print("Age : $ageMin, $ageMax");

    Navigator.pop(context);

    checkInternet().then((value) async {
      if (value) {
        showEasyloaging();
        userUseCase
            .applyFilter(_gender, selectedDistance.round(), ageMin.round(),
                ageMax.round())
            .then((value) {
          hideEasyLoading();
          if (value.statusCode == 200) {
            print(value.data!.data);
            print("values: ${value.data!.data.length}");
            setState(() {
              markers.clear();
            });
            createMarker(value.data!.data);
          } else
            showToast("Something went wrong", context);
        });
      } else
        noInternetConnectionMethod(context);
    });
  }

  // myDialogDeletedialogContext(dialogContext, Animation<double> animation,
  //     Animation<double> secondaryAnimation, UserModel user) {
  //   final screenSize = MediaQuery.of(dialogContext).size;
  //   return Scaffold(
  //     backgroundColor: Colors.transparent,
  //     body: Align(
  //       alignment: Alignment.bottomCenter,
  //       child: Container(
  //         height: 300.0,
  //         child: Stack(
  //           children: [
  //             Align(
  //               alignment: Alignment.bottomCenter,
  //               child: Container(
  //                 margin: EdgeInsets.only(bottom: 20.0),
  //                 height: 200.0,
  //                 width: screenSize.width * 0.9,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20.0),
  //                   color: Colors.white,
  //                 ),
  //                 child: Stack(
  //                   children: [
  //                     Align(
  //                       alignment: Alignment.topRight,
  //                       child: IconButton(
  //                         onPressed: () => Navigator.pop(context),
  //                         splashColor: Colors.grey.withOpacity(0.5),
  //                         icon: Icon(Icons.clear, color: Colors.grey),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(
  //                           vertical: 15.0, horizontal: 8.0),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                         children: <Widget>[
  //                           Padding(
  //                             padding:
  //                                 const EdgeInsets.only(left: 20.0, top: 10.0),
  //                             child: Column(
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     Container(
  //                                       height: 80.0,
  //                                       width: 80.0,
  //                                       decoration: BoxDecoration(
  //                                         shape: BoxShape.circle,
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.black45,
  //                                             offset: Offset(0, 2),
  //                                             blurRadius: 6.0,
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       child: ClipOval(
  //                                         child: Image(
  //                                           height: 120.0,
  //                                           width: 120.0,
  //                                           image: AssetImage(
  //                                               "assets/images/person.jpg"),
  //                                           fit: BoxFit.cover,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       width: 10.0,
  //                                     ),
  //                                     Column(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           "${user.name.toUpperCase()}",
  //                                           style: TextStyle(
  //                                               fontSize: 16.0,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Colors.grey),
  //                                         ),
  //                                         Text(
  //                                           "${user.email}",
  //                                           style: TextStyle(
  //                                               fontSize: 15.0,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Colors.grey),
  //                                         ),
  //                                       ],
  //                                     )
  //                                   ],
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                           Container(
  //                             height: 45.0,
  //                             width: 150.0,
  //                             decoration: BoxDecoration(
  //                                 color: hexToColor(primaryColor),
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(20))),
  //                             child: InkWell(
  //                               splashColor: Colors.grey,
  //                               onTap: () {},
  //                               // Navigator.push(
  //                               //   context,
  //                               //   MaterialPageRoute(
  //                               //     builder: (context) => SupportScreen(),
  //                               //   ),
  //                               // ),
  //                               child: Center(
  //                                 child: Text(
  //                                   "Send Request",
  //                                   style: TextStyle(
  //                                       color: Colors.white,
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 18.0),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             // Align(
  //             //   alignment: Alignment.topLeft,
  //             //   child: Container(
  //             //     margin: EdgeInsets.only(left: 50.0, top: 10.0),
  //             //     child: Image(
  //             //       image: AssetImage(
  //             //         "assets/images/skooter.png",
  //             //       ),
  //             //       height: 110.0,
  //             //     ),
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // //set marker
  // void setMarkerIcon() async {
  //   String markerPath = "assets/images/marker_icon_full.png";

  //   final Uint8List markerIcon = await getBytesFromAsset(markerPath, 100);
  //   _markerIcon = BitmapDescriptor.fromBytes(markerIcon);
  // }

  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
  //       .buffer
  //       .asUint8List();
  // }

  // Future<Uint8List> getBytesFromCanvas(
  //     int width, int height, String imagePath) async {
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //   final Paint paint = Paint()..color = Colors.blue;
  //   final Radius radius = Radius.circular(25.0);
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       paint);

  //   TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
  //   painter.text = TextSpan(
  //     text: 'Hello world',
  //     style: TextStyle(fontSize: 25.0, color: Colors.white),
  //   );
  //   painter.layout();
  //   painter.paint(
  //       canvas,
  //       Offset((width * 0.5) - painter.width * 0.5,
  //           (height * 0.5) - painter.height * 0.5));
  //   final img = await pictureRecorder.endRecording().toImage(width, height);
  //   final data = await img.toByteData(format: ui.ImageByteFormat.png);
  //   return data.buffer.asUint8List();
  // }
}
