import 'package:flutter/material.dart';
import 'package:peoplesign/models/user.dart';
import 'package:peoplesign/screens/authenticate/authenticate.dart';
import 'package:peoplesign/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //return either Homer or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
