import 'package:flutter/material.dart';
import 'package:gingersystem/providers/participant.dart';

class Comment with ChangeNotifier {
  ///comment.dart
  /// Models the unique identifier, given by Firebase
  ///
  String id;

  ///comment.dart
  /// Models the title for the comment
  ///
  String title;

  ///comment.dart
  /// Models the content of the comment
  ///
  String content;

  ///comment.dart
  /// Models the number of votes for this comment
  ///
  int votes = 0;

  ///comment.dart
  /// Models if the comment is a challenge for the idea
  ///
  bool isChallenge;

  ///comment.dart
  /// Models the date it was published
  ///
  DateTime published;

  ///comment.dart
  /// Who published the comment
  ///
  Participant publisher;

  ///comment.dart
  /// Class constructor for creating a comment
  ///
  Comment.create({
    @required this.id,
    @required this.title,
    @required this.content,
    this.publisher,
    @required this.isChallenge,
  }) {
    this.published = DateTime.now();
  }

  ///comment.dart
  ///
  ///
  void switchVote(bool isToAdd) {
    int value = isToAdd ? 1 : -1;
    this.votes += value;
    notifyListeners();
  }
}
