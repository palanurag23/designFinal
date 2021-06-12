import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class RollNumberPicker extends StatefulWidget {
  @override
  _RollNumberPickerState createState() => _RollNumberPickerState();
}

class _RollNumberPickerState extends State<RollNumberPicker> {
  NumberPicker rollNum;
  int rollNumber = 10;

  @override
  Widget build(BuildContext context) {
    _initializeNumberPickers();
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('roll num  $rollNumber'), rollNum],
            ),
            ElevatedButton(
                onPressed: () {
                  Provider.of<ProfileData>(context, listen: false)
                      .setRollNumber(rollNumber);
                  Navigator.of(context).pop();
                },
                child: Text('ok'))
          ],
        ),
      ),
    );
  }

  void _initializeNumberPickers() {
    rollNum = new NumberPicker.integer(
      initialValue: rollNumber,
      minValue: 1,
      step: 1,
      maxValue: 999,
      onChanged: (v) {
        setState(() {
          rollNumber = v;
        });
      },
    );
  }
}
