import 'package:flutter/material.dart';
import 'package:hydrapet/data/repository/schedule_model_repository.dart';
import 'package:hydrapet/view_models/home_page_view_model.dart';
import 'package:hydrapet/views/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomePageViewModel(repository: ScheduleRepository()),
        ),
      ],
      child: const HomeScreen(),
    ),
  );
}
