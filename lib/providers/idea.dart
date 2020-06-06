import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/comment.dart';
import 'package:gingersystem/providers/participant.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class Idea with ChangeNotifier {
  ///idea.dart
  /// Unique identifier given by firebase
  ///
  final String id;

  ///idea.dart
  /// The title of the idea
  ///
  final String title;

  ///idea.dart
  /// The description of the idea
  ///
  final String content;

  ///TODO: Define data. Class? Links?
  /// The data uploaded to support an idea
  ///
  List<File> supportData = [];

  ///idea.dart
  /// Who published the idea
  ///
  String owner;

  ///idea.dart
  /// The number of support votes the idea has
  ///
  int supportVotes = 0;

  ///idea.dart
  /// The number of discard votes the idea has
  ///
  int discardVotes = 0;

  ///idea.dart
  /// Comments made for the given idea
  ///
  //List<Comment> _commentsMade = [];

  List<String> hijas = [];

  List<String> padres = [];

  ///idea.dart
  /// Date it was published
  ///
  final DateTime published;

  ///idea.dart
  /// Class constructor for the idea that begins with a quest
  ///
  Idea.createInitialIdea({
    @required this.id,
    @required this.title,
    @required this.content,
    @required this.published,
    this.supportVotes=0,
    this.discardVotes=0
  });

  ///idea.dart
  /// Class constructor for an idea
  ///
  Idea.addIdea({
    @required this.id,
    @required this.title,
    @required this.content,
    @required this.owner,
    @required this.supportData,
    @required this.published,
    this.supportVotes=0,
    this.discardVotes=0
  });

  ///idea.dart
  /// Returns the list of comments sorted by the number of votes
  ///
//  List<Comment> get commentsSortedByVotes {
//    this._commentsMade.sort((a, b) => b.votes.compareTo(a.votes));
//    return [...this._commentsMade];
//  }

  ///idea.dart
  ///
//  ///
//  void addComment(Comment comment) {
//    this._commentsMade.add(comment);
//    notifyListeners();
//  }

  ///idea.dart
  ///
  ///
  void toggleSupportVote(bool isToAdd) {
    int value = isToAdd ? 1 : -1;
    this.supportVotes += value;
    notifyListeners();
  }

  ///idea.dart
  ///
  ///
  void toggleDiscardVote(bool isToAdd) {
    int value = isToAdd ? 1 : -1;
    this.discardVotes += value;
    notifyListeners();
  }
}
