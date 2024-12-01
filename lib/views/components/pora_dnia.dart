import 'package:flutter/material.dart';
import 'package:hydrapet/data/data_models/schedule_model.dart';
import 'package:hydrapet/view_models/home_page_view_model.dart';
import 'package:provider/provider.dart';

class PoraDnia extends StatefulWidget {
  final PartOfTheDay partOfTheDay;
  const PoraDnia({
    super.key,
    required this.partOfTheDay,
  });

  @override
  State<PoraDnia> createState() => _PoraDniaState();
}

class _PoraDniaState extends State<PoraDnia> {
  String poraDnia = 'ustaw';
  TimeOfDay timeOfDay = TimeOfDay.now();
  late HomePageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<HomePageViewModel>(context, listen: false);
    //viewModel.repository.getScheduleFromLocalStorage();
  }

  Future<dynamic> displayTimePicker(BuildContext context) async {
    TimeOfDay? time =
        await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        poraDnia = "${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}";
        //!TODO dodać zapis czasu do konkretnej pory dnia
        //viewModel.updateTime(widget.partOfTheDay, time);
      });
    }
  }

  String partOfTheDayToString(PartOfTheDay partOfTheDay) {
    switch (partOfTheDay) {
      case PartOfTheDay.morning:
        return 'Rano';
      case PartOfTheDay.afternoon:
        return 'Południe';
      case PartOfTheDay.evening:
        return 'Wieczór';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(partOfTheDayToString(widget.partOfTheDay)),
        TextButton(
          onPressed: () => displayTimePicker(context),
          child: Text(
            poraDnia,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
