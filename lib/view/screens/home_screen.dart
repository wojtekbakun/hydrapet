import 'package:flutter/material.dart';
import 'package:hydrapet/view/screens/single_day_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<DateTime?> displayDatePicker(BuildContext context) => showDatePicker(
      context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));

  @override
  Widget build(BuildContext context) {
    //mqtt.main();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aktualny poziom wody',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Expanded(
                          child: Center(
                              child: Text(
                        '50%',
                        style: TextStyle(
                          fontSize: 50,
                        ),
                      ))),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ustaw plan',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                          onPressed: () async {
                            final pickedDate = await displayDatePicker(context);
                            if (pickedDate != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingleDayScreen(
                                          pickedDate: pickedDate,
                                        )),
                              );
                            } else {
                              debugPrint('Nie wybrano daty');
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.calendar_today),
                              Text('Wybierz dzień'),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
