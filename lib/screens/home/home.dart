import 'package:flutter/material.dart';
import 'package:peoplesign/models/people.dart';
import 'package:peoplesign/screens/home/peopleList.dart';
import 'package:peoplesign/screens/home/settingsForm.dart';
import 'package:peoplesign/services/auth.dart';
import 'package:peoplesign/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<People>>.value(
      value: DatabaseService().peoples,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('PeopleSign'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async => await _authService.signOut(),
                icon: Icon(Icons.person),
                label: Text('logout')),
            FlatButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.settings),
                label: Text('settings')),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover,
            )),
            child: PeopleList()),
      ),
    );
  }
}
