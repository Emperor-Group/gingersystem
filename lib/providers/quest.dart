import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/connector.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/participant.dart';
import 'package:gingersystem/providers/user.dart';
import 'package:http/http.dart' as http;
import 'package:graph_collection/graph.dart';

class Quest with ChangeNotifier {
  ///quest.dart
  ///
  ///
  DirectedValueGraph _dynamicIdeasForum;

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
  User publisher;

  ///quest.dart
  /// TODO: Participants? How?
  ///
  List<Participant> _participants;

  ///quest.dart
  /// Parent of all ideas for this quest
  ///
  Idea initialIdea;

  ///
  ///
  ///
  final String initIdeaID;

  ///quest.dart
  ///
  ///
  Quest.initializeQuest({
    @required this.id,
    @required this.title,
    @required this.launchedDate,
    @required this.deadline,
    @required this.initIdeaID,
  });

  void setInitialIdea() async {
    final url = 'https://the-rhizome.firebaseio.com/ideas/$id/$initIdeaID.json';
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
      print('Oh we got it: ${initialIdea.title}');
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
