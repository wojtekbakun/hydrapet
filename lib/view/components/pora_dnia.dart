import 'package:flutter/material.dart';
import 'package:hydrapet/model/mini_schedule_model.dart';
import 'package:hydrapet/view/components/time_for_water_refilling.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';

class PoraDnia extends StatefulWidget {
  final ScheduleViewModel viewModel;

  const PoraDnia({
    super.key,
    required this.viewModel,
  });

  @override
  State<PoraDnia> createState() => _PoraDniaState();
}

class _PoraDniaState extends State<PoraDnia> {
  String poraDnia = 'set';

  Future<DateTime?> displayDatePicker(BuildContext context) => showDatePicker(
      context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));

  Future<dynamic> chooseDate(BuildContext context) async {
    final pickedDate = await displayDatePicker(context);

    if (pickedDate != null) {
      TimeOfDay? pickedTimeOfDay =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if (pickedTimeOfDay != null) {
        setState(() {
          poraDnia =
              "${pickedTimeOfDay.hour}:${pickedTimeOfDay.minute < 10 ? '0' : ''}${pickedTimeOfDay.minute}";

          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTimeOfDay.hour,
            pickedTimeOfDay.minute,
          );

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
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => chooseDate(context),
            icon: const Icon(Icons.add),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 0,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return TimeForWaterRefilling(
                  viewModel: widget.viewModel,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
