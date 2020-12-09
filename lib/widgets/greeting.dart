import 'package:flutter/material.dart';

class Greeting extends StatelessWidget {
  final int _hourOfDay = DateTime.now().hour;
  String _timeOfDay;

  @override
  Widget build(BuildContext context) {
    if (_hourOfDay > 4 && _hourOfDay < 12) {
      _timeOfDay = "morning";
    } else if (_hourOfDay > 11 && _hourOfDay < 18) {
      _timeOfDay = "afternoon";
    } else if (_hourOfDay > 17 && _hourOfDay < 20) {
      _timeOfDay = "evening";
    } else {
      _timeOfDay = "night";
    }

    return Text(
      'Good $_timeOfDay,',
      style: Theme.of(context)
          .textTheme
          .subtitle1
          .copyWith(color: Colors.grey, fontSize: 18),
    );
  }
}
