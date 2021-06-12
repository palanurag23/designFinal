import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class YearPicker extends StatefulWidget {
  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  // int joiningYear;
  NumberPicker year;
  int initialYearValue = DateTime.now().year;
  int joiningYear = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    _initializeNumberPickers();
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('joining  $joiningYear'), year],
            ),
            ElevatedButton(
                onPressed: () {
                  Provider.of<ProfileData>(context, listen: false)
                      .setYear(joiningYear);
                  Navigator.of(context).pop();
                },
                child: Text('ok'))
          ],
        ),
      ),
    );
  }

  void _initializeNumberPickers() {
    year = new NumberPicker.integer(
      initialValue: joiningYear,
      minValue: initialYearValue - 10,
      step: 1,
      maxValue: initialYearValue + 10,
      onChanged: (v) {
        setState(() {
          joiningYear = v;
        });
      },
    );
  }
}
