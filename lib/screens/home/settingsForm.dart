import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:peoplesign/models/user.dart';
import 'package:peoplesign/services/database.dart';
import 'package:peoplesign/shared/loading.dart';
import 'package:peoplesign/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currentName;
  Position _currentPosition;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: this._formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your people setting',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (value) =>
                    value.isEmpty ? 'Please enter a name' : null,
                    onChanged: (value) => setState(() => _currentName = value),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData.sugars,
                    items: this.sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text(
                          "$sugar sugars",
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _currentSugars = value),
                  ),
                  Slider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    activeColor:
                    Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor:
                    Colors.brown[_currentStrength ?? userData.strength],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (value) =>
                        setState(() => _currentStrength = value.round()),
                  ),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentName ?? userData.name, null, null, null,
                            _currentSugars ?? userData.sugars,
                            _currentStrength ?? userData.strength
                        );
                        Navigator.pop(context);
                      }

                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
