import 'package:flutter/material.dart';
import 'package:hydrapet/model/mini_schedule_model.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';
import 'package:provider/provider.dart';

class WaterScheduleDialog {
  final BuildContext context;
  final TimeOfDay initialTime;
  final int initialWaterAmount;
  final bool isEdit;
  final int index;

  WaterScheduleDialog({
    required this.context,
    required this.initialTime,
    required this.initialWaterAmount,
    this.isEdit = false,
    this.index = 0,
  });

  Future<Map<String, dynamic>?> show() async {
    TimeOfDay pickedTimeOfDay = initialTime;
    TextEditingController waterAmountController =
        TextEditingController(text: initialWaterAmount.toString());

    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edytuj'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: waterAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ilość wody w ml',
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: pickedTimeOfDay,
                  );
                  if (picked != null) {
                    pickedTimeOfDay = picked;
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
                if (waterAmountController.text.isNotEmpty) {
                  final waterAmount =
                      int.tryParse(waterAmountController.text) ?? 0;
                  int retVal = isEdit
                      ? viewModel.editMiniSchedule(
                          index,
                          MiniScheduleModel(
                              time: pickedTimeOfDay, waterAmount: waterAmount),
                        )
                      : viewModel.addNewSchedule(
                          MiniScheduleModel(
                              time: pickedTimeOfDay, waterAmount: waterAmount),
                        );
                  Navigator.pop(context);
                  retVal == 0
                      ? null
                      //show snackbar
                      : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Błąd - przekroczono maksymalną ilość wody'),
                          ),
                        );
                } else {
                  debugPrint('Nie wybrano ilości wody');
                }
              },
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );
  }
}
