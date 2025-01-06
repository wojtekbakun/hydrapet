import 'package:flutter/material.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  TextEditingController newWaterAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          // set max water amount
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
                          onPressed: () {
                            viewModel.setMaxWaterAmount(
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
            title: const Text('Powiadomienia'),
            subtitle: const Text('Włącz/Wyłącz'),
            trailing: Switch(
              //value: viewModel.notificationsEnabled,
              value: true,
              onChanged: (value) {
                //100 viewModel.setNotificationsEnabled(value);
              },
            ),
          ),
          // create default schedule
          ListTile(
            title: const Text('Domyślny harmonogram'),
            subtitle: const Text('13.00, 14.00, 15.00'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // viewModel.createDefaultSchedule();
              },
            ),
          ),
        ],
      )),
    );
  }
}
