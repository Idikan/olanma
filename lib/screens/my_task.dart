import 'package:flutter/material.dart';
import 'package:olanma/calendar_widget.dart';
import 'package:olanma/screens/event_provider.dart';
import 'package:olanma/screens/viewing_event_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
   // final selectedEvents = provider.eventsOfSelectedDate;
    final selectedEventsWithTime = provider.myEventsOfSelectedDate(provider.selectedDate);

    debugPrint("Task selectedEventsWithTime: $selectedEventsWithTime");
    debugPrint("Task selectedDate: ${provider.selectedDate}");
    debugPrint("EventDataSource(provider.events): ${EventDataSource(provider.events)}");

    if(selectedEventsWithTime.isEmpty){
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0, left: 20),
            child: Text(provider.convertToDateString(provider.selectedDate),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18.sp,
            ),),
          ),
          const Divider(),
          Center(
            child: Text("No Event found!",
            style: TextStyle(color: Colors.black87, fontSize: 15.sp),
            ),
          ),
        ],
      );
    }

      return SfCalendar(
        backgroundColor: Colors.white70,
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.events),
        initialSelectedDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        onTap: (details) {
          if(details.appointments == null) return;

          for(int i=0; i< details.appointments!.length; i++) {
            final event = details.appointments![i];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EventViewingScreen(event: event)));
        }
      },
        headerHeight: 0,
        todayHighlightColor: Colors.black87,
        selectionDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
      );
  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details
      ){
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.bgColor.withOpacity(0.45),
        borderRadius: BorderRadius.circular(3.w)
      ),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
