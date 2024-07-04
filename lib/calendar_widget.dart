import 'package:flutter/material.dart';
import 'package:olanma/screens/event_provider.dart';
import 'package:olanma/screens/model/event_model.dart';
import 'package:olanma/screens/my_task.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
        view: CalendarView.month,
      cellBorderColor: Colors.transparent,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      onLongPress: (details) {
          final provider = Provider.of<EventProvider>(context, listen: false);
          debugPrint("details.date!: ${details.date!}");
          provider.setDate(details.date!);
          showModalBottomSheet(context: context, builder: (context)=> const TasksWidget(),);
      },
      );
  }
}


class EventDataSource extends CalendarDataSource{
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColors(int index) => getEvent(index).bgColor;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}