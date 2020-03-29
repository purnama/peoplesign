import 'package:flutter/material.dart';
import 'package:peoplesign/models/people.dart';
import 'package:peoplesign/screens/home/peopleTile.dart';
import 'package:provider/provider.dart';

class PeopleList extends StatefulWidget {
  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  @override
  Widget build(BuildContext context) {
    final peoples = Provider.of<List<People>>(context) ?? [];
    if (peoples != null) {
      return ListView.builder(
        itemCount: peoples.length,
        itemBuilder: (context, index) {
          return PeopleTile(
            people: peoples[index],
          );
        },
      );
    } else {
      return Container();
    }
  }
}
