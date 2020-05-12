import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:http/http.dart' as http;

class Quest with ChangeNotifier {
  ///quest.dart
  ///
  ///
  final String id;

  ///quest.dart
  ///
  ///
  final String title;

  ///quest.dart
  ///
  ///
  final DateTime launchedDate;

  ///quest.dart
  ///
  ///
  final DateTime deadline;

  ///quest.dart
  ///
  ///
  String publisherID;

  ///quest.dart
  /// Parent of all ideas for this quest
  ///
  Idea initialIdea;

  ///
  ///
  ///
  final String initIdeaID;

  ///
  ///
  ///
  Stage currentStage;

  ///
  String _token;

  String userId;

  ///quest.dart
  ///
  ///
  Quest.initializeQuest(
    this._token,
    this.userId, {
    @required this.id,
    @required this.title,
    @required this.launchedDate,
    @required this.deadline,
    @required this.initIdeaID,
  });

  void setInitialIdea() async {
    final url =
        'https://the-rhizome.firebaseio.com/ideas/$id/$initIdeaID.json?auth=${this._token}';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedIdea = json.decode(response.body);
      if (extractedIdea == null) {
        return;
      }
      initialIdea = Idea.createInitialIdea(
        id: initIdeaID,
        title: extractedIdea['title'],
        content: extractedIdea['content'],
        published: DateTime.parse(extractedIdea['published']),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Stage get stage {
    int diff = deadline.difference(DateTime.now()).inDays;
    if (diff == 0 || deadline.isBefore(DateTime.now())) {
      return Stage.Closed;
    } else if ((diff % 2) == 1) {
      return Stage.Exploit;
    }
    return Stage.Explore;
  }
}
