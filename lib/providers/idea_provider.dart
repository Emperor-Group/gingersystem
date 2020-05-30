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

  Future<void> addIdea(String title, String content, List<String> supportData, String idQuest) async {
    final url =
        'https://the-rhizome.firebaseio.com/ideas/$idQuest.json?auth=$authToken';
    try {
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'title': title,
            'content': content,
            'supportData': supportData,
            'owner': userID,
            'published':DateTime.now().toIso8601String(),
            'supportVotes':0,
            'discardVotes':0,
          },
        ),
      );


      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchAndSetOneIdeaByQuest(String ideaId, String idQuest) async {
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
        //print('extractedIdeas: '+extractedIdeas.toString());
      }
      var value2=extractedIdeas;
              loadedIdeas.add(Idea.addIdea(
                  id: ideaId,
                  title: value2['title'],
                  content: value2['content'],
                  //supportData: value2['supportData'],
                  //owner:value2['owner'],
                  published: DateTime.parse (value2['published'])));
      _launchedIdeas = loadedIdeas;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

}