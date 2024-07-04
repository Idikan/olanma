import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:olanma/calendar_widget.dart';

import 'add_event_screen.dart';

class CalendarDashboard extends StatefulWidget {
  const CalendarDashboard({super.key});

  @override
  State<CalendarDashboard> createState() => _CalendarDashboardState();
}

class _CalendarDashboardState extends State<CalendarDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event App"),
      ),
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(()=> AddEventScreen()),
        backgroundColor: Colors.deepOrange,
        child: FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
