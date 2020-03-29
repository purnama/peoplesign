import 'package:flutter/material.dart';
import 'package:peoplesign/models/people.dart';


class PeopleTile extends StatelessWidget {

  final People people;

  PeopleTile({this.people});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[people.strength],
            backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(people.name),
          subtitle: Text('Take ${people.sugars} sugar(s).'),
        ),
      ),
    );
  }
}
