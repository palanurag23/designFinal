import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:nilay_dtuotg_2/providers/server_connection_functions.dart';
import 'package:nilay_dtuotg_2/widgets/eventDurationPicker.dart';
import 'package:nilay_dtuotg_2/widgets/eventOwnerPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = 'AddEventScreen';
  AddEventScreen({Key key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final name = TextEditingController();
  final description = TextEditingController();
  @override
  void initState() {
    name.text = 'name';
    description.text = 'description';
    // TODO: implement initState
    super.initState();
  }

  DateTime dateTime;
  TimeOfDay timeOfDay;

  final formGlobalKey = GlobalKey<FormState>();
  bool waiting = false;
  var resp;
  int type;
  DateTime now = DateTime.now();
  Duration _duration = Duration(hours: 0, minutes: 0);
  @override
  Widget build(BuildContext context) {
    BuildContext bc =
        Provider.of<TabsScreenContext>(context, listen: false).get();
    var data = Provider.of<AddEventScreenData>(context, listen: true);
    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton.icon(
            onPressed: () async {
              setState(() {
                waiting = true;
              });
              if (dateTime != null &&
                  timeOfDay != null &&
                  name != null &&
                  description != null &&
                  type != null) {
                var scf = Provider.of<SCF>(context, listen: false).get();
                Map<String, dynamic> resp = await scf.createEvent(
                    bc, name.text, description.text, type, dateTime, timeOfDay);
                scf.fetchListOfEvents(bc);
                // if (resp["status"] == "OK") {
                //   Navigator.of(context).pop();
                // }
                showDialog(
                    context: bc,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: Text(resp.toString()),
                        ),
                      );
                    });
              }
              setState(() {
                waiting = false;
              });
            },
            icon: Icon(Icons.save),
            label: waiting ? CircularProgressIndicator() : Text('save'))
      ],
      appBar: AppBar(
        title: Text('add event'),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('date picker'),
                autofocus: true,
                clipBehavior: Clip.hardEdge,
                onPressed: () async {
                  dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2021),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2022));
                  print('$dateTime');
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 1, minute: 0),
                  );
                  print('$timeOfDay');
                },
                child: Text("startingTimes"),
              ),
              ListTile(
                leading: Icon(Icons.timelapse),
                tileColor: Colors.blue[200],
                title: Text('duration'),
                trailing: Text('${data.getHours()}h ${data.getMinutes()}min'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(child: DurationPicker());
                      });
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.people),
              //   tileColor: Colors.blue[200],
              //   title: Text('owners'),
              //   trailing: Text('${data.getOwners()}'),
              //   onTap: () {
              //     showDialog(
              //         context: context,
              //         builder: (context) {
              //           return Dialog(child: OwnerPicker());
              //         });
              //   },
              // ),
              Padding(
                child: CupertinoTextFormFieldRow(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  maxLength: 20,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  controller: name,
                  //  restorationId: 'username',
                  placeholder: 'name',
                  keyboardType: TextInputType.emailAddress,
                  //   clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value.length > 20) {
                      return 'string too long';
                    }
                    if (value.isEmpty) {
                      return 'enter name';
                    }
                  },
                ),
                padding:
                    EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),
              Padding(
                child: CupertinoTextFormFieldRow(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  maxLength: 2000, maxLines: 8, minLines: 1,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  controller: description,
                  //  restorationId: 'username',
                  placeholder: 'description',
                  keyboardType: TextInputType.multiline,
                  //   clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value.length > 2000) {
                      return 'string too long';
                    }
                    if (value.isEmpty) {
                      return 'enter description';
                    }
                  },
                ),
                padding:
                    EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),
              ListTile(
                title: Text('longitude'),
              ),
              ListTile(
                title: Text('latitude'),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: DropDownFormField(
                  textField: 'display',
                  valueField: 'value',
                  dataSource: [
                    {
                      "display": "type1",
                      "value": 1,
                    },
                    {
                      "display": "type2",
                      "value": 2,
                    },
                    {
                      "display": "type3",
                      "value": 3,
                    },
                  ],
                  onSaved: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                  titleText: 'event type',
                  value: type,
                  hintText: 'choose event type',
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
