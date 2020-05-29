import 'package:flutter/cupertino.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class IdeasProvider with ChangeNotifier {
  List<Idea> _launchedIdeas = [];
  String authToken;
  String userID;

  IdeasProvider(this.authToken, this.userID);

  List<Idea> get launchedIdeas {
    return [..._launchedIdeas];
  }

  Idea getByID(String idIdea) {
    //print('_launchedIdeas[0].id: '+_launchedIdeas.toString());
    return _launchedIdeas.firstWhere((Idea idea) => idea.id == idIdea);
  }

  Future<void> addIdea(Idea idea) async {
    final url =
        'https://the-rhizome.firebaseio.com/ideas.json?auth=$authToken';
    try {
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'title': idea.title,
            'content': idea.content,
            'supportData':idea.supportData,
            'supportVotes':0,
            'discardVotes':0,
          },
        ),
      );

      final questID = json.decode(response.body)['name'];

      final ideaURL =
          'https://the-rhizome.firebaseio.com/ideas/$questID.json?auth=$authToken';
      http.Response ideaResponse = await http.post(
        ideaURL,
        body: json.encode(
          {
            "title": idea.title,
            "content": idea.content,
            "published": idea.published.toIso8601String(),
          },
        ),
      );

      final questURL =
          'https://the-rhizome.firebaseio.com/quests/$questID.json?auth=$authToken';
      await http.patch(
        questURL,
        body: json.encode(
          {
            'initialIdea': {'${json.decode(ideaResponse.body)['name']}': true},
          },
        ),
      );

//      _launchedIdeas.insert(
//        0,
//        Ideas.initializeIdeas(
//          this.authToken,
//          this.userID,
//          id: questID,
//          title: quest.title,
//          launchedDate: quest.launchedDate,
//          deadline: quest.deadline,
//          initIdeaID: json.decode(ideaResponse.body)['name'],
//        ),
//      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchAndSetCommentsByIdea(String ideaId, String idQuest) async {
    final url =
        'https://the-rhizome.firebaseio.com/ideas/$idQuest/$ideaId.json?auth=${this.authToken}';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedIdeas = json.decode(response.body);

      final List<Idea> loadedIdeas = [];
      if (extractedIdeas == null) {
        print('no hay ideas');
        return ;
      }else{
        print('extractedIdeas: '+extractedIdeas.toString());
      }
      var value2=extractedIdeas;
              loadedIdeas.add(Idea.addIdea(
                  id: ideaId,
                  title: value2['title'],
                  content: value2['content'],
                  //supportData: value2['supportData'],
                  published: DateTime.parse (value2['published'])));
      _launchedIdeas = loadedIdeas;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

}