import 'package:flutter/material.dart';
import 'package:hydrapet/view_models/home_page_view_model.dart';
import 'package:provider/provider.dart';

class ZapiszDane extends StatefulWidget {
  const ZapiszDane({super.key});

  @override
  State<ZapiszDane> createState() => _ZapiszDaneState();
}

class _ZapiszDaneState extends State<ZapiszDane> {
  late HomePageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<HomePageViewModel>(context, listen: false);
    //viewModel.repository.getScheduleFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => viewModel.saveScheduleToLocalStorage(),
      child: const Row(
        children: [
          Icon(Icons.add),
          Text('Zapisz dane'),
        ],
      ),
    );
  }
}
