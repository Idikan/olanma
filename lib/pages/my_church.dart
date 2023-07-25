import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/keys.dart';

class MyChurchPage extends StatefulWidget {
  const MyChurchPage({Key? key, this.lat, this.long}) : super(key: key);
  final double? lat;
  final double? long;

  @override
  State<MyChurchPage> createState() => _MyChurchPageState();
}

class _MyChurchPageState extends State<MyChurchPage> {
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
  String googleAPiKey = apiKey;

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
//    double myWidth = MediaQuery.sizeOf(context).width;

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
        body: /* currentLocation == null
            ? const Center(
                child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ))
            : */ GoogleMap(
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
}
