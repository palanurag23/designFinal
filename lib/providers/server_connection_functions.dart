import '../models/events.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
//import 'package:path/path.dart' as path; //otherwise context error

class Server_Connection_Functions {
  Future<bool> registerForEvent(
    int eventId,
    BuildContext context,
  ) async {
    String username =
        Provider.of<UsernameData>(context, listen: false).username[0];
    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersRegisterEvent = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {
      "username": "$username",
      "event_id": "$eventId",
    };
    http.Response response = await http.post(
        Uri.https('dtu-otg.herokuapp.com', 'events/register/'),
        headers: headersRegisterEvent,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code register event $statusCode');

    print(response.body);
    Map<String, dynamic> resp = json.decode(response.body);
    if (resp['status'] == "OK")
      Provider.of<EventsData>(context, listen: false)
          .changeFavoriteStatus(eventId);
    return resp['status'] == "OK" ? true : false; //return registration status
  }

  Future<bool> unregisterForEvent(int eventId, BuildContext context) async {
    String username =
        Provider.of<UsernameData>(context, listen: false).username[0];
    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersUnregisterEvent = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {
      "username": "$username",
      "event_id": "$eventId",
    };
    http.Response response = await http.post(
        Uri.https('dtu-otg.herokuapp.com', 'events/unregister/'),
        headers: headersUnregisterEvent,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code unregister event $statusCode');

    print(response.body);
    Map<String, dynamic> resp = json.decode(response.body);
    if (resp['status'] == "OK")
      Provider.of<EventsData>(context, listen: false)
          .changeFavoriteStatus(eventId);
    return resp['status'] == "OK"
        ? false
        : true; //return registration status not unregistration status
  }

  Future<bool> fetchListOfEvents(BuildContext context) async {
    List<Event> eves = [];
    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    print('///////access token event fetch');
    var accessTokenValue = accessToken[0];
    Map<String, String> headersEvents = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    http.Response response = await http.get(
      Uri.https('dtu-otg.herokuapp.com', 'events'),
      headers: headersEvents,
    );
    int statusCode = response.statusCode;
    List<dynamic> resp = json.decode(response.body);
    eves = resp.map<Event>((e) {
      return Event(
        favorite: e['registered'],
        name: e['name'],
        owner: e['owner'],
        id: e['id'],
        eventType: e['type_event'],
        dateime: DateTime.parse(e['date_time']),
      );
    }).toList();
    Provider.of<EventsData>(context, listen: false).setEvents(eves);
    print(resp);
    return true;
  }

  Future<dynamic> createEvent(
      BuildContext context,
      String name,
      String description,
      int type,
      DateTime dateTime,
      TimeOfDay timeOfDay) async {
    print('x1');
    var hours =
        await Provider.of<AddEventScreenData>(context, listen: false).hours;
    print('$hours');
    int minutes =
        await Provider.of<AddEventScreenData>(context, listen: false).minutes;
    print('$minutes');

    var accessToken =
        await Provider.of<AccessTokenData>(context, listen: false).accessToken;
    print('$accessToken');

    var accessTokenValue = accessToken[0];
    print('1');
//it takes time to fetch and function moves on..
//its better to fetch it on loading screen
//await Provider.of<OwnerIdData>(context, listen: false).fetchAndSetData();
    int owner1 = Provider.of<OwnerIdData>(context, listen: false).ownerID[0];
    Map<String, String> headersCreateEvent = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    print('1');
    DateTime date_time = DateTime(dateTime.year, dateTime.month, dateTime.day,
        timeOfDay.hour, timeOfDay.minute);
    print('1');
    Map mapjsonBody = {
      "owner": owner1,
      "name": "$name",
      "description": "$description",
      "date_time": "${date_time.toIso8601String()}",
      "duration": "$hours:$minutes:00",
      "latitude": "27.204600000",
      "longitude": "77.497700000",
      "type_event": "${type.toString()}",
      "user_registered": true
    };
    print('1');
    http.Response response = await http.post(
        Uri.https('dtu-otg.herokuapp.com', 'events/create/'),
        headers: headersCreateEvent,
        body: json.encode(mapjsonBody));
    print('///////resp CREATE EVENT  ${response.body}');
    print('1');
    Map<String, dynamic> resp = json.decode(response.body);
    return resp;
  }

  Future<dynamic> invite(String email, BuildContext context) async {
    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersInvite = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {"email": "$email"};
    http.Response response = await http.post(
        Uri.https('dtu-otg.herokuapp.com', 'auth/send-email/'),
        headers: headersInvite,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code register event $statusCode');
    Map<String, dynamic> resp = json.decode(response.body);
    return resp;
  }

  //
  Future<Map<String, dynamic>> timeTableDownload(BuildContext context) async {
    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    var accessTokenValue = accessToken[0];
    print('1');

    Map<String, String> headersTimeTable = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    print('2');
    http.Response response = await http.get(
      Uri.https('dtu-otg.herokuapp.com', 'timetable/',
          {"year": "2k19", "batchgrp": "A", "batchnum": "1"}),
      headers: headersTimeTable,
    );
    print('3');
    int statusCode = response.statusCode;

    Map<String, dynamic> resp = json.decode(json.decode(response.body));
    print(statusCode);
    print(resp.toString());
    print('${DateTime.now().weekday}weekday');
    //
    await Provider.of<TimeTableData>(context, listen: false).set(resp);

    //
    return resp;
  }
}
