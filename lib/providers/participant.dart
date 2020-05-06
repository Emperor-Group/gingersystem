import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/user.dart';

class Participant with ChangeNotifier {
  ///participant.dart
  ///
  ///
  String pseudonym;

  ///participant.dart
  ///
  ///
  Quest participating;

  ///participant.dart
  ///
  ///
  User owner;

  ///participant.dart
  ///
  ///
  Participant(this.pseudonym, this.participating);
}
