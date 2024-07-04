import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olanma/screens/event_provider.dart';
import 'package:olanma/screens/utils.dart';
import 'package:provider/provider.dart';

import 'model/event_model.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key, this.event});
  final Event? event;

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  final titleController = TextEditingController();

  @override
  void initState() {
    if(widget.event == null){
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 1));
    } else {
      titleController.text = widget.event!.title;
      fromDate = widget.event!.from;
      toDate = widget.event!.to;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4,),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 12,),
              buildDateTimePickers(),
            ],
          ),
        ),
      ),
    );
  }
  
  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0
        ),
        onPressed: saveForm, icon: Icon(Icons.check), label: Text("Save"))
  ];

  Widget buildTitle() => TextFormField(
    style: TextStyle(fontSize: 20),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: "Add Title",
    ),
    onFieldSubmitted: (_){},
    controller: titleController,
  );

  Widget buildDateTimePickers() => Column(
    children: [
      buildForm(),
      buildTo(),
    ],
  );

  Widget buildForm(){
    return buildHeader(
      header: "FROM",
      child: Row(
        children: [
          Flexible(
            flex: 3,
              child: buildDropdownField(
                text: Utils.toDate(fromDate),
                onClicked: (){
                  pickFromDateTime(pickDate: true);
                },
              ),
          ),
          Flexible(
            flex: 2,
              child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onClicked: (){
                  pickFromDateTime(pickDate: false);
                },
              ),
          ),
        ],
      ),
    );
  }

  Widget buildTo(){
    return buildHeader(
      header: "TO",
      child: Row(
        children: [
          Flexible(
            flex: 3,
              child: buildDropdownField(
                text: Utils.toDate(toDate),
                onClicked: (){
                  pickToDateTime(pickDate: true);
                },
              ),
          ),
          Flexible(
            flex: 2,
              child: buildDropdownField(
                text: Utils.toTime(toDate),
                onClicked: (){
                  pickToDateTime(pickDate: false);
                },
              ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField({required String text, required VoidCallback onClicked,}) => ListTile(
    title: Text(text),
    trailing: const Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );

  Widget buildHeader({required String header, required Widget child}) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         Text(header, style: const TextStyle(fontWeight: FontWeight.bold),),
         child,
       ],
     );
  }

  pickFromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if(date == null) return;
    
    if(date.isAfter(toDate)){
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      fromDate = date;
    });
  }

  pickToDateTime({required bool pickDate}) async{
    final date = await pickDateTime(toDate, pickDate: pickDate,
        firstDate: pickDate ? fromDate : null);

    if(date == null) return;

    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
  DateTime initialDate,
      {required bool pickDate,
    DateTime? firstDate,}) async{
    if(pickDate){
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime.now(),
          lastDate: DateTime(2100),);
      
      if(date == null) return null;
      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute, seconds: initialDate.second);

      return date.add(time);
    }
    else {
      final timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate)
      );

      if(timeOfDay == null) return null;

      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute,);

      return date.add(time);
    }
  }

  Future saveForm() async{
    final event = Event(
      title: titleController.text,
      description: "Description",
      from: fromDate,
      to: toDate,
      isAllDay: false,
    );

    final isEditing = widget.event != null;

    final provider = Provider.of<EventProvider>(context, listen: false);
    if(isEditing){
      provider.editEvent(event, widget.event!);
      //Get.back();
    }
    else {
      provider.addEvent(event);
    }
    Get.back();
  }

}
