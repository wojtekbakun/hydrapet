import 'package:flutter/material.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';

class IloscWody extends StatefulWidget {
  final ScheduleViewModel viewModel;
  const IloscWody({super.key, required this.viewModel});

  @override
  State<IloscWody> createState() => _IloscWodyState();
}

class _IloscWodyState extends State<IloscWody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
            min: 100,
            max: 333,
            value: widget.viewModel.schedule.waterAmount ?? 100,
            onChanged: (value) {
              widget.viewModel.updateWaterAmount(value);
            }),
        Text('${widget.viewModel.schedule.waterAmount?.floor().toString()} ml'),
      ],
    );
  }
}
