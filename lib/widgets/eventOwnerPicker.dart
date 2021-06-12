import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:provider/provider.dart';

class OwnerPicker extends StatefulWidget {
  OwnerPicker({Key key}) : super(key: key);

  @override
  _OwnerPickerState createState() => _OwnerPickerState();
}

class _OwnerPickerState extends State<OwnerPicker> {
  NumberPicker owner;
  int currentOwner = 1;

  @override
  Widget build(BuildContext context) {
    _initializeNumberPickers();
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('$currentOwner owner'),
            owner,
            ElevatedButton(
                onPressed: () {
                  // Provider.of<AddEventScreenData>(context, listen: false)
                  //     .setOwner(currentOwner);

                  Navigator.of(context).pop();
                },
                child: Text('ok'))
          ],
        ),
      ),
    );
  }

  void _initializeNumberPickers() {
    owner = new NumberPicker.integer(
      initialValue: currentOwner,
      minValue: 1,
      step: 1,
      maxValue: 50,
      onChanged: (v) {
        setState(() {
          currentOwner = v;
        });
      },
    );
  }
}
