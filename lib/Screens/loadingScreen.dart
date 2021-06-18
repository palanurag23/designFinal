import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool initialized = false;
  String accessTokenValue;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (!initialized) {
      await Provider.of<UsernameData>(context, listen: false).fetchAndSetData();
      await Provider.of<OwnerIdData>(context, listen: false).fetchAndSetData();
      await Provider.of<AccessTokenData>(context, listen: false)
          .fetchAndSetData();
      var accessToken =
          Provider.of<AccessTokenData>(context, listen: false).accessToken;
      //date time expiry check needs to be added for token
      if (accessToken.isEmpty) {
        print('empty if');
        Navigator.of(context).pushNamed('/AuthScreen');
      } else {
        print('non empty else');
        accessTokenValue = accessToken[0];

        print('accessTokenValue');
        Map<String, String> headersAccessToken = {
          "Content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $accessTokenValue"
        };

        http.Response response = await http.get(
          Uri.https('dtu-otg.herokuapp.com', 'auth/check-auth'),
          headers: headersAccessToken,
        );
        int statusCode = response.statusCode;
        var resp = json.decode(response.body);
        if (resp["status"] == 'OK') {
          Navigator.of(context).pushReplacementNamed('/homeScreen');
        } else {
          Navigator.of(context).pushReplacementNamed('/AuthScreen');
        }
      }
      initialized = true;
      //   print(initialized);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
        children: [
          FadingText('Loading...'),
        ],
      )),
    );
  }
}
