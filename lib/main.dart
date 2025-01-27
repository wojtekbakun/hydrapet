import 'package:flutter/material.dart';
import 'package:hydrapet/repository/device_repository.dart';
import 'package:hydrapet/repository/schedule_model_repository.dart';
import 'package:hydrapet/view/screens/login_page.dart';
import 'package:hydrapet/view/screens/register_page.dart';
import 'package:hydrapet/view/screens/settings_screen.dart';
import 'package:hydrapet/view/screens/single_day_screen.dart';
import 'package:hydrapet/view/screens/home_screen.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final scheduleRepository = ScheduleRepository();
  final deviceRepository = DeviceRepository('http://0.0.0.0:3000');
  final scheduleViewModel = ScheduleViewModel(
      repository: scheduleRepository, deviceRepository: deviceRepository);

  // Inicjalizacja tokenu JWT
  await scheduleViewModel.initScheduleViewModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => scheduleViewModel,
        ),
      ],
      child: MyApp(
          initialRoute: scheduleViewModel.isAuthenticated() ? '/' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomeScreen(),
        '/single_day': (context) => SingleDayScreen(
              pickedDate: DateTime.now(),
            ),
        '/settings': (context) => SettingsScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      initialRoute: initialRoute,
    );
  }
}
