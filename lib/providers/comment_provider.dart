import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/comment.dart';

class CommentProvider with ChangeNotifier {
  String authToken;
  String userId;

  List<Comment> _comments = [];

  CommentProvider(this.authToken, this.userId);

  List<Comment> get comments {
    return [..._comments];
  }

  String getUserId() {
    return this.userId;
  }

  Comment createComment(
      id, title, content, published, votes, vote, isChallenge, pUserId) {
    return Comment(
        id, title, content, published, votes, vote, isChallenge, pUserId);
  }

  Future<void> fetchAndSetCommentsByQuestAndIdea(idQuest, idIdea) async {
    final url =
        'https://the-rhizome.firebaseio.com/comments/$idQuest/$idIdea.json?auth=${this.authToken}';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedComments = json.decode(response.body);
      final List<Comment> loadedComments = [];
      if (extractedComments == null) {
        _comments = [];
        notifyListeners();
        return;
      }
      var urlAux =
          'https://the-rhizome.firebaseio.com/commentVotes/$idQuest/$idIdea/$userId.json?auth=${this.authToken}';
      final response2 = await http.get(urlAux);
      final userComments = json.decode(response2.body);

      if (userComments != null) {
        extractedComments.forEach(
          (key2, value2) {
            var exist = false;
            var valueExist = false;
            userComments.forEach((commentKey, voteValue) {
              if (key2 == commentKey) {
                exist = true;
                valueExist = voteValue;
              }
            });
            loadedComments.add(createComment(
                key2,
                value2['title'],
                value2['description'],
                DateTime.parse(value2['published']),
                value2['votes'],
                exist ? valueExist : false,
                value2['isChallenge'],
                value2['publisher']));
          },
        );
      } else {
        extractedComments.forEach(
          (key2, value2) {
            loadedComments.add(createComment(
                key2,
                value2['title'],
                value2['description'],
                DateTime.parse(value2['published']),
                value2['votes'],
                false,
                value2['isChallenge'],
                value2['publisher']));
          },
        );
      }
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
            'isChallenge': false
          },
        ),
      );
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> switchVote(idQuest, idIdea, idComment, vote, votes) async {
    final url =
        'https://the-rhizome.firebaseio.com/commentVotes/$idQuest/$idIdea/$userId/$idComment.json?auth=$authToken';
    final url2 =
        'https://the-rhizome.firebaseio.com/comments/$idQuest/$idIdea/$idComment/votes.json?auth=$authToken';
    try {
      await http.put(
        url,
        body: json.encode(vote),
      );
      await http.put(
        url2,
        body: json.encode(votes),
      );

      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }

  Future<void> switchIsChallenge(
      idQuest, idIdea, idComment, isChallenge) async {
    final url =
        'https://the-rhizome.firebaseio.com/comments/$idQuest/$idIdea/$idComment/isChallenge.json?auth=$authToken';
    try {
      await http.put(
        url,
        body: json.encode(isChallenge),
      );
      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }
}
