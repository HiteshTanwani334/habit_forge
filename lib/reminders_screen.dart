import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<String> defaultReminders = [
    "Drink 8 glasses of water 💧",
    "Take deep breaths 😮‍💨",
    "Get 8 hours of sleep 🛌",
    "Avoid screen time before bed 📵",
    "Stretch for 5 minutes 🧘",
  ];

  List<String> customReminders = [];

  void _addReminder() {
    showDialog(
      context: context,
      builder: (context) {
        String newReminder = '';
        TimeOfDay selectedTime = TimeOfDay.now();

        return AlertDialog(
          title: const Text('Add New Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Reminder Text',
                  hintText: 'Enter your reminder',
                ),
                onChanged: (value) {
                  newReminder = value;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Set Time'),
                trailing: Text(selectedTime.format(context)),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    selectedTime = picked;
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newReminder.isNotEmpty) {
                  setState(() {
                    customReminders.add('$newReminder ⏰ ${selectedTime.format(context)}');
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allReminders = [...defaultReminders, ...customReminders];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Reminders"),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: allReminders.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final isCustomReminder = index >= defaultReminders.length;
          return ListTile(
            leading: const Icon(Icons.alarm),
            title: Text(
              allReminders[index],
              style: const TextStyle(fontSize: 16),
            ),
            trailing: isCustomReminder
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        customReminders.removeAt(index - defaultReminders.length);
                      });
                    },
                  )
                : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
        tooltip: 'Add Reminder',
      ),
    );
  }
}
