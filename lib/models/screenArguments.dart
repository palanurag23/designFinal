import '../providers/server_connection_functions.dart';
import 'package:flutter/material.dart';

class ScreenArguments {
  String username;
  int id;
  Server_Connection_Functions scf;
  BuildContext context;
  ScreenArguments({this.username, this.id, this.scf, this.context});
}
