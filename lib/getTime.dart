import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDateTime = combinedDateTime;
        });
      }
    }
  }

  void _showSelectedDateTime() {
    String formattedDateTime = DateFormat('MM/dd/yyyy HH:mm').format(selectedDateTime);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selected Date and Time'),
          content: Text('Selected Date and Time: $formattedDateTime'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = DateFormat('MM/dd/yyyy HH:mm').format(selectedDateTime);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _selectDateTime(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Selected Date and Time: $formattedDateTime'),
              SizedBox(width: 20),
              Icon(Icons.event),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Selected Date and Time: $formattedDateTime',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _showSelectedDateTime,
          child: Text('Get Selected Date and Time'),
        ),
      ],
    );
  }
}

class DateTimePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date and Time Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DateTimePicker(),
      ),
    );
  }
}