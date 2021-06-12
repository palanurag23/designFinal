import 'package:nilay_dtuotg_2/models/events.dart';
import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path; //otherwise context error
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/events.dart';

class EventsDetailScreen extends StatefulWidget {
  static const routeName = '/EventsDetailScreen';
  EventsDetailScreen({Key key}) : super(key: key);

  @override
  _EventsDetailScreenState createState() => _EventsDetailScreenState();
}

class _EventsDetailScreenState extends State<EventsDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool initialized = false;
  bool waiting = true;
  Map<String, dynamic> resp;
  EventDetails _eventDetails;
  ScreenArguments args;
  @override
  void didChangeDependencies() async {
    args = ModalRoute.of(context).settings.arguments;
    int eventID = args.id;
    if (!initialized) {
      var accessToken =
          Provider.of<AccessTokenData>(context, listen: false).accessToken;
      var accessTokenValue = accessToken[0];
      Map<String, String> headersEventDetails = {
        "Content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Bearer $accessTokenValue"
      };
      http.Response response = await http.get(
        Uri.https('dtu-otg.herokuapp.com', 'events/details/$eventID'),
        headers: headersEventDetails,
      );
      print('/////////$eventID');
      int statusCode = response.statusCode;
      resp = json.decode(response.body);
      print('//////$resp');
      _eventDetails = EventDetails(
          id: resp['id'],
          owner: resp['owner'] == null ? ' ' : ' ',
          name: resp['name'],
          longitute: num.parse(resp['longitude']),
          description: resp['description'],
          duration: resp['duration'],
          registered: resp['registered'],
          type: resp['type_event'],
          count: resp['count'],
          dateTime: DateTime.parse(resp['date_time']),
          latitude: num.parse(resp['latitude']));
      print('//////$resp');
      initialized = true;
      setState(() {
        waiting = false;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('eve detail'),
      ),
      body: Container(
        child: Center(
            child: waiting
                ? CircularProgressIndicator()
                : ListView(
                    children: [
                      ListTile(
                        title: Text('id:  ${_eventDetails.id.toString()}'),
                      ),
                      ListTile(
                        title: Text('owner ${_eventDetails.owner}'),
                      ),
                      ListTile(
                        title: Text('name ${_eventDetails.name}'),
                      ),
                      ListTile(
                        title: Text(
                            'latitude ${_eventDetails.latitude.toString()}'),
                      ),
                      ListTile(
                        title: Text(
                            'longitude ${_eventDetails.longitute.toString()}'),
                      ),
                      ListTile(
                        title: Text('description ${_eventDetails.description}'),
                      ),
                      ListTile(
                        title: Text(
                            'day${_eventDetails.dateTime.day}month${_eventDetails.dateTime.month}'),
                      ),
                      ListTile(
                        title: Text('duration ${_eventDetails.duration}'),
                      ),
                      ListTile(
                        title: Text('type ${_eventDetails.type}'),
                      ),
                      ListTile(
                        onTap: () async {
                          BuildContext bc = Provider.of<TabsScreenContext>(
                                  context,
                                  listen: false)
                              .get();
                          var scf =
                              Provider.of<SCF>(context, listen: false).get();
                          bool registered = _eventDetails.registered
                              ? await scf.unregisterForEvent(
                                  _eventDetails.id, bc)
                              : await scf.registerForEvent(
                                  _eventDetails.id, bc);
                          // if (_eventDetails.registered != registered) {
                          //   //still not being added or removed from schedule
                          //   Provider.of<EventsData>(args.context, listen: false)
                          //       .changeFavoriteStatus(_eventDetails.id);
                          // }
                          if (mounted)
                            setState(() {
                              _eventDetails.registered = registered;
                            });
                        },
                        tileColor: _eventDetails.registered
                            ? Colors.redAccent
                            : Colors.blue,
                        title: Text(
                            'registered ${_eventDetails.registered.toString()}'),
                      ),
                      ListTile(
                        title: Text('count ${_eventDetails.count.toString()}'),
                      )
                    ],
                  )),
      ),
    );
  }
}
