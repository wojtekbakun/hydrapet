import 'package:flutter/material.dart';
import 'package:hydrapet/view/components/water_schedule_dialog.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';

class TimeForWaterRefilling extends StatelessWidget {
  final bool? isDefault;
  final ScheduleViewModel viewModel;
  final int index;
  const TimeForWaterRefilling(
      {super.key,
      this.isDefault,
      required this.viewModel,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // show dialog with delete confirmation
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Czy na pewno chcesz usunąć?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Anuluj'),
                  ),
                  TextButton(
                    onPressed: () {
                      viewModel.removeMiniSchedule(index);
                      Navigator.pop(context);
                    },
                    child: const Text('Usuń'),
                  ),
                ],
              );
            });
      },
      child: Card(
        child: ListTile(
          title: Text(
            '${viewModel.getMiniSchedules()[index].waterAmount}ml',
          ),
          subtitle: Text(
            // display time with 0 in front if needed
            '${viewModel.getMiniSchedules()[index].time.hour.toString().padLeft(2, '0')}:${viewModel.getMiniSchedules()[index].time.minute.toString().padLeft(2, '0')}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => WaterScheduleDialog(
              context: context,
              initialTime: TimeOfDay.now(),
              isEdit: true,
              index: index,
              initialWaterAmount: 0,
            ).show(),
          ),
        ),
      ),
    );
  }
}

// create empty alert dialog





// showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text('Podaj ilość wody'),
//                     content: TextField(
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         viewModel.getMiniSchedules()[index].waterAmount =
//                             int.parse(value);
//                       },
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Anuluj'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           viewModel.notifyListeners();
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Zapisz'),
//                       ),
//                     ],
//                   );
//                 },
//               );