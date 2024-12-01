import 'package:flutter/material.dart';
import 'package:hydrapet/view_models/home_page_view_model.dart';
import 'package:provider/provider.dart';

class IloscWody extends StatefulWidget {
  const IloscWody({super.key});

  @override
  State<IloscWody> createState() => _IloscWodyState();
}

class _IloscWodyState extends State<IloscWody> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<HomePageViewModel>(context, listen: false);
    viewModel.loadWaterAmountFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomePageViewModel>(context);
    return Column(
      children: [
        Slider(
            min: 100,
            max: 333,
            value: viewModel.schedule.waterAmount ?? 100,
            onChanged: (value) {
              viewModel.updateWaterAmount(value);
            }),
        Text('${viewModel.schedule.waterAmount?.floor().toString()} ml'),
      ],
    );
  }
}
