import 'package:flutter/material.dart';
import 'package:hydrapet/view_models/home_page_view_model.dart';

class IloscWody extends StatefulWidget {
  final HomePageViewModel viewModel;
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
