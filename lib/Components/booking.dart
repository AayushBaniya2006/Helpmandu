import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class BookPage extends StatefulWidget {
  final String name;

  const BookPage({Key? key, required this.name}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final TextEditingController _textFieldControllerDescription =
      TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _showDatePicker(context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _showTimePicker(context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  void dispose() {
    _textFieldControllerDescription.dispose();
    super.dispose();
  }

  SMS(String phoneNumber, String message) async {
    if (Platform.isIOS) {
      Uri smsLaunchUri = Uri(
        scheme: 'sms',
        path: '+9979851140485',
      );
      await launchUrl(smsLaunchUri);
    }

    if (Platform.isAndroid) {
      Uri smsLaunchUris = Uri(
        scheme: 'sms',
        path: "+9979851140485",
        queryParameters: <String, String>{
          'body': message,
        },
      );

      await launchUrl(smsLaunchUris);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Text('Book a Consultation'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Select a Date & Time',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showDatePicker(context),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text(
                        'Choose a Date',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showTimePicker(context),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text(
                        'Select a Time',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _textFieldControllerDescription,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Enter a brief description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String description = _textFieldControllerDescription.text;
                  String time = selectedTime != null
                      ? selectedTime!.format(context)
                      : 'Not selected';
                  String date = selectedDate != null
                      ? selectedDate!.toString().split(' ')[0]
                      : 'Not selected';

                  String message = 'Appointment: ${widget.name}\n'
                      'Date: $date\n'
                      'Time: $time\n'
                      'Description: $description';
                  Clipboard.setData(ClipboardData(text: message));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0,
                  ),
                  child: Text(
                    'Copy Appointment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                  'Please copy the appointment here then paste the text after pressing Book Now.'),
              const SizedBox(height: 180),
              ElevatedButton(
                onPressed: () {
                  String description = _textFieldControllerDescription.text;
                  String time = selectedTime != null
                      ? selectedTime!.format(context)
                      : 'Not selected';
                  String date = selectedDate != null
                      ? selectedDate!.toString().split(' ')[0]
                      : 'Not selected';

                  String message = 'Appointment: ${widget.name}\n'
                      'Date: $date\n'
                      'Time: $time\n'
                      'Description: $description';

                  SMS('5124095461', message);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Disclaimer: These dates may not be available and are not final, but we do try our best.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
