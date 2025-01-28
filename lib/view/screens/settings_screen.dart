import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context);
    final newWaterAmountController = TextEditingController();
    @override
    void initState() {
      super.initState();

      viewModel.fetchDevices(); // Wywołaj raz przy inicjalizacji
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: FutureBuilder(
        future: viewModel.fetchDevices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            debugPrint('Error in FutureBuilder: ${snapshot.error}');
            return Center(
              child: Text('Błąd ładowania urządzeń: ${snapshot.error}'),
            );
          } else if (viewModel.devices.isEmpty) {
            return const Center(
              child: Text('Brak dostępnych urządzeń'),
            );
          } else {
            return ListView(
              children: [
                // Wybór urządzenia
                ListTile(
                  title: const Text('Wybierz urządzenie'),
                  subtitle: viewModel.selectedDeviceId != null
                      ? Text(
                          'Wybrane urządzenie: ${viewModel.selectedDeviceId}')
                      : const Text('Brak urządzenia'),
                  trailing: DropdownButton<String>(
                    value: viewModel.selectedDeviceId,
                    items: viewModel.devices.map((device) {
                      return DropdownMenuItem<String>(
                        value: '${device.deviceId}',
                        child: Text(device.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.selectDevice(value);
                      }
                    },
                  ),
                ),

                ListTile(
                  title: const Text('Maksymalna ilość wody w pojemniku'),
                  subtitle: Text('${viewModel.maxWaterAmount} ml'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Ustaw maksymalną ilość wody'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              controller: newWaterAmountController,
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
                                  await viewModel.setDeviceWaterTarget(
                                      int.parse(newWaterAmountController.text));
                                  Navigator.pop(context);
                                },
                                child: const Text('Zapisz'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

                ListTile(
                  title: const Text('Domyślna ilość wody'),
                  subtitle: Text('${viewModel.defaultWaterAmount} ml'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Ustaw domyślną ilość wody'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              controller: newWaterAmountController,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Anuluj'),
                              ),
                              TextButton(
                                onPressed: () {
                                  viewModel.setDefaultWaterAmount(
                                      int.parse(newWaterAmountController.text));
                                  Navigator.pop(context);
                                },
                                child: const Text('Zapisz'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Reset tary'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      viewModel.resetTare(3).then((message) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                        ));
                      });
                    },
                    child: const Text('Resetuj'),
                  ),
                ),
                ListTile(
                  title: const Text('Usuń alarm'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      DateTime? selectedDate;
                      TimeOfDay? selectedTime;

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Usuń alarm'),
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
                                      selectedDate = pickedDate;
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
                                      selectedTime = pickedTime;
                                    }
                                  },
                                  child: const Text('Wybierz czas'),
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
                                onPressed: () {
                                  if (selectedDate != null &&
                                      selectedTime != null) {
                                    final selectedDateTime = DateTime(
                                      selectedDate!.year,
                                      selectedDate!.month,
                                      selectedDate!.day,
                                      selectedTime!.hour,
                                      selectedTime!.minute,
                                    );
                                    // Formatowanie do formatu JavaScript (UTC z "Z")
                                    final formattedDateTime = selectedDateTime
                                        .toUtc()
                                        .toIso8601String();

                                    viewModel.deleteAlarm(3, formattedDateTime);
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('Usuń'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Pobierz czas urządzenia'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      viewModel.getDeviceTime(3).then((time) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(time),
                        ));
                      });
                    },
                    child: const Text('Pobierz'),
                  ),
                ),
                ListTile(
                  title: const Text('Ustaw czas urządzenia'),
                  trailing: IconButton(
                    icon: const Icon(Icons.update),
                    onPressed: () {
                      DateTime? selectedDate;
                      TimeOfDay? selectedTime;

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Ustaw czas urządzenia'),
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
                                      selectedDate = pickedDate;
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
                                      selectedTime = pickedTime;
                                    }
                                  },
                                  child: const Text('Wybierz czas'),
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
                                onPressed: () {
                                  if (selectedDate != null &&
                                      selectedTime != null) {
                                    final selectedDateTime = DateTime(
                                      selectedDate!.year,
                                      selectedDate!.month,
                                      selectedDate!.day,
                                      selectedTime!.hour,
                                      selectedTime!.minute,
                                    );
                                    final formattedDateTime = selectedDateTime
                                        .toUtc()
                                        .toIso8601String();
                                    viewModel.setDeviceTime(
                                        3, formattedDateTime);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Time set to: $formattedDateTime'),
                                    ));
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('Ustaw'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
