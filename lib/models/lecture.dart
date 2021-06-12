import 'package:flutter/material.dart';

class Lecture {
  bool free;
  int length;
  TimeOfDay time;
  String name;
  Lecture({this.length, this.name, this.free, this.time});
}
