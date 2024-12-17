import 'package:flutter/material.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';

class TimeForWaterRefilling extends StatelessWidget {
  final ScheduleViewModel viewModel;
  final int index;
  const TimeForWaterRefilling(
      {super.key, required this.viewModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('100ml'),
        subtitle: Text(
            '${viewModel.schedule.wateringTimes![index].hour}:${viewModel.schedule.wateringTimes![index].minute}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
      ),
    );
  }
}
