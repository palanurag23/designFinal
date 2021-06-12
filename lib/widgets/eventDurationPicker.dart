import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class DurationPicker extends StatefulWidget {
  DurationPicker({Key key}) : super(key: key);

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  NumberPicker hours;
  int currentHours = 1;
  NumberPicker minutes;
  int currentMinutes = 0;
  @override
  Widget build(BuildContext context) {
    _initializeNumberPickers();
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('${currentHours}h ${currentMinutes}min'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('${currentHours}h'), hours],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('${currentMinutes}mins'), minutes],
            ),
            ElevatedButton(
                onPressed: () {
                  Provider.of<AddEventScreenData>(context, listen: false)
                      .setMinutes(currentMinutes);
                  Provider.of<AddEventScreenData>(context, listen: false)
                      .setHours(currentHours);
                  Navigator.of(context).pop();
                },
                child: Text('ok'))
          ],
        ),
      ),
    );
  }

  void _initializeNumberPickers() {
    hours = new NumberPicker.integer(
      initialValue: currentHours,
      minValue: 1,
      step: 1,
      maxValue: 240,
      onChanged: (v) {
        setState(() {
          currentHours = v;
        });
      },
    );
    minutes = new NumberPicker.integer(
      initialValue: currentMinutes,
      minValue: 0,
      step: 1,
      maxValue: 59,
      onChanged: (v) {
        setState(() {
          currentMinutes = v;
        });
      },
    );
  }
}
