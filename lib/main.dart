import 'package:flutter/material.dart';
import 'package:peoplesign/models/user.dart';
import 'package:peoplesign/screens/wrapper.dart';
import 'package:peoplesign/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(PeopleSignApp());

class PeopleSignApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
