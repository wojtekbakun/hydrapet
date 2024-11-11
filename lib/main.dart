import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dni lania wody',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
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
                Text(
                  'Godziny lania wody',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rano'),
                      Text('Południe'),
                      Text('Wieczór'),
                    ],
                  ),
                ),
                Text(
                  'Ilość wody',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('300ml'),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

class NazwaDnia extends StatelessWidget {
  final String dzien;
  const NazwaDnia({super.key, required this.dzien});

  @override
  Widget build(BuildContext context) {
    return Text(dzien);
  }
}
