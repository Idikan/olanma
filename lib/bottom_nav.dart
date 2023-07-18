import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olanma/home.dart';

import 'my_church.dart';
import 'my_reception_page.dart';

class MyHomePageMenu extends StatefulWidget {
  const MyHomePageMenu({Key? key}) : super(key: key);

  @override
  State<MyHomePageMenu> createState() => _MyHomePageMenuState();
}

class _MyHomePageMenuState extends State<MyHomePageMenu> {
  int _selectedIndex = 0;

  List<Widget> pageList = [
    const MyHomePage(),
    const MyChurchPage(),
    const MyReceptionPage(),
  ];


  static const List<BottomNavigationBarItem> _bottomNavItems =
  <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(
        Icons.dashboard,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.church),
      label: 'KICC PrayerDome',
    ),
    BottomNavigationBarItem(
      icon:  FaIcon(FontAwesomeIcons.bowlRice),
      label: '13 Obadare Close',
    ),
  ];

  void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.red,
          items: _bottomNavItems,
        ),
        body:pageList.elementAt(_selectedIndex)

    );
  }
}
