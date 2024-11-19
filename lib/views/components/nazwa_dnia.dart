import 'package:flutter/material.dart';

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
