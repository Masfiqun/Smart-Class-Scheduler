import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> availableSlots = [];
  final TextEditingController classController = TextEditingController();

  void _selectSlot(String slot) {
    setState(() {
      if (availableSlots.contains(slot)) {
        availableSlots.remove(slot);
      } else {
        availableSlots.add(slot);
      }
    });
  }

  void _scheduleClass() {
    if (availableSlots.isEmpty || classController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select available slots and enter class name')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Class Scheduled!'),
        content: Text('Class "${classController.text}" scheduled at ${availableSlots.join(", ")}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smart Class Scheduler')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: classController,
              decoration: InputDecoration(labelText: 'Enter Class Name'),
            ),
            SizedBox(height: 20),
            Text('Select Available Slots:'),
            Wrap(
              children: ['9 AM', '10 AM', '11 AM', '1 PM', '2 PM', '3 PM']
                  .map((slot) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ChoiceChip(
                          label: Text(slot),
                          selected: availableSlots.contains(slot),
                          onSelected: (selected) => _selectSlot(slot),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _scheduleClass,
                child: Text('Schedule Class'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}