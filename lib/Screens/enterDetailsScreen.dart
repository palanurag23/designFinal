import 'package:nilay_dtuotg_2/models/screenArguments.dart';
import 'package:nilay_dtuotg_2/providers/info_provider.dart';
import 'package:nilay_dtuotg_2/widgets/rollNumberPicker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../widgets/yearPicker.dart' as yp;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';

class EnterDetailsScreen extends StatefulWidget {
  static const routeName = '/EnterDetailsScreen';
  @override
  _EnterDetailsScreenState createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  //bool initialized = false;
  int rollNum;
  int year;
  String _myBranch;
  String _myBatch;

  @override
  void initState() {
    super.initState();
  }

  final formGlobalKey = GlobalKey<FormState>();
  final name = TextEditingController();
  bool waiting = false;
  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    String username = args.username;
    ///////////////////  Provider.of<EmailAndUsernameData>(context, listen: false).fetchAndSetData();
    rollNum = Provider.of<ProfileData>(context).rollNumber.isEmpty
        ? 0
        : Provider.of<ProfileData>(context).rollNumber[0];
    year = Provider.of<ProfileData>(context).year.isEmpty
        ? DateTime.now().year
        : Provider.of<ProfileData>(context).year[0];
    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
            ////////TOKEN?save, BATCH,RESPONSE CHECK,IF OK THEN SAVE IN DATA BASE
            onPressed: () async {
              if (formGlobalKey.currentState.validate() && waiting == false) {
                Provider.of<ProfileData>(context, listen: false)
                    .setName(name.text);
                var accessToken =
                    Provider.of<AccessTokenData>(context, listen: false)
                        .accessToken;
                var accessTokenValue = accessToken[0];
                //if status is ok  // // // //     Provider.of<ProfileData>(context, listen: false)
                // // // //         .saveSetedChanges();
                setState(() {
                  waiting = true;
                });
                Map<String, String> headersProfile = {
                  "Content-type": "application/json",
                  "accept": "application/json",
                  "Authorization": "Bearer $accessTokenValue"
                };
                var rollNUmString = rollNum.toString();
                var formattedRollNum = rollNUmString.length == 3
                    ? rollNum
                    : rollNUmString.length == 2
                        ? '0' + rollNUmString
                        : '00' + rollNUmString;
                Map mapjsonnprofile = {
                  "name": "${name.text}",
                  "roll_no": "$formattedRollNum",
                  "branch":
                      "${Provider.of<ProfileData>(context, listen: false).getBranch()}",
                  "year": Provider.of<ProfileData>(context, listen: false)
                      .getYear(),
                  "batch":
                      "${Provider.of<ProfileData>(context, listen: false).getBatch()}"
                };
                http.Response response = await http.put(
                    Uri.https(
                        'dtu-otg.herokuapp.com', 'auth/profile/$username'),
                    headers: headersProfile,
                    body: json.encode(mapjsonnprofile));
                int statusCode = response.statusCode;
                var resp = json.decode(response.body);
                print('/////////enter detail screen response $resp');
                setState(() {
                  waiting = false;
                });
                if (resp["status"] != 'FAILED') {
                  //   Provider.of<ProfileData>(context, listen: false)
                  //     .saveSetedChanges();
                  Provider.of<AccessTokenData>(context, listen: false)
                      .addAccessToken(
                          Provider.of<AccessTokenData>(context, listen: false)
                              .getAccessToken(),
                          Provider.of<AccessTokenData>(context, listen: false)
                              .getDateTime());
                  Navigator.of(context).pushNamed('/homeScreen');
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            child: Text(response.body),
                          ),
                        );
                      });
                }
              }
            },
            child:
                waiting ? CircularProgressIndicator() : Text('save and next'))
      ],
      appBar: AppBar(
        title: Text('ENTER DETAILS 1st time'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Padding(
                child: CupertinoTextFormFieldRow(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  controller: name,
                  //   restorationId: 'email',
                  placeholder: 'official name',
                  keyboardType: TextInputType.name,
                  // clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'enter name';
                    }
                  },
                ),
                padding:
                    EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: RollNumberPicker(),
                        );
                      });
                },
                title: Text('rollnumber'),
                trailing: Text(rollNum.toString()),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: yp.YearPicker(),
                        );
                      });
                },
                title: Text('year'),
                trailing: Text(year.toString()),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: DropDownFormField(
                  titleText: 'BRANCH',
                  hintText: 'Please choose one',
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'select  branch';
                  //   }
                  // },
                  value: _myBranch,
                  onSaved: (value) {
                    Provider.of<ProfileData>(context, listen: false)
                        .setBranch(value);
                    setState(() {
                      _myBranch = value;
                    });
                  },
                  onChanged: (value) {
                    Provider.of<ProfileData>(context, listen: false)
                        .setBranch(value);
                    setState(() {
                      _myBranch = value;
                    });
                  },
                  dataSource: [
                    {
                      "display": "ECE",
                      "value": "ec",
                    },
                    {
                      "display": "BT",
                      "value": "bt",
                    },
                    {
                      "display": "CE",
                      "value": "ce",
                    },
                    {
                      "display": "CO",
                      "value": "co",
                    },
                    {
                      "display": "EE",
                      "value": "ee",
                    },
                    {
                      "display": "EN",
                      "value": "en",
                    },
                    {
                      "display": "EP",
                      "value": "ep",
                    },
                    {
                      "display": "it",
                      "value": "it",
                    },
                    {
                      "display": "me",
                      "value": "me",
                    },
                    {
                      "display": "ae",
                      "value": "ae",
                    },
                    {
                      "display": "mc",
                      "value": "mc",
                    },
                    {
                      "display": "pe",
                      "value": "pe",
                    },
                    {
                      "display": "pt",
                      "value": "pt",
                    },
                    {
                      "display": "se",
                      "value": "se",
                    },
                    {
                      "display": "bd",
                      "value": "bd",
                    }
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: DropDownFormField(
                  titleText: 'Batch',
                  hintText: 'Please choose one',
                  // validator: (value) {
                  //   if (value != '') {
                  //     return 'select  batch';
                  //   }
                  // },
                  value: _myBatch,
                  onSaved: (value) {
                    Provider.of<ProfileData>(context, listen: false)
                        .setBatch(value);
                    setState(() {
                      _myBatch = value;
                    });
                  },
                  onChanged: (value) {
                    Provider.of<ProfileData>(context, listen: false)
                        .setBatch(value);
                    setState(() {
                      _myBatch = value;
                    });
                  },
                  dataSource: [
                    {
                      "display": "a1",
                      "value": "a1",
                    },
                    {
                      "display": "B1",
                      "value": "b1",
                    },
                    {
                      "display": "a2",
                      "value": "a2",
                    },
                    {
                      "display": "b2",
                      "value": "b2",
                    },
                    {
                      "display": "a3",
                      "value": "a3",
                    },
                    {
                      "display": "b3",
                      "value": "b3",
                    },
                    {
                      "display": "a4",
                      "value": "a4",
                    },
                    {
                      "display": "b4",
                      "value": "b4",
                    },
                    {
                      "display": "a5",
                      "value": "A5",
                    },
                    {
                      "display": "b5",
                      "value": "b5",
                    },
                    {
                      "display": "a6",
                      "value": "a6",
                    },
                    {
                      "display": "b6",
                      "value": "b6",
                    },
                    {
                      "display": "a7",
                      "value": "a7",
                    },
                    {
                      "display": "b7",
                      "value": "b7",
                    },
                    {
                      "display": "a8",
                      "value": "a8",
                    },
                    {
                      "display": "b8",
                      "value": "b8",
                    },
                    {
                      "display": "a9",
                      "value": "a9",
                    },
                    {
                      "display": "b9",
                      "value": "b9",
                    },
                    {
                      "display": "a10",
                      "value": "a10",
                    },
                    {
                      "display": "b10",
                      "value": "b10",
                    },
                    {
                      "display": "a11",
                      "value": "a11",
                    },
                    {
                      "display": "b11",
                      "value": "b11",
                    },
                    {
                      "display": "a12",
                      "value": "a12",
                    },
                    {
                      "display": "b12",
                      "value": "b12",
                    },
                    {
                      "display": "a13",
                      "value": "a13",
                    },
                    {
                      "display": "b13",
                      "value": "b13",
                    },
                    {
                      "display": "a14",
                      "value": "a14",
                    },
                    {
                      "display": "b14",
                      "value": "b14",
                    },
                    {
                      "display": "a15",
                      "value": "a15",
                    },
                    {
                      "display": "b15",
                      "value": "b15",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
///////dont forget to save access token permenantly
