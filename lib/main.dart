import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olanma/pages/my_church.dart';
import 'package:olanma/pages/my_reception_page.dart';
import 'package:olanma/screens/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'auth/screens/login_or_register.dart';
import 'pages/home.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp();


    runApp( //const MyApp()

    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => EventProvider()),
    ],
    child: const MyApp(),
  ),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        title: 'Olanma goes to Church',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const LoginOrRegister()),
       //   GetPage(name: '/', page: () => const MyHomePage()),
          GetPage(name: '/church', page: () => const MyChurchPage(),),
          GetPage(name: '/reception', page: () => const MyReceptionPage()),
        ],
        defaultTransition: Transition.circularReveal,
        transitionDuration: const Duration(milliseconds: 400),
      );
    });
  }
}
