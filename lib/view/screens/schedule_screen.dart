import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    viewModel.fetchSchedules();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context);

    // Grupowanie harmonogramów według dnia
    final groupedSchedules =
        viewModel.schedules.fold<Map<String, List<dynamic>>>(
      {},
      (map, schedule) {
        map.putIfAbsent(schedule.day, () => []).add(schedule);
        return map;
      },
    );

    final sortedDays = groupedSchedules.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harmonogram'),
      ),
      body: sortedDays.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: sortedDays.length,
              itemBuilder: (context, index) {
                final day = sortedDays[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyScheduleScreen(
                          day: day,
                          schedules: groupedSchedules[day]!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        day.substring(5),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DateTime? selectedDate;
          TimeOfDay? selectedTime;
          final amountController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Dodaj harmonogram'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: const Text('Wybierz datę'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: const Text('Wybierz czas'),
                    ),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ilość wody (ml)',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Anuluj'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (selectedDate != null &&
                          selectedTime != null &&
                          amountController.text.isNotEmpty) {
                        final formattedDate =
                            '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
                        final formattedTime =
                            '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00';
                        final amount = int.tryParse(amountController.text);

                        if (amount != null) {
                          try {
                            await viewModel.addSchedule(
                                formattedDate, formattedTime, amount);
                            setState(() {}); // Wymuś odświeżenie ekranu
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Błąd: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Nieprawidłowe dane wejściowe')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Nieprawidłowe dane wejściowe')),
                        );
                      }
                    },
                    child: const Text('Dodaj'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DailyScheduleScreen extends StatelessWidget {
  final String day;
  final List<dynamic> schedules;

  const DailyScheduleScreen({
    required this.day,
    required this.schedules,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harmonogram: $day'),
      ),
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return ListTile(
            title: Text('Czas: ${schedule.time}, Ilość: ${schedule.amount} ml'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final viewModel =
                    Provider.of<ScheduleViewModel>(context, listen: false);
                await viewModel.deleteSchedule(schedule.scheduleId);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
