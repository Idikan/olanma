import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olanma/controllers/keys.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MyReceptionPage extends StatefulWidget {
  const MyReceptionPage({Key? key, this.lat, this.long}) : super(key: key);
  final double? lat;
  final double? long;

  @override
  State<MyReceptionPage> createState() => _MyReceptionPageState();
}

class _MyReceptionPageState extends State<MyReceptionPage> {
  double? _distanceInMeters;
  String? _durationText;
  GoogleMapController? mapController;
  double _destLatitude = 6.6018745;
  double _destLongitude = 3.3066583;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = apiKey;

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(widget.lat!, widget.long!), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }


  Future<void> updateDistanceAndDuration() async {
    //if (_currentLocation != null) {
      //final String apiKey = "YOUR_GOOGLE_MAPS_API_KEY";
      final String url =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${widget.lat},${widget.long}&destinations=$_destLatitude,$_destLongitude&key=$apiKey";

      try {
        http.Response response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          if (data["status"] == "OK") {
            String distanceText = data["rows"][0]["elements"][0]["distance"]["text"];
            String durationText = data["rows"][0]["elements"][0]["duration"]["text"];
            setState(() {
              _distanceInMeters = double.parse(data["rows"][0]["elements"][0]["distance"]["value"].toString());
              _durationText = durationText;
            });
          }
        }
      } catch (e) {
        print("Error updating distance and duration: $e");
      }
    //}
  }

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Direction to #13 Obadare Close',
            style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lat!, widget.long!), zoom: 12),
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
            ),

    /*
            Positioned(
              top: 5.h,
              left: 0,
              right: 0,
              child:  _distanceInMeters != null && _durationText != null
                ? Container(
                width: myWidth * 0.65,
                padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(3.w),
    ),
                  child: Text(
              'Distance: $_distanceInMeters meters\n'
                    'Duration: $_durationText',
              textAlign: TextAlign.center,
            ),
                )
                : const Center(child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator())),
            ),
            */

            Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: _getMarker()
                )
            )
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
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
        width: 7,
        polylineId: id, color: Colors.cyanAccent, points: polylineCoordinates);
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

}