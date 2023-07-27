import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyReceptionPage extends StatefulWidget {
  const MyReceptionPage({Key? key, this.lat, this.long}) : super(key: key);
  final double? lat;
  final double? long;

  @override
  State<MyReceptionPage> createState() => _MyReceptionPageState();
}

class _MyReceptionPageState extends State<MyReceptionPage>  {

  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polyLines = {};
  Iterable markers = [];
  StreamSubscription<LocationData>? _locationSubscription;

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
      PointLatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      const PointLatLng(6.6018745,3.3093405),
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

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Direction to 13 Obadare Close',
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
              position: const LatLng(6.6018745,3.3093405),
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


/*
{
  LocationData? currentLocation;
  Location location = Location();
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polyLines = {};
  late StreamSubscription<LocationData> streamLocation;
  late GoogleMapController googleMapController;
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
    setState(() {});
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBAEbEyQHBYByW-",
      PointLatLng(widget.lat!, widget.long!),
      PointLatLng(
        6.4386933,
        3.4192629,
      ),
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
    _initGoogleMapController();
    getCurrentLocation();
    getPolyPoints();
    setCustomMarkerIcon();
    super.initState();
  }

  void _initGoogleMapController() async {
    googleMapController = await  _controller.future;
  }

  @override
  void dispose() {
    streamLocation.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery
        .of(context)
        .size
        .height;
    double myWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Direction to 13 Obadare Close',
          style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF000000)),
        ),
      ),
      body: Stack(
        children: [
          currentLocation == null
              ? Container(
            color: Colors.white,
            width: myWidth,
            height: myHeight,
            child: const Center(child: CircularProgressIndicator()),
          )
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLocation?.latitude ?? 6.5851657,
                currentLocation?.longitude ?? 3.3724918,
              ),
              zoom: 11.8,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("source"),
                icon: sourceIcon,
                position:
                LatLng(widget.lat!, widget.long!),
              ),
              Marker(
                markerId: const MarkerId("destination"),
                icon: destinationIcon,
                position: LatLng(
                  6.4386933,
                  3.4192629,
                ),
              ),
              Marker(
                markerId: const MarkerId("currentLocation"),
                icon: currentLocationIcon,
                position: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
              ),
            },
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            polylines: Set<Polyline>.of(polyLines.values),
            trafficEnabled: false,
            myLocationEnabled: false,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
          ),
        ],
      ),
    );
  }

  void getCurrentLocation() async {

    streamLocation = location.onLocationChanged.listen((LocationData newLoc)
           async {
        setState(() {
          currentLocation = newLoc;
          debugPrint("'");
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 11.8,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                ),
              ),
            ),
          );
        });
      },
    );
  }
}*/
