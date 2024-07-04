import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olanma/screens/add_event_screen.dart';
import 'package:olanma/screens/model/event_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'event_provider.dart';

class EventViewingScreen extends StatefulWidget {
  const EventViewingScreen({super.key, required this.event});
  final Event event;

  @override
  State<EventViewingScreen> createState() => _EventViewingScreenState();
}

class _EventViewingScreenState extends State<EventViewingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildViewingActions(context, widget.event),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        children: [
          buildDateTime(widget.event),
          const SizedBox(height: 32,),
          Text(
              widget.event.title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 32,),
        ],
      ),
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) => [
    IconButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AddEventScreen(
      event: event,
    ))), icon: Icon(Icons.edit)),
    IconButton(onPressed: () {
      final provider = Provider.of<EventProvider>(context, listen: false);

      provider.deleteEvent(event);
    }, icon: Icon(Icons.delete)),
  ];

  Future deleteEvent() async{
    final event = Event(
      title: widget.event.title,
      description: widget.event.description,
      from: widget.event.from,
      to: widget.event.to,
      isAllDay: false,
    );

    final provider = Provider.of<EventProvider>(context, listen: false);
    provider.deleteEvent(event);

    Get.back();
  }

  Widget buildDateTime(Event event){
    return Column(
      children: [
        buildDate(widget.event.isAllDay ? "All-day" : "from", widget.event.from),
        if(!widget.event.isAllDay) buildDate("To", widget.event.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date){
    return Container();
  }

}
