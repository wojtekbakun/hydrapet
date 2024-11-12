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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PoraDnia(
                          poraDnia: 'Rano',
                          data: DateTime(DateTime.april, 7, 30, 10, 0)),
                      PoraDnia(
                          poraDnia: 'Południe',
                          data: DateTime(DateTime.april, 12, 30, 14, 0)),
                      PoraDnia(
                          poraDnia: 'Wieczór',
                          data: DateTime(DateTime.april, 18, 30, 20, 0)),
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

class NazwaDnia extends StatefulWidget {
  final String dzien;
  const NazwaDnia({super.key, required this.dzien});

  @override
  State<NazwaDnia> createState() => _NazwaDniaState();
}

class _NazwaDniaState extends State<NazwaDnia> {
  bool isChecked = true;

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => toggleCheckbox(),
      child: Row(
        children: [
          Icon(isChecked ? Icons.check_circle : Icons.circle),
          const SizedBox(width: 8.0),
          Text(
            widget.dzien,
          ),
        ],
      ),
    );
  }
}

class PoraDnia extends StatefulWidget {
  final String poraDnia;
  final DateTime data;
  const PoraDnia({
    super.key,
    required this.poraDnia,
    required this.data,
  });

  @override
  State<PoraDnia> createState() => _PoraDniaState();
}

class _PoraDniaState extends State<PoraDnia> {
  String poraDnia = 'set time';
  TimeOfDay timeOfDay = TimeOfDay.now();

  Future<dynamic> displayTimePicker(BuildContext context) async {
    TimeOfDay? time =
        await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        poraDnia = "${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.poraDnia),
        TextButton(
          onPressed: () => displayTimePicker(context),
          child: Text(
            poraDnia,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}

class IloscWody extends StatefulWidget {
  const IloscWody({super.key});

  @override
  State<IloscWody> createState() => _IloscWodyState();
}

class _IloscWodyState extends State<IloscWody> {
  double _value = 333;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
            min: 100,
            max: 333,
            value: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            }),
        Text('${_value.floor().toString()} ml'),
      ],
    );
  }
}
