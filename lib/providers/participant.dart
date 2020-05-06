import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/user.dart';

class Participant {
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
  Participant({
    @required this.pseudonym,
    @required this.participating,
    @required this.owner,
  });
}
