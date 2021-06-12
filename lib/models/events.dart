import 'package:flutter/material.dart';

class Event with ChangeNotifier {
  String name;
  int id;
  bool favorite;
  String owner;
  DateTime dateime;
  String eventType;
  Event(
      {this.dateime,
      this.eventType,
      this.id,
      this.name,
      this.owner,
      this.favorite});
}

class EventDetails with ChangeNotifier {
  int id;
  String owner;
  String name;
  num latitude;
  num longitute;
  String description;
  DateTime dateTime;
  String duration;
  String type;
  bool registered;
  int count;
  EventDetails({
    this.id,
    this.owner,
    this.name,
    this.latitude,
    this.longitute,
    this.description,
    this.dateTime,
    this.duration,
    this.type,
    this.registered,
    this.count,
  });
}
