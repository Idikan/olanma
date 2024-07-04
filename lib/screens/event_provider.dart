import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:olanma/screens/model/event_model.dart';

class EventProvider extends ChangeNotifier{
  final List<Event>  _events = [];


  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate =>  _events;
  List<Event> myEventsOfSelectedDate(DateTime passEvent) {
    debugPrint("passEvent: $passEvent");
    debugPrint("passEvent: $passEvent");
    final filteredList = _events.where((event) => convertToDateString(event.from) == convertToDateString(passEvent))
        .toList();
    debugPrint("filteredList: $filteredList");

    return filteredList;
  }
  void addEvent(Event event){
    _events.add(event);

    notifyListeners();
  }

  void deleteEvent(Event event){
    _events.remove(event);

    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent){
    //get the old event index
    final index = _events.indexOf(oldEvent);

    _events[index] = newEvent;

    notifyListeners();
  }

  String convertToDateString(DateTime dateTime) {
    // Format the DateTime to the desired format "yyyy-MM-dd"
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
  }

}