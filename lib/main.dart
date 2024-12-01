import 'package:flutter/material.dart';
import 'package:hydrapet/repository/schedule_model_repository.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';
import 'package:hydrapet/view/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ScheduleViewModel(repository: ScheduleRepository()),
        ),
      ],
      child: const HomeScreen(),
    ),
  );
}
