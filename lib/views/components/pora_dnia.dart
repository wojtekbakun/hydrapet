import 'package:flutter/material.dart';

class PoraDnia extends StatefulWidget {
  final String poraDnia;
  final DateTime data;
  const PoraDnia({
    super.key,
    required this.poraDnia,
    required this.data,
  });

  @override
  State<PoraDnia> createState() => _PoraDniaState();
}

class _PoraDniaState extends State<PoraDnia> {
  String poraDnia = 'ustaw';
  TimeOfDay timeOfDay = TimeOfDay.now();

  Future<dynamic> displayTimePicker(BuildContext context) async {
    TimeOfDay? time =
        await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        poraDnia = "${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.poraDnia),
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
