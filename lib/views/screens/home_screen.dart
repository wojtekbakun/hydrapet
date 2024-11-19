import 'package:flutter/material.dart';
import 'package:hydrapet/views/components/ilosc_wody.dart';
import 'package:hydrapet/views/components/nazwa_dnia.dart';
import 'package:hydrapet/views/components/pora_dnia.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        poraDnia: 'Rano',
                      ),
                      PoraDnia(
                        poraDnia: 'Południe',
                      ),
                      PoraDnia(
                        poraDnia: 'Wieczór',
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
              ],
            ),
          )),
        ),
      ),
    );
  }
}
