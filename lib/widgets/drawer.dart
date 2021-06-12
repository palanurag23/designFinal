import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';

class Drawer extends StatelessWidget {
  final statusBarHeight;
  Drawer({this.statusBarHeight});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.amber,
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                        '${Provider.of<UsernameData>(context, listen: false).username[0]}'),
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed('inviteScreen');
                    },
                    title: Text('invite friend'),
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        var result = await Provider.of<AccessTokenData>(context,
                                listen: false)
                            .deleteAccessToken();
                        print('./////logout result $result');
                        if (result)
                          Navigator.of(context).pushNamed('/AuthScreen');
                      },
                      icon: Icon(Icons.logout),
                      label: Text('logout'))
                ],
              ),
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
