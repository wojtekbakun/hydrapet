import 'package:flutter/material.dart';
import 'package:hydrapet/repository/schedule_model_repository.dart';
import 'package:hydrapet/view/components/time_for_water_refilling.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SingleDayScreen extends StatefulWidget {
  final DateTime? pickedDate;
  const SingleDayScreen({super.key, required this.pickedDate});

  @override
  State<SingleDayScreen> createState() => _SingleDayScreenState();
}

class _SingleDayScreenState extends State<SingleDayScreen> {
  // !TODO - refactor to use provider
  final ScheduleViewModel viewModel =
      ScheduleViewModel(repository: ScheduleRepository());

  Future<dynamic> chooseDate(BuildContext context) async {
    TimeOfDay? pickedTimeOfDay =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (widget.pickedDate != null) {
      if (pickedTimeOfDay != null) {
        setState(() {
          final newDateTime = DateTime(
            widget.pickedDate!.year,
            widget.pickedDate!.month,
            widget.pickedDate!.day,
            pickedTimeOfDay.hour,
            pickedTimeOfDay.minute,
          );
          viewModel.addNewWateringTime(newDateTime);
          debugPrint('wybrana data: $newDateTime');
        });
      } else {
        debugPrint('Nie wybrano godziny');
        return;
      }
    } else {
      debugPrint('Nie wybrano daty');
      return;
    }
  }

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
                          '${widget.pickedDate!.day} ${DateFormat.MMMM().format(widget.pickedDate!)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Wykorzystano 350/1000ml',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => chooseDate(context),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        viewModel.getSchedule().wateringTimes?.length ?? 1,
                    itemBuilder: (BuildContext context, int index) {
                      return TimeForWaterRefilling(
                          viewModel: viewModel, index: index);
                    },
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 24.0),
                //   child: PoraDnia(
                //     viewModel: viewModel,
                //   ),
                // ),
                // Text(
                //   'Ilość wody',
                //   style: Theme.of(context).textTheme.headlineSmall,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 24.0),
                //   child: IloscWody(viewModel: viewModel),
                // ),
                // const Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     ZapiszDane(),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
