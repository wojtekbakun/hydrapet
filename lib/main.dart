import 'package:flutter/material.dart';
import 'package:hydrapet/view_models/home_page_view_model.dart';
import 'package:hydrapet/views/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomePageViewModel(),
        ),
      ],
      child: const HomeScreen(),
    ),
  );
}
