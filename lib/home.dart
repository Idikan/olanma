import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.sizeOf(context).height;
    double myWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: 90),
              color: Colors.white12,
              child: Transform.rotate(
                angle: 2,
                //transform: Matrix4.skew(1, 2) ,
                child: Image.asset("assets/img/ola.jpeg"),
              ),
            ),
          ),
          Positioned(
            top: myHeight * 0.54,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: myHeight*0.03),
              color: const Color(0xFFFFC0CB),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: myHeight*0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FaIcon(FontAwesomeIcons.church, size: myHeight*0.075,color: Colors.deepOrange,),
                    Text("Kingsway International Christian Center,",
                      style: TextStyle(
                        fontSize: myHeight*0.02,
                        fontWeight: FontWeight.bold,
                      ),),
                    Text("(KICC PrayerDome)",
                      style: TextStyle(
                        fontSize: myHeight*0.02,
                        fontWeight: FontWeight.bold,
                      ),),
                    Text("#13 Oki Lane, Mende, Maryland - Lagos.",
                      style: TextStyle(
                        fontSize: myHeight*0.02,
                        fontWeight: FontWeight.bold,
                      ),),
                    SizedBox(
                      height: myWidth * 0.03),
                    FaIcon(FontAwesomeIcons.bowlRice, size: myHeight*0.075,color: Colors.deepOrange,),
                    Text("13 Obadare Close, Santos Estate,",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: myHeight*0.02,
                        fontWeight: FontWeight.bold,
                      ),),
                    Text("Akowanjo Lagos.",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: myHeight*0.02,
                        fontWeight: FontWeight.bold,
                      ),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
