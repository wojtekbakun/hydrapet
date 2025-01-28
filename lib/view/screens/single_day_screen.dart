import 'package:flutter/material.dart';
import 'package:hydrapet/view/components/time_for_water_refilling.dart';
import 'package:hydrapet/view/components/water_schedule_dialog.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SingleDayScreen extends StatefulWidget {
  final DateTime? pickedDate;
  const SingleDayScreen({
    super.key,
    this.pickedDate,
  });

  @override
  State<SingleDayScreen> createState() => _SingleDayScreenState();
}

class _SingleDayScreenState extends State<SingleDayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScheduleViewModel>(
        builder: (context, viewModel, child) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Column(
                      children: [
                        Text(
                          widget.pickedDate == null
                              ? 'Domyślny harmonogram'
                              : '${widget.pickedDate!.day} ${DateFormat.MMMM().format(widget.pickedDate!)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Wykorzystano x}/${viewModel.maxWaterAmount}ml',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => WaterScheduleDialog(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialWaterAmount: viewModel.defaultWaterAmount)
                          .show(),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 0,
                    itemBuilder: (BuildContext context, int index) {
                      return TimeForWaterRefilling(
                        viewModel: viewModel,
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
