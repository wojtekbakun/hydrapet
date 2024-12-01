import 'package:flutter/material.dart';
import 'package:hydrapet/data/data_models/schedule_model.dart';
import 'package:hydrapet/models/mqtt_server_client.dart' as mqtt;
import 'package:hydrapet/views/components/ilosc_wody.dart';
import 'package:hydrapet/views/components/nazwa_dnia.dart';
import 'package:hydrapet/views/components/pora_dnia.dart';
import 'package:hydrapet/views/components/zapisz_dane.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //mqtt.main();
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dni lania wody',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NazwaDnia(dzien: 'Pn'),
                        NazwaDnia(dzien: 'Wt'),
                        NazwaDnia(dzien: 'Śr'),
                        NazwaDnia(dzien: 'Cz'),
                        NazwaDnia(dzien: 'Pt'),
                        NazwaDnia(dzien: 'So'),
                        NazwaDnia(dzien: 'Nd'),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Godziny lania wody',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PoraDnia(
                        partOfTheDay: PartOfTheDay.morning,
                      ),
                      PoraDnia(
                        partOfTheDay: PartOfTheDay.afternoon,
                      ),
                      PoraDnia(
                        partOfTheDay: PartOfTheDay.evening,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Ilość wody',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: IloscWody(),
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ZapiszDane(),
                  ],
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
