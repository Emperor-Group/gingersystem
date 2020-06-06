import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/models/http_exception.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:gingersystem/screens/quest_detail_screen.dart';
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

  ///
  String userId;

  ///
  bool isFavourite;

  ///
  ///
  ///
  List<Idea> _displayIdeas;

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
    this.isFavourite = false,
  });

  Future<void> setInitialIdea() async {
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
    bool quantityOdd = (deadline.difference(launchedDate).inDays % 2) == 1;
    if (diff == 0 || deadline.isBefore(DateTime.now())) {
      return Stage.Closed;
    } else if ((diff % 2) == 1 &&
        (!quantityOdd || DateTime.now().difference(launchedDate).inDays >= 2)) {
      return Stage.Exploit;
    }
    return Stage.Explore;
  }

  Future<void> toggleFavouriteStatus() async {
    final url =
        'https://the-rhizome.firebaseio.com/userFavourites/$userId/$id.json?auth=${this._token}';
    try {
      final response = await http.put(
        url,
        body: json.encode(!isFavourite),
      );
      isFavourite = !isFavourite;
      if (response.statusCode >= 400) {
        isFavourite = !isFavourite;
      }
      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }

  Future<void> fetchAndSetIdeasToDisplay(
      {FilteredIdeaOptions option = FilteredIdeaOptions.Favourites}) async {
    final url = option == FilteredIdeaOptions.Favourites
        ? 'https://the-rhizome.firebaseio.com/ideas/$id.json?auth=${this._token}&orderBy="supportVotes"&limitToLast=10'
        : 'https://the-rhizome.firebaseio.com/ideas/$id.json?auth=${this._token}&orderBy="published"&limitToLast=10';

    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedIdeas = json.decode(response.body);
      final List<Idea> toBeSet = [];

      extractedIdeas.forEach((key, value) {
        toBeSet.insert(
          0,
          Idea.createInitialIdea(
            id: key,
            title: value['title'],
            content: value['content'],
            published: DateTime.parse(value['published']),
          ),
        );
      });

      _displayIdeas = toBeSet;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  List<Idea> get ideasToDisplay {
    return [..._displayIdeas];
  }
}
