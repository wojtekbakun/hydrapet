import 'package:flutter/material.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';
import 'package:provider/provider.dart';

class ZapiszDane extends StatefulWidget {
  const ZapiszDane({super.key});

  @override
  State<ZapiszDane> createState() => _ZapiszDaneState();
}

class _ZapiszDaneState extends State<ZapiszDane> {
  late ScheduleViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    //viewModel.repository.getScheduleFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      //onPressed: () => viewModel.saveScheduleToLocalStorage(),
      child: const Row(
        children: [
          Icon(Icons.add),
          Text('Zapisz dane'),
        ],
      ),
    );
  }
}
