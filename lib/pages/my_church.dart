import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyChurchPage extends StatefulWidget {
  const MyChurchPage({Key? key, this.lat, this.long}) : super(key: key);
  final double? lat;
  final double? long;

  @override
  State<MyChurchPage> createState() => _MyChurchPageState();
}

class _MyChurchPageState extends State<MyChurchPage> {

  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polyLines = {};
  Iterable markers = [];

  BitmapDescriptor destinationIcon =
  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor sourceIcon =
  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(60, 80)),
      "assets/img/ola.png",
    ).then(
          (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      width: 4,
      polylineId: id,
      color: const Color(0xFF3214EC),
      points: polylineCoordinates,
    );
    polyLines[id] = polyline;
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "GOOGLE-API",
      PointLatLng(_currentLocation!.latitude ?? widget.lat!, _currentLocation!.longitude ?? widget.long!),
      const PointLatLng(6.5757235,3.3684964),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      _addPolyLine();
      setState(() {});
    }
  }


  @override
  void initState() {
    _init().whenComplete(() =>
        Future.delayed(const Duration(seconds: 5), (){
          getPolyPoints();
          //    setCustomMarkerIcon();
        }));
    super.initState();
  }

  Future _init() async {
    _location = Location();
    _cameraPosition = CameraPosition(
        target: LatLng(_currentLocation?.latitude ?? 6.4385669,_currentLocation?.longitude ?? 3.4194777), // this is just the example lat and lng for initializing
        zoom: 12
    );
    _startListening();
  }


  Future _startListening() async {
    _location?.getLocation().then((location) {
      setState(() {
        _currentLocation = location;
      });
    });

    _locationSubscription = _location?.onLocationChanged.listen((locationData) {
      setState(() {
        _currentLocation = locationData;
      });

      moveToPosition(LatLng(_currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
    });

  }

  void _stopListening() {
    _locationSubscription?.cancel();
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: latLng,
                zoom: 12
            )
        )
    );
  }

  /*void _stopListening() {
    _location?.onLocationChanged.drain();
    //_location.onLocationChanged.drain();
  }*/

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          _stopListening();
          Navigator.pop(context);
        }, icon: FaIcon(FontAwesomeIcons.arrowLeft)),
        title: Text(
          'Direction to KICC PrayerDome',
          style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF000000)),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMarker() {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0,3),
                spreadRadius: 4,
                blurRadius: 6
            )
          ]
      ),
      child:  ClipOval(child: Image.asset("assets/img/olaola.png")),
    );
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },

          markers: {
            Marker(
              markerId: const MarkerId("source"),
              icon: sourceIcon,
              position: LatLng(widget.lat!, widget.long!),
            ),
            Marker(
              markerId: const MarkerId("destination"),
              icon: destinationIcon,
              position: const LatLng(6.5757235,3.3684964),
            ),
          },
          polylines: Set<Polyline>.of(polyLines.values),
        ),

        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: _getMarker()
            )
        ),
        Positioned(
            left: 0,
         //   right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              margin: EdgeInsets.all(3.w),
              color: Colors.deepOrange,
              child: TextButton(
                onPressed: () {
                  polylineCoordinates = [];
                  polyLines = {};
                  getPolyPoints();
                  },
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.route, size: 6.w,color: Colors.white),
                    SizedBox(width: 3.w,),
                    Text("Click to redraw polyline",
                      style: TextStyle(color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700),),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

/*{
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  final double _destLatitude = 6.5757235;
  final double _destLongitude = 3.3711786;
  Location location = Location();
  LocationData? currentLocation;
  late StreamSubscription<LocationData> streamLocation;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = googleAPIKey;

  BitmapDescriptor destinationIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor sourceIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/img/ola.png",
    ).then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    _getPolyline();
    setCustomMarkerIcon();
    super.initState();

    /// origin marker
    _addMarker(LatLng(widget.lat!, widget.long!), "origin",
        destinationIcon);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
    sourceIcon);//BitmapDescriptor.defaultMarkerWithHue(90));

    /// current marker
    _addMarker(
        LatLng(
          currentLocation?.latitude ?? widget.lat!,
          currentLocation?.longitude ?? widget.long!,
        ),
        "currentLocation",
        currentLocationIcon);
  }

  @override
  void dispose() {
    streamLocation.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Direction to KICC PrayerDome',
            style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000)),
          ),
        ),
        body: */
/* currentLocation == null
            ? const Center(
                child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ))
            : *//* GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.lat!, widget.long!), zoom: 11.8),
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: false,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated:  (mapController) {
                  _controller.complete(mapController);
                },
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
              ));
  }


  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        width: 4,
        polylineId: id,
        color: const Color(0xFF3214EC).withOpacity(0.4),
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(widget.lat!, widget.long!),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  void getCurrentLocation() async {
    mapController = await _controller.future;

   // var locationSubscription = location.onLocationChanged();

    streamLocation =  location.onLocationChanged.listen((LocationData currentLoc) async {
        setState(() {
          currentLocation = currentLoc;

          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 11.8,
                target: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
              ),
            ),
          );

        });
      },
    );
    debugPrint("Error getting location: ");
  }
}*/
