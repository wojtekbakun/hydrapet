import 'package:flutter/material.dart';

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
