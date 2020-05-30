import 'package:flutter/material.dart';
import 'package:gingersystem/providers/participant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  String authToken;
  String userId;

  List<Comment> _comments = [];

  Comment(this.authToken, this.userId);

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

  Comment.createObject(
    this.id,
    this.title,
    this.content,
    this.published,
    this.votes,
  );

  ///comment.dart
  ///
  ///
  void switchVote(bool isToAdd) {
    int value = isToAdd ? 1 : -1;
    this.votes += value;
    notifyListeners();
  }

  List<Comment> get comments {
    return [..._comments];
  }

  Future<void> fetchAndSetCommentsByQuestAndIdea(idQuest, idIdea) async {
    final url =
        'https://the-rhizome.firebaseio.com/comments/$idQuest/$idIdea.json?auth=${this.authToken}';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedComments = json.decode(response.body);
      final List<Comment> loadedComments = [];
      print(extractedComments);
      if (extractedComments == null) {
        _comments = [];
        notifyListeners();
        return;
      }

      extractedComments.forEach(
        (key2, value2) {
          loadedComments.add(Comment.createObject(
            key2,
            value2['title'],
            value2['description'],
            DateTime.parse(value2['published']),
            value2['votes'],
          ));
        },
      );
      _comments = loadedComments;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addComment(idQuest, idIdea, title, description) async {
    final url =
        'https://the-rhizome.firebaseio.com/comments/$idQuest/$idIdea.json?auth=$authToken';
    try {
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'title': title,
            'description': description,
            'published': DateTime.now().toIso8601String(),
            'votes': 0,
            'publisher': userId,
          },
        ),
      );

      final commentID = json.decode(response.body)['name'];
      print(commentID);
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
