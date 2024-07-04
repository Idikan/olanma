import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olanma/pages/my_church.dart';
import 'package:olanma/pages/my_reception_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import '../controllers/countdown_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _countdownController = Get.put(CountdownController());
  Location location = Location();
  late bool _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  // Check if location service is enabled on the device
  Future<void> checkLocationService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  // Check if location permission is granted and request if not
  Future<void> checkLocationPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // Once the permission is granted, get the current location
    getCurrentLocation();
  }

  // Get the current location of the device
  Future<void> getCurrentLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }
  

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.sizeOf(context).height;
    double myWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(
        children: [
          //Olanma Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: myWidth,
              height: 50.h,
              padding: EdgeInsets.only(top: 4.h),
              color: Colors.white12,
              child: Transform.rotate(
                angle: 6,
                //transform: Matrix4.skew(1, 2) ,
                child: Image.asset("assets/img/olaola.png",
                fit: BoxFit.contain,),
              ),
            ),
          ),
          //Content
          Positioned(
            top: myHeight * 0.5,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF800080),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 1.5.h,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                            "We the family of Mr. Idika & Mrs. Ijeoma Oji specially request you presence as we dedicate ",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                                ),
                          ),

                          Text("Olanma Zoey Idika ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.w),

                      SizedBox(
                        width: myWidth,
                        child: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.church,size:4.h,color: Colors.white,),
                            Container(
                              margin: EdgeInsets.only(left: 0.3.w),
                              width: myWidth * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Text("@ Kingsway Int'l Christian Center,",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFFFFF)
                                    ),),

                                  Text("(KICC PrayerDome)",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFFFFF)
                                    ),),
                                  Text("#13 Oki Lane, Mende, Maryland - Lagos.",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFFFFF)
                                    ),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      //date and time
                      SizedBox(height: 1.w),

                      SizedBox(
                        width: myWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("30th",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFFFFFF)
                                  ),),
                                Text("July, 2023",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      color: const Color(0xFFFFFFFF)
                                  ),),
                              ],
                            ),
                            Container(width:1.w, height:10.w, color:Colors.white,margin: EdgeInsets.symmetric(horizontal: 4.w),),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("9AM",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFFFFFF)
                                  ),),
                                Text("PROMPT",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      color: const Color(0xFFFFFFFF)
                                  ),),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.w),
                      SizedBox(
                        width: myWidth,
                        child: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.bowlRice,size:4.h, color: Colors.white,),
                            Container(
                              margin: EdgeInsets.only(left: 2.3.w),
                              width: myWidth * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("13 Obadare Close, Santos Estate,",
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFFFFF)
                                    ),),
                                  Text("Off Shasha Road - Lagos.",
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFFFFF)
                                    ),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 3.w),
                      Text("RSVP: 08032000329 | 07034638224",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp,
                          color: const Color(0xFFFFFFFF),
                        ),),

                      SizedBox(height: 5.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: ()=> _currentLocation != null ? Navigator.push(context,
                            MaterialPageRoute(builder: (_)=> MyChurchPage(
                                lat: _currentLocation!.latitude,
                                long: _currentLocation!.longitude,
                            )))
                            : Get.snackbar("Retry", "Ooop your current location is not found, please click again",
                            backgroundColor: Colors.white, colorText: Colors.black
                            ),
                            child: Container(
                              width: myWidth * 0.45,
                              padding: EdgeInsets.symmetric(vertical: 3.w),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              child: Center(
                                child: Text("Direction to Church",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 14.sp,
                                fontWeight: FontWeight.w700),),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: ()=> _currentLocation != null ? Navigator.push(context,
                                MaterialPageRoute(builder: (_)=> MyReceptionPage(
                                  lat: _currentLocation!.latitude,
                                  long: _currentLocation!.longitude,
                                )))
                                :  Get.snackbar("Retry", "Ooop your current location is not found, please click again",
                                backgroundColor: Colors.white, colorText: Colors.black
                            ),
                            child: Container(
                              width: myWidth * 0.45,
                              padding: EdgeInsets.symmetric(vertical: 3.w),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              child: Center(
                                child: Text("Direction to Reception",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 14.sp,
                                fontWeight: FontWeight.w700),),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.w),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Olanma goes to Church
          Positioned(
              top: 10.h,
              left: 0.h,
              child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF800080),
                  borderRadius: BorderRadius.circular(33.w)
                ),
                child: Text("Olanma",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22.sp,
                  color: const Color(0xFFD4AF37),
                ),),
              ),
              Text("goes to",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF800080),
                ),),
              Text("       Church",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20.sp,
                  color: const Color(0xFF800080),
                ),),
            ],
          )),

          //Countdown
          Positioned(
              top: 35.h,
              right: 2.h,
            //  left: 0,
              child: Obx(
                    () => _countdownController.duration.isNegative ?
                    //InProgress or Over
                    Text(
                  _countdownController.timeDifferenceInProgress.value,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp,
                        color: const Color(0xFF800080),
                      ),)
                        :
                    //CountDown
                    Text(
                  _countdownController.timeDifference.value,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp,
                        color: const Color(0xFF800080),
                      ),),
              )),

        ],
      ),
    );
  }
}
