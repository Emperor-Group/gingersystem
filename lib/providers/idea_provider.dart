import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class IdeasProvider with ChangeNotifier {
  final DBref = FirebaseDatabase.instance.reference();
  Idea _launchedIdea;
  String authToken;
  String userID;
  List<Idea> ideasparentsOchildren;

  IdeasProvider(this.authToken, this.userID);

  Idea get launchedIdea {
    return launchedIdea;
  }

  Idea getByID(String idIdea) {
    //print('_launchedIdeas[0].id: '+_launchedIdeas.toString());
    return _launchedIdea;
  }

  Future<void> addIdea(String title, String content, List<File> supportData,
      String idQuest, String padre) async {
    //  print('launchedIdea.id '+padre.id);

//    List<Uint8List> x=List<Uint8List>();
//    supportData.forEach((e) async {
//      x.add( e.readAsBytesSync());
//    });

    //  List <Idea> Iparents=[];

    DBref.child('ideas/$idQuest/$padre')
        .orderByKey()
        .equalTo('$padre')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values["name"]);
      });
    });
//    final url2 =
//        'https://the-rhizome.firebaseio.com/ideas/$idQuest.json?auth=$authToken&orderBy="children/'+json.encode('\$')+'key"&equalTo="${padre.id}"';
//    print('url2 '+url2);
    try {
//      final response2 = await http.get(url2);
//      final Map<String, dynamic> extractedData = json.decode(response2.body);
//      final List<Idea> loadedparentsDelPapa = [];
//
//      if (extractedData == null) {
//        print('El padre es la idea inicial porque no tiene parents');
//        Iparents=[padre];
//      }else{
//        print('lista is not null');
//        print(extractedData);
//        loadedparentsDelPapa.add(padre);
//        extractedData.forEach(
//              (key, value) {
//                loadedparentsDelPapa.add(
//                Idea.addIdea(
//                    id: key,
//                    title: value.title,
//                    content: value.content,
//                    owner: value.owner,
//                    supportData: [],
//                    published: value.published
//                )
//            );
//          },
//        );
//        Iparents = loadedparentsDelPapa;
//      }
//      print('response2.statusCode: '+response2.statusCode.toString());
//
//      print('Iparents: ');
//      print(Iparents);

      final url =
          'https://the-rhizome.firebaseio.com/ideas/$idQuest.json?auth=$authToken';
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'title': title,
            'content': content,
            'supportData': [],
            'owner': userID,
            'published': DateTime.now().toIso8601String(),
            'supportVotes': 0,
            'discardVotes': 0,
            'parents': [],
          },
        ),
      );
      final ideaID = json.decode(response.body)['name'];
      final StorageReference fsr = FirebaseStorage.instance
          .ref()
          .child('ideas/$idQuest/$ideaID/supportData');
      supportData.forEach((element) {
        // fsr.putFile(element);
      });

      print('response.statusCode: ' + response.statusCode.toString());
      print(title);
      print(content);
      print('idQuest' + idQuest);
      print('userID' + userID);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
//  Future<void> addIdea(String title, String content, List<File> supportData, String idQuest) async {
//    final url =
//        'https://the-rhizome.firebaseio.com/ideas/$idQuest.json?auth=$authToken';
//
//    try {
//      var request = http.MultipartRequest('POST', Uri.parse(url));
//      request.files.add(
//          await http.MultipartFile.fromPath(
//              'supportData',
//              supportData[0].path
//          )
//      );
//      request.fields['title'] = title;
//      request.fields['content'] = content;
//      request.fields['owner'] = userID;
//      request.fields['published'] = DateTime.now().toIso8601String();
//      request.fields['supportVotes'] = 0.toString();
//      request.fields['discardVotes'] = 0.toString();
//      print(title);
//      print(content);
//      print('idQuest'+idQuest);
//      print('userID'+userID);
//      var res = await request.send();
//      notifyListeners();
//    } catch (error) {
//      print(error);
//      throw (error);
//    }
//  }

/*
Solo mete los parametros que se le pasen a la base de datos,
se tiene que enviar la cantidad de votos a poner en la base de datos (actual-1 o actual+1)
 */
  Future<void> switchVotes(
      String idQuest, String idIdea, int PSupportVote, int PDiscardVote) async {
    final url2 =
        'https://the-rhizome.firebaseio.com/ideas/$idQuest/$idIdea.json?auth=$authToken';
    String jsonS =
        '{"supportVotes": $PSupportVote, "discardVotes": $PDiscardVote}';

    try {
      Response response = await http.patch(url2, body: jsonS);
      print(response.statusCode);
      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
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
        return;
      } else {
        //print('extractedIdeas: '+extractedIdeas.toString());
      }
      var value2 = extractedIdeas;
      loadedIdeas.add(Idea.addIdea(
        id: ideaId,
        title: value2['title'],
        content: value2['content'],
        //supportData: value2['supportData'],
        owner: value2['owner'],
        published: DateTime.parse(value2['published']),
        supportVotes: value2['supportVotes'],
        discardVotes: value2['discardVotes'],
      ));
      _launchedIdea = loadedIdeas[0];
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetLaunchedIdeasChildren(
      String pQuestId, String pIdeaId) async {
    final url =
        'https://the-rhizome.firebaseio.com/ideas/$pQuestId/$pIdeaId.json?auth=${this.authToken}';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedIdeas = json.decode(response.body);
      List<String> children = extractedIdeas['children'];
      List<String> parents = extractedIdeas['parents'];

      final List<Idea> loadedIdeas = [];
      if (extractedIdeas == null) {
        print('no hay ideas');
        return;
      } else {
        //print('extractedIdeas: '+extractedIdeas.toString());
      }
      var value2 = extractedIdeas;
      loadedIdeas.add(Idea.addIdea(
          id: pIdeaId,
          title: value2['title'],
          content: value2['content'],
          //supportData: value2['supportData'],
          owner: value2['owner'],
          published: DateTime.parse(value2['published'])));
      _launchedIdea = loadedIdeas[0];
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
