import 'package:flutter/material.dart';
import 'package:hydrapet/repository/my_mqtt_client.dart';
import 'package:hydrapet/view/screens/settings_screen.dart';
import 'package:hydrapet/view/screens/single_day_screen.dart';
import 'package:hydrapet/view_model/schedule_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<DateTime?> displayDatePicker(BuildContext context) => showDatePicker(
      context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));

  @override
  void initState() {
    //connectToBroker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Giga Hydrapet skibidi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  //Status icon
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.info),
                  ),
                  Text('Stan urządzenia'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.calendar_today),
                  ),
                  Text('Harmonogram'),
                ],
              ),
              onTap: () async {
                Navigator.pop(context);
                final pickedDate = await displayDatePicker(context);
                if (pickedDate != null) {
                  viewModel.setPickedDate(pickedDate);
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
            ),
            ListTile(
              title: const Row(
                children: [
                  //Status icon
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.settings),
                  ),
                  Text('Ustawienia'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
            //logout
            ListTile(
              title: const Row(
                children: [
                  //Status icon
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.logout),
                  ),
                  Text('Wyloguj'),
                ],
              ),
              onTap: () async {
                await viewModel.logout();

                Navigator.pushReplacementNamed(
                    context, '/login'); // Przejście do logowania
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Hydrapet'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '💦',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Expanded(
                      // add button to make single water refill and show current water amount
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${viewModel.getWaterPercentage()}%',
                            style: const TextStyle(
                              fontSize: 50,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint(
                                  'pcked date ${viewModel.pickedDate.toString()}');
                              int retVal = viewModel.doOneTimeWatering();

                              retVal == -1
                                  ? ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Nie mozna dolać więcej wody, limit został wyczerpany.',
                                        ),
                                      ),
                                    )
                                  //show snackbar
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Dolano wody',
                                        ),
                                      ),
                                    );
                            },
                            child: const Text('Napełnij'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '🔋',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${viewModel.getBatteryLevel()}%',
                          style: const TextStyle(
                            fontSize: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
