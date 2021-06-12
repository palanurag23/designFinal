import 'package:nilay_dtuotg_2/Screens/homeTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
import 'dart:convert';
import '../widgets/drawer.dart' as drawer;
import 'package:http/http.dart' as http;

class TabsScreen extends StatefulWidget {
  static const routeName = '/TabsScreen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  ////////////
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  ///////////
  bool initialized = false;
  // String respString = '';
  // @override
  // void didChangeDependencies() async {
  //   if (!initialized) {
  //     await Provider.of<AccessTokenData>(context, listen: false)
  //         .fetchAndSetData();
  //     var accessToken =
  //         Provider.of<AccessTokenData>(context, listen: false).accessToken;
  //     var accessTokenValue = accessToken[0];

  //     Map<String, String> headersAccessToken = {
  //       "Content-type": "application/json",
  //       "accept": "application/json",
  //       "Authorization": "Bearer $accessTokenValue"
  //     };

  //     http.Response response = await http.get(
  //       Uri.https('dtu-otg.herokuapp.com', 'auth/profile'),
  //       headers: headersAccessToken,
  //     );
  //     int statusCode = response.statusCode;
  //     var resp = json.decode(response.body);
  //     respString = resp.toString();
  //     setState(() {
  //       initialized = true;
  //     });
  //   }
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }
  int _selectedPageIndex = 2;
  List<Map<String, Widget>> _pages;
  @override
  void didChangeDependencies() async {
    Provider.of<UsernameData>(context, listen: false)
        .fetchAndSetData(); //can't use await here...if necessary use future builder in your widget
    var ht;
    //
    if (!initialized) {
      var mediaQueryData = MediaQuery.of(context);
      var totalHeight = mediaQueryData.size.height;
      var bottomNavigationBarHeight = mediaQueryData.padding.bottom;
      var statusBarHeight = mediaQueryData.padding.top;
      ht = HomeTab(
        statusBarHeight: statusBarHeight,
        height: totalHeight - bottomNavigationBarHeight,
      );
      _pages = [
        {
          'page': ht,
        },
        {
          'page': HomeTab(
            statusBarHeight: statusBarHeight,
            height: totalHeight - bottomNavigationBarHeight,
          ),
        },
        {
          'page': ht,
        },
        {
          'page': ht,
        },
        {
          'page': ht,
        }
      ];
      initialized = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    // _pages = [
    //   {
    //     'page': HomeTab(),
    //   },
    //   {
    //     'page': HomeTab(),
    //   },
    //   {
    //     'page': HomeTab(),
    //   },
    //   {
    //     'page': HomeTab(),
    //   },
    //   {
    //     'page': HomeTab(),
    //   }
    // ]; //you can use 'widget.' in build method but not outside..
    //and you cant create variables in initState..
    //you can only assign values to the non final variables here..like _pages
    // TODO: implement initState

    super.initState();
  }

  void _selectPage(int index) {
    //INDEX IS AUTOMATICALLY PROVIDED BY FLUTTER
    //FUNCTION TO SELECT PAGE FROM BOTTOM-NAVIGATION-BAR
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var totalHeight = mediaQueryData.size.height;
    var bottomNavigationBarHeight = mediaQueryData.padding.bottom;
    var statusBarHeight = mediaQueryData.padding.top;
    Provider.of<TabsScreenContext>(context, listen: false).set(context);
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: drawer.Drawer(
          statusBarHeight: statusBarHeight,
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(children: [
        _pages[_selectedPageIndex]['page'],
        Positioned(
          left: 20,
          top: 40,
          child: IconButton(
              icon: Icon(Icons.line_weight_rounded),
              onPressed: () => _drawerKey.currentState.openDrawer()),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        // type: BottomNavigationBarType.shifting,//with shifting..style items separatly
        selectedFontSize: 15, unselectedFontSize: 10,
        currentIndex: _selectedPageIndex, //WHICH TAB IS SELECTED/HIGHLIGHTED
        unselectedItemColor:
            Colors.white, //grey[300], //Theme.of(context).canvasColor,
        selectedItemColor: Colors.amber,
        onTap: _selectPage, //flutter will automaticlly give 'index' of the tab
        backgroundColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home_repair_service_sharp),
            backgroundColor: Colors.black,
            icon: Icon(Icons.home_repair_service_sharp),
            label: '0',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.calendar_today_sharp),
            backgroundColor: Colors.black,
            icon: Icon(Icons.calendar_today_sharp),
            label: '1',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home_rounded),
            backgroundColor: Colors.blueGrey[900],
            icon: Icon(Icons.home_rounded),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.people_outline),
            backgroundColor: Colors.black,
            icon: Icon(Icons.people_outline),
            label: '3',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.location_on_rounded),
            backgroundColor: Colors.black,
            //  backgroundColor: Theme.of(context).primaryColor,//with shifting
            icon: Icon(Icons.location_on_rounded),
            label: '4',
          ),
        ],
      ),
    );
  }
}
