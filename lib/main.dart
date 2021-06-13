import 'package:date_time_picker/date_time_picker.dart';
import './Screens/tabsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Screens/enterDetailsScreen.dart';
import 'package:flutter/rendering.dart';
import './Screens/addEventScreen.dart';
import './Screens/invite_screen.dart';
import 'package:flutter/services.dart';
import './Screens/eventsDetailScreen.dart';
import 'package:nilay_dtuotg_2/Screens/authScreen.dart';
import 'package:nilay_dtuotg_2/Screens/homeTab.dart';
import 'package:nilay_dtuotg_2/Screens/loadingScreen.dart';
import 'package:nilay_dtuotg_2/Screens/scheduleTab.dart';
import 'package:nilay_dtuotg_2/plus_controller.dart';
import 'package:path/path.dart' as path;
import './models/events.dart';
import 'package:provider/provider.dart';
import './providers/info_provider.dart';
import './providers/server_connection_functions.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() => runApp(MyApp());
var event_name;
var event_description;
List<Widget> Events = [];
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
/////////////////////COLORS
Color newcolor = Color(0xfff2efe4);
TextStyle dark_theme_text_style = TextStyle(color: Colors.white);
Color tilecolor = Colors.white;

TextStyle general_text_style = TextStyle(color: Colors.brown);
////////////////////////////PAGESNAVIGATION
bool _events_pressed = false;
bool _adding_to_app_pressed = false;

class MyApp extends StatelessWidget {
  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;

  Artboard _riveArtboard;
  bool _events_pressed = false;
  bool _adding_to_app_pressed = false;

  @override
  Widget build(BuildContext context1) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TimeTableData()),
        Provider.value(value: SCF(Server_Connection_Functions())),
        ChangeNotifierProvider.value(value: TabsScreenContext()),
        ChangeNotifierProvider.value(value: OwnerIdData()),
        ChangeNotifierProvider.value(value: AddEventScreenData()),
        ChangeNotifierProvider.value(value: Event()),
        ChangeNotifierProvider.value(value: EventsData()),
        ChangeNotifierProvider.value(value: UsernameData()),
        ChangeNotifierProvider.value(value: ProfileData()),
        ChangeNotifierProvider.value(value: AccessTokenData()),
        ChangeNotifierProvider.value(value: EmailAndUsernameData())
      ],
      child: MaterialApp(
        routes: {
          'inviteScreen': (context) => InviteScreen(),
          'AddEventScreen': (context) => AddEventScreen(),
          '/EventsDetailScreen': (context) => EventsDetailScreen(
                key: _scaffoldKey,
              ),
          '/AuthScreen': (context) => AuthScreen(),
          '/EnterDetailsScreen': (context) => EnterDetailsScreen(),
          '/TabsScreen': (context) => TabsScreen(),
          '/schedule': (context1) => ScheduleTab(),
          '/homeScreen': (context1) => HomeScreen(),
          '/loading': (context1) => LoadingScreen()
        },
        title: 'Rive Flutter Demo',
        home: LoadingScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> ScatteredListtiles = [
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: newcolor,
      ),
      child: Builder(
        builder: (_) => ListTile(
          onTap: () async {
            var result = await Provider.of<AccessTokenData>(_, listen: false)
                .deleteAccessToken();
            print('./////logout result $result');
            if (result) Navigator.of(_).pushNamed('/AuthScreen');
          },
          leading: CircleAvatar(
            backgroundColor: Colors.brown,
          ),
          title: Text(
            "log out",
            style: general_text_style,
          ),
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: newcolor),
      child: Builder(
        builder: (_) => ListTile(
          onTap: () {
            Navigator.of(_).pushNamed('/schedule');
          },
          leading: Icon(
            Icons.calendar_today,
            color: Colors.brown,
          ),
          title: Text("Schedule", style: general_text_style),
        ),
      ),
    ),
    Builder(
      builder: (_) => ListTile(
        onTap: () {
          Navigator.of(_).pushNamed('inviteScreen');
        },
        leading: Icon(
          Icons.face_retouching_natural,
          color: Colors.brown,
        ),
        title: Text("invite friends", style: general_text_style),
      ),
    ),
    ListTile(
      leading: Icon(
        Icons.motorcycle_rounded,
        color: Colors.brown,
      ),
      title: Text("Catch-A-Ride", style: general_text_style),
    ),
    ListTile(
      tileColor: newcolor,
      leading: Icon(
        Icons.report,
        color: Colors.brown,
      ),
      title: Text("Emergency", style: general_text_style),
    ),
    ListTile(
      tileColor: newcolor,
      leading: Icon(
        Icons.work,
        color: Colors.brown,
      ),
      title: Text("Active Projects", style: general_text_style),
    ),
    Container(
      color: newcolor,
      alignment: Alignment.bottomCenter,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
        ),
        title: Text("I have a B-Plan , for selling DTU",
            style: general_text_style),
        subtitle:
            Text("-Every Entrepreneur at E-cell", style: general_text_style),
      ),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: newcolor),
            child: Center(
              child: ListView(
                children: ScatteredListtiles,
              ),
            ),
          ), // Populate the Drawer in the next step.
        ),
        body: MyRiveAnimation(),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////HOMEPAGE
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool initialized = false;
  List<Event> evesForSchedule = [];
  List<Event> sheduled = [];
  double width = 500;
  double height = 200;
  List<Event> sheduledToday = [];

  @override
  var scf;
  bool eventsInitialized = false;

  void didChangeDependencies() async {
    print('home init');
    if (!eventsInitialized) {
      scf = Provider.of<SCF>(context, listen: false).get();
      await scf.fetchListOfEvents(context);
      sheduledToday =
          Provider.of<EventsData>(context, listen: false).getEvents();
      setState(() {
        eventsInitialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ScatteredListtiles = [
      Column(
        children: [
          Container(
            child: ListTile(
              leading: Text("Events", style: general_text_style),
            ),
          ),
          SingleChildScrollView(
              child: !eventsInitialized
                  ? CircularProgressIndicator()
                  : Container(
                      height: 300,
                      child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: sheduledToday.length,
                          itemBuilder: (context, index) {
                            var events = sheduledToday;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 5),
                              child: ListTile(
                                tileColor: events[index].favorite
                                    ? Colors.orange[50]
                                    : Colors.black12,
                                subtitle: Text(
                                  events[index].eventType,
                                  style: TextStyle(
                                    color: Colors.brown,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.ac_unit,
                                  color: Colors.brown,
                                ),
                                title: Text(
                                  events[index].name,
                                  style: TextStyle(
                                      color: Colors.brown, fontSize: 19),
                                ),
                              ),
                            );
                          }),
                    )),
        ],
      ),
      ListTile(
          leading: Text("PE-204", style: general_text_style),
          title: Text("3-4AM", style: general_text_style),
          subtitle: Text("TG6-TF8", style: general_text_style),
          trailing: Icon(Icons.schedule),
          onTap: () {}),
      Container(
        alignment: Alignment.bottomCenter,
        child: ListTile(
          trailing: Text("Projects", style: general_text_style),
        ),
      ),
      ListTile(
        title: Text("Internship/Job Opportunities", style: general_text_style),
        trailing: Icon(Icons.work_outline),
      ),
    ];

    return Flexible(
      child: StaggeredGridView.countBuilder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        crossAxisCount: 4,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) =>
            AnimationConfiguration.staggeredGrid(
          position: index,
          columnCount: 0,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            horizontalOffset: 100.0,
            child: FlipAnimation(
              flipAxis: FlipAxis.y,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                child: Center(child: ScatteredListtiles[index]),
              ),
            ),
          ),
        ),
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(2, index.isEven ? 4 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////ADDEVENTSPAGE
class AddEventsPage extends StatefulWidget {
  const AddEventsPage({Key key}) : super(key: key);

  @override
  _AddEventsPageState createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  var event_description_channged;
  var event_name_changed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'new Event',
          style: TextStyle(color: Colors.brown, fontSize: 30),
        ),
        backgroundColor: newcolor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: newcolor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: newcolor,
                child: TextField(
                    style: TextStyle(color: Colors.brown, fontSize: 30),
                    cursorColor: Colors.brown,
                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Name of the event",
                        helperText: 'Keep it short, this is just a beta.',
                        hintStyle: TextStyle(color: Colors.black26),
                        labelStyle:
                            TextStyle(color: Colors.brown, fontSize: 30),
                        hoverColor: Colors.brown,
                        fillColor: newcolor,
                        focusColor: Colors.white),
                    onChanged: (NameOfEvent) {
                      print("The value entered is : $NameOfEvent");
                      event_name_changed = "$NameOfEvent";
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: newcolor,
                child: TextField(
                    style: TextStyle(color: Colors.brown, fontSize: 30),
                    cursorColor: Colors.brown,
                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Description",
                        helperText: 'Keep it short, this is just a beta.',
                        hintStyle: TextStyle(color: Colors.black26),
                        labelStyle:
                            TextStyle(color: Colors.brown, fontSize: 30),
                        hoverColor: Colors.brown,
                        fillColor: newcolor,
                        focusColor: Colors.white),
                    onChanged: (DescriptionOfEvent) {
                      print("The value entered is : $DescriptionOfEvent");
                      event_description_channged = "$DescriptionOfEvent";
                    }),
              ),
            ),
            FloatingActionButton(
                backgroundColor: Colors.brown,
                onPressed: () {
                  event_description = event_description_channged;
                  event_name = event_name_changed;

                  Events.add(Card(
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.star,
                        color: Colors.purple,
                      ),
                      title: Text(event_name),
                      subtitle: Text(event_description),
                    ),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}

//////////////////////////ADDTOSCHEDULEPAGE
class AddToSchedulePage extends StatefulWidget {
  const AddToSchedulePage({Key key}) : super(key: key);

  @override
  _AddToSchedulePageState createState() => _AddToSchedulePageState();
}

class _AddToSchedulePageState extends State<AddToSchedulePage> {
  var event_description_channged;
  var event_name_changed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newcolor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: newcolor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: newcolor,
                child: TextField(
                    style: TextStyle(color: Colors.brown, fontSize: 30),
                    cursorColor: Colors.brown,
                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Name of the event",
                        helperText: 'Keep it short, this is just a beta.',
                        hintStyle: TextStyle(color: Colors.black26),
                        labelStyle:
                            TextStyle(color: Colors.brown, fontSize: 30),
                        hoverColor: Colors.brown,
                        fillColor: newcolor,
                        focusColor: Colors.white),
                    onChanged: (NameOfEvent) {
                      print("The value entered is : $NameOfEvent");
                      event_name_changed = "$NameOfEvent";
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: newcolor,
                child: TextField(
                    style: TextStyle(color: Colors.brown, fontSize: 30),
                    cursorColor: Colors.brown,
                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Description",
                        helperText: 'Keep it short, this is just a beta.',
                        hintStyle: TextStyle(color: Colors.black26),
                        labelStyle:
                            TextStyle(color: Colors.brown, fontSize: 30),
                        hoverColor: Colors.brown,
                        fillColor: newcolor,
                        focusColor: Colors.white),
                    onChanged: (DescriptionOfEvent) {
                      print("The value entered is : $DescriptionOfEvent");
                      event_description_channged = "$DescriptionOfEvent";
                    }),
              ),
            ),
            FloatingActionButton(
                backgroundColor: Colors.brown,
                onPressed: () {
                  event_description = event_description_channged;
                  event_name = event_name_changed;

                  Events.add(Card(
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.star,
                        color: Colors.purple,
                      ),
                      title: Text(event_name),
                      subtitle: Text(event_description),
                    ),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////ADDPROJECTPAGE
class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key key}) : super(key: key);

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  var event_description_channged;
  var event_name_changed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newcolor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: newcolor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: newcolor,
                child: TextField(
                    style: TextStyle(color: Colors.brown, fontSize: 30),
                    cursorColor: Colors.brown,
                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Name of the event",
                        helperText: 'Keep it short, this is just a beta.',
                        hintStyle: TextStyle(color: Colors.black26),
                        labelStyle:
                            TextStyle(color: Colors.brown, fontSize: 30),
                        hoverColor: Colors.brown,
                        fillColor: newcolor,
                        focusColor: Colors.white),
                    onChanged: (NameOfEvent) {
                      print("The value entered is : $NameOfEvent");
                      event_name_changed = "$NameOfEvent";
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: newcolor,
                child: TextField(
                    style: TextStyle(color: Colors.brown, fontSize: 30),
                    cursorColor: Colors.brown,
                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Description",
                        helperText: 'Keep it short, this is just a beta.',
                        hintStyle: TextStyle(color: Colors.black26),
                        labelStyle:
                            TextStyle(color: Colors.brown, fontSize: 30),
                        hoverColor: Colors.brown,
                        fillColor: newcolor,
                        focusColor: Colors.white),
                    onChanged: (DescriptionOfEvent) {
                      print("The value entered is : $DescriptionOfEvent");
                      event_description_channged = "$DescriptionOfEvent";
                    }),
              ),
            ),
            FloatingActionButton(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                backgroundColor: Colors.brown,
                onPressed: () {
                  event_description = event_description_channged;
                  event_name = event_name_changed;

                  if (event_description_channged == null ||
                      event_name_changed == null) {
                    Events.add(Card(
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.star,
                          color: Colors.purple,
                        ),
                        title: Text(event_name),
                        subtitle: Text(event_description),
                      ),
                    ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////EVENTSPAGE

class EventsPage extends StatefulWidget {
  const EventsPage({Key key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        color: newcolor,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: Events.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 350),
              child: SlideAnimation(
                verticalOffset: 100.0,
                child: FlipAnimation(child: Events[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

////////////////////CUSTOMPAGE
class CustomPage extends StatefulWidget {
  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  var event_description_channged;
  var event_name_changed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add Event',
          style: TextStyle(color: Colors.brown, fontSize: 30),
        ),
        backgroundColor: newcolor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: newcolor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: newcolor,
                child: TextField(
                    style: TextStyle(color: Colors.brown, fontSize: 30),
                    cursorColor: Colors.brown,
                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Name of the event",
                        helperText: 'Keep it short, this is just a beta.',
                        hintStyle: TextStyle(color: Colors.black26),
                        labelStyle:
                            TextStyle(color: Colors.brown, fontSize: 30),
                        hoverColor: Colors.brown,
                        fillColor: newcolor,
                        focusColor: Colors.white),
                    onChanged: (NameOfEvent) {
                      print("The value entered is : $NameOfEvent");
                      setState(() {
                        event_name_changed = "$NameOfEvent";
                      });
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: newcolor,
                child: TextField(
                    style: TextStyle(color: Colors.brown, fontSize: 30),
                    cursorColor: Colors.brown,
                    cursorHeight: 35,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 4),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: "Description",
                        helperText: 'Keep it short, this is just a beta.',
                        hintStyle: TextStyle(color: Colors.black26),
                        labelStyle:
                            TextStyle(color: Colors.brown, fontSize: 30),
                        hoverColor: Colors.brown,
                        fillColor: newcolor,
                        focusColor: Colors.white),
                    onChanged: (DescriptionOfEvent) {
                      print("The value entered is : $DescriptionOfEvent");
                      setState(() {
                        event_description_channged = "$DescriptionOfEvent";
                      });
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: FloatingActionButton.extended(
                  label: Text(
                    'save',
                    style: TextStyle(
                        color: (event_name_changed == null ||
                                event_description_channged == null)
                            ? Colors.brown[200]
                            : Colors.white,
                        fontSize: 20),
                  ),
                  icon: Icon(
                    Icons.check,
                    color: (event_name_changed == null ||
                            event_description_channged == null)
                        ? Colors.brown[200]
                        : Colors.white,
                  ),
                  backgroundColor: Colors.brown,
                  onPressed: () {
                    event_description = event_description_channged;
                    event_name = event_name_changed;
                    if (event_name_changed != null &&
                        event_description_channged != null) {
                      Events.add(Card(
                        child: ListTile(
                          leading: Icon(
                            FontAwesomeIcons.star,
                            color: Colors.purple,
                          ),
                          title: Text(event_name),
                          subtitle: Text(event_description),
                        ),
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('event saved'),
                        backgroundColor: Colors.brown,
                      ));
                    }

                    if (event_name_changed != null &&
                        event_description_channged != null)
                      Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////ADDINGPAGE
class AddingPage extends StatefulWidget {
  @override
  _AddingPageState createState() => _AddingPageState();
}

class _AddingPageState extends State<AddingPage> {
  PlusAnimation _plusAnimation;
  double width = 500;
  double height = 200;
  Color newcolor = Color(0xfff2efe4);

  Artboard _riveArtboard;
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('Assets/appbar.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;

        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.

        setState(() => _riveArtboard = artboard);
        _riveArtboard.addController(_plusAnimation = PlusAnimation('Idle'));
      },
    );
  }

  void _events_page_function(bool _eventspressed) {
    if (_adding_to_app_pressed == false) {
      if (_events_pressed == true) {
        newcolor = Color(0xfff2efe4);

        setState(() {
          _events_pressed = _eventspressed;
        });
      } else
        newcolor = Color(0xfff2efe4);
    }
  }

  void _adding_page_open_function(bool _adding_page_active) {
    if (_plusAnimation == null) {
      _riveArtboard.addController(
        _plusAnimation = PlusAnimation('Plus'),
      );
    }

    if (_adding_page_active == true) {
      _plusAnimation.start();
    } else {
      _plusAnimation.reverse();
    }

    setState(() {
      if (_adding_page_active == true) {
        _plusAnimation.isActive = false;
        _riveArtboard.addController(_plusAnimation = PlusAnimation('Plus'));

        print("_adding_page_active");
      }
      _adding_to_app_pressed = _adding_page_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Icon> myicons = [
      Icon(
        FontAwesomeIcons.star,
        color: Colors.purple,
      ),
      Icon(
        Icons.schedule_outlined,
        color: Colors.black,
      ),
      Icon(
        FontAwesomeIcons.tasks,
        color: Colors.greenAccent,
      ),
    ];
    List<Text> titlelist = [
      Text("Add to Events", style: general_text_style),
      Text("Add to Schedule", style: general_text_style),
      Text("Share details about Projects", style: general_text_style),
    ];
    List<Text> subtitlelist = [
      Text(
          "Update via this feature to let people know the details of any event"),
      Text(
          "Update your personal schedule with new tasks assigned like self study,sports.etc"),
      Text(
          "Update via this feature to let people know the details of any projects in DTU, looking for Volunteers"),
    ];
    List<Card> AddingButtons = [
      Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              //  Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CustomPage()));
              Navigator.of(context).pushNamed('AddEventScreen');
            },
            leading: Icon(
              FontAwesomeIcons.star,
              color: Colors.purple,
            ),
            title: Text("Add to Events", style: general_text_style),
            subtitle: Text(
                "Update via this feature to let people know the details of any event"),
          ),
        ),
      ),
      Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddToSchedulePage()));
            },
            leading: Icon(
              Icons.schedule_outlined,
              color: Colors.black,
            ),
            title: Text("Add to Schedule", style: general_text_style),
            subtitle: Text(
                "Update your personal schedule with new tasks assigned like self study,sports.etc"),
          ),
        ),
      ),
      Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProjectPage()));
            },
            leading: Icon(
              FontAwesomeIcons.tasks,
              color: Colors.greenAccent,
            ),
            title:
                Text("Share details about Projects", style: general_text_style),
            subtitle: Text(
                "Update via this feature to let people know the details of any projects in DTU, looking for Volunteers"),
          ),
        ),
      ),
    ];

    return Expanded(
      child: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 350),
              child: SlideAnimation(
                verticalOffset: 100.0,
                child: FlipAnimation(child: AddingButtons[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////RIVEANIMATION

class MyRiveAnimation extends StatefulWidget {
  @override
  _MyRiveAnimationState createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  PlusAnimation _plusAnimation;
  static const double width = 500;
  static const double height = 200;
  Color newcolor = Color(0xfff2efe4);

  Artboard _riveArtboard;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('Assets/appbar.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;

        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.

        setState(() => _riveArtboard = artboard);
        _riveArtboard.addController(_plusAnimation = PlusAnimation('Idle'));
      },
    );
  }

  void _events_page_function(bool _eventspressed) {
    if (_adding_to_app_pressed == false) {
      if (_events_pressed == true) {
        newcolor = Color(0xfff2efe4);

        setState(() {
          _events_pressed = _eventspressed;
        });
      } else
        newcolor = Color(0xfff2efe4);
    }
  }

  void _adding_page_open_function(bool _adding_page_active) {
    if (_plusAnimation == null) {
      _riveArtboard.addController(
        _plusAnimation = PlusAnimation('Plus'),
      );
    }

    if (_adding_page_active == true) {
      _plusAnimation.start();
      newcolor = Color(0xfff2efe4);
    } else {
      _plusAnimation.reverse();
      if (_events_pressed == true) {
        newcolor = Color(0xfff2efe4);
      } else if (_events_pressed == false) {
        newcolor = Color(0xfff2efe4);
      }
    }

    setState(() {
      if (_adding_page_active == true) {
        _plusAnimation.isActive = false;
        _riveArtboard.addController(_plusAnimation = PlusAnimation('Plus'));

        print("_adding_page_active");
      }
      _adding_to_app_pressed = _adding_page_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: newcolor,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_adding_to_app_pressed == false && _events_pressed == false)
            Container(
              height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                    CircleAvatar(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEventsPage()));
                        },
                      ),
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: newcolor,
                      radius: 5,
                    ),
                  ],
                ),
              ),
              color: newcolor,
            )
          else
            Container(
              height: 200,
              color: newcolor,
            ),

          //NAVIGATION OF PAGES
          if (_adding_to_app_pressed == true)
            AddingPage()
          else if (_events_pressed == true)
            EventsPage()
          else
            HomePage(),

          Container(
            padding: EdgeInsets.all(0),
            width: width,
            color: Colors.transparent,
            child: _riveArtboard == null
                ? const SizedBox()
                : GestureDetector(
                    onTapUp: (tapinfo) {
                      var localtouchposition =
                          (context.findRenderObject() as RenderBox)
                              .globalToLocal(tapinfo.globalPosition);

                      var tophalftouched = localtouchposition.dy < height / 2;
                      var hometouched = localtouchposition.dx < width / 6;
                      var internshiptouched =
                          localtouchposition.dx < 2 * (width / 6);
                      var profiletouched = localtouchposition.dx < width;
                      var lowerblanktouched =
                          localtouchposition.dx < 3 * (width / 6);
                      var eventstouched =
                          localtouchposition.dx < 5 * (width / 8);

                      if (!tophalftouched) {
                        if (hometouched) {
                          if (!_adding_to_app_pressed) {
                            setState(() {
                              if (_events_pressed == true) {
                                _events_pressed = !_events_pressed;

                                _plusAnimation.isActive = false;
                                _riveArtboard.addController(
                                    _plusAnimation = PlusAnimation('home'));
                              }
                            });
                          }
                        } else if (internshiptouched) {
                          if (!_adding_to_app_pressed) {
                            setState(() {
                              _plusAnimation.isActive = false;
                              _riveArtboard.addController(
                                  _plusAnimation = PlusAnimation('internship'));
                            });
                          }
                        } else if (lowerblanktouched) {
                          setState(() {
                            _adding_to_app_pressed = !_adding_to_app_pressed;
                            _adding_page_open_function(_adding_to_app_pressed);
                          });
                        } else if (eventstouched) {
                          if (!_adding_to_app_pressed) {
                            setState(() {
                              _events_pressed = !_events_pressed;
                              _events_page_function(_events_pressed);
                              _plusAnimation.isActive = false;
                              _riveArtboard.addController(
                                  _plusAnimation = PlusAnimation('events'));
                            });
                          }
                        } else if (profiletouched) {
                          if (!_adding_to_app_pressed) {
                            setState(() {
                              _plusAnimation.isActive = false;
                              _riveArtboard.addController(
                                  _plusAnimation = PlusAnimation('profile'));
                              print("Profile Touched");
                            });
                          }
                        }
                      } else {
                        setState(() {
                          _adding_to_app_pressed = !_adding_to_app_pressed;
                          _adding_page_open_function(_adding_to_app_pressed);
                        });
                      }
                    },
                    child: Container(
                      color: newcolor,
                      child: Rive(
                        artboard: _riveArtboard,
                        alignment: Alignment.bottomCenter,
                        useArtboardSize: true,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
