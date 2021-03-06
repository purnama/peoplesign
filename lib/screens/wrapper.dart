import 'package:flutter/material.dart';
import 'package:peoplesign/models/user.dart';
import 'package:peoplesign/screens/authenticate/phone_auth.dart';
import 'package:peoplesign/screens/home/home.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    //return either Homer or Authenticate widget
    if (user == null) {
      return Authenticate();
    }
    if (user.phoneNumber == null) {
      return PhoneAuth();
    }
    return Home();
  }
}
