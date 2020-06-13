import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';

class IdeasProvider with ChangeNotifier {
  final DBref = FirebaseDatabase.instance.reference();
  Idea _launchedIdea;
  String authToken;
  String userID;
  List<Idea> ideasparentsOchildren;
  List<String> parents = [];
  String link='';

  IdeasProvider(this.authToken, this.userID);

  Idea get launchedIdea {
    return launchedIdea;
  }

  Idea getByID(String idIdea) {
    return _launchedIdea;
  }

  Future<void> addIdea(String title, String content, List<File> supportData,
      String idQuest, String type) async {
    Map<String, dynamic> x = {};
    for (String padre in parents) {
      x['$padre'] = true;
    }

    try {
      //Se sube la idea nueva con papás.
      String url =
          'https://the-rhizome.firebaseio.com/ideas/$idQuest.json?auth=$authToken';
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'title': title,
            'content': content,
            'supportDataLink': supportData.isNotEmpty ? true : false,
            'owner': userID,
            'published': DateTime.now().toIso8601String(),
            'supportVotes': 0,
            'discardVotes': 0,
            'parents': x,
            'type': type
            //no lleva children porque es nueva.
          },
        ),
      );

      final String ideaID = json.decode(response.body)['name'];

      //  Se sube supportData
      if (supportData != null && supportData.isNotEmpty) {
        final StorageReference fsr = FirebaseStorage.instance
            .ref()
            .child('ideas/$idQuest/$ideaID/supportData');
        supportData.forEach((element) {
          fsr.putFile(element);
        });
      }

      //Se mete el hijo nuevo a todos los papás.
      for (String padre in parents) {
        url =
            'https://the-rhizome.firebaseio.com/ideas/$idQuest/$padre/children.json?auth=$authToken';
        response = await http.patch(
          url,
          body: json.encode(
            {'$ideaID': true},
          ),
        );
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

/*
Solo mete los parametros que se le pasen a la base de datos,
se tiene que enviar la cantidad de votos a poner en la base de datos (actual-1 o actual+1)
 */
  Future<void> switchVotes(
      String idQuest, String idIdea, int PSupportVote, int PDiscardVote) async {
    Idea ideaC = await getOneIdeaByQuest(idIdea, idQuest);
    String url2 =
        'https://the-rhizome.firebaseio.com/ideas/$idQuest/$idIdea.json?auth=$authToken';
    String jsonS;

    if (ideaC.discardVotes != PDiscardVote) {
      //se quiere cambiar discard
      if (ideaC.discardVotes > PDiscardVote) {
        //quiere bajar en 1
        int x = await getVotosDeUsuarioEnIdeaSupportOrDiscard(
            idQuest, idIdea, 'discard');
        if (x > 0) {
          //debe tener un voto para poder bajarlo
          jsonS = '{"discardVotes": $PDiscardVote}';
          await setVotosDeUsuarioEnIdeaSupportOrDiscard(
              idQuest, ideaC, 'discard', -1);
        }
      } else {
        //se quiere subir
        int x = await getVotosDeUsuarioEnIdeaSupportOrDiscard(
            idQuest, idIdea, 'discard');
        if (x == 0) {
          jsonS = '{"discardVotes": $PDiscardVote}';
        }
        await setVotosDeUsuarioEnIdeaSupportOrDiscard(
            idQuest, ideaC, 'discard', 1);
      }
    } else if (ideaC.supportVotes != PSupportVote) {
      //se quiere cambiar support
      if (ideaC.supportVotes > PSupportVote) {
        //quiere bajar en 1
        int x = await getVotosDeUsuarioEnIdeaSupportOrDiscard(
            idQuest, idIdea, 'support');
        if (x > 0) {
          //debe tener un voto para poder bajarlo
          jsonS = '{"supportVotes": $PSupportVote}';
          await setVotosDeUsuarioEnIdeaSupportOrDiscard(
              idQuest, ideaC, 'support', -1);
        }
      } else {
        //se quiere subir en 1
        int x = await getVotosDeUsuarioEnIdeaSupportOrDiscard(
            idQuest, idIdea, 'support');
        if (x == 0) {
          //debe 0 votos para poder subirlo
          jsonS = '{"supportVotes": $PSupportVote}';
        }
        await setVotosDeUsuarioEnIdeaSupportOrDiscard(
            idQuest, ideaC, 'support', 1);
      }
    }
    try {
      Response response = await http.patch(url2, body: jsonS);
      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }

  Future<int> getVotosDeUsuarioEnIdeaSupportOrDiscard(
      String idQuest, String ideaId, String supportOrDiscard) async {
    Future<int> respuesta;
    final url3 =
        'https://the-rhizome.firebaseio.com/userVotesIdeas/$userID/$ideaId/$supportOrDiscard.json?auth=$authToken';
    try {
      Response response = await http.get(url3);
      final Map<String, dynamic> extractedMap = json.decode(response.body);

      notifyListeners();

      if (extractedMap == null || extractedMap.length == 0) {
        respuesta = Future.value(0);
      } else if (supportOrDiscard == 'support' ||
          supportOrDiscard == 'discard') {
        respuesta = Future.value(extractedMap['$ideaId']);
      } else {
        print('argumento supportOrDiscard está mal');
      }
      return respuesta;
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }

//el delta solo puede ser 1 o -1
  Future<void> setVotosDeUsuarioEnIdeaSupportOrDiscard(
      String idQuest, Idea pIdea, String supportOrDiscard, int delta) async {
    String jsonS;
    final url3 =
        'https://the-rhizome.firebaseio.com/userVotesIdeas/$userID/${pIdea.id}/$supportOrDiscard.json?auth=$authToken';
    try {
      if (delta > 0) {
        jsonS = '{"${pIdea.id}": $delta}';
      } else {
        jsonS = '{"${pIdea.id}": ${1 + delta}}';
      }

      Response response = await http.patch(url3, body: jsonS);

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
      String supportD='';
      bool spl=false;
      var value2 = extractedIdeas;
      if(value2['supportDataLink']!=null) {
        if (value2['supportDataLink']) {
          spl = true;
          StorageReference fsr = FirebaseStorage.instance
              .ref()
              .child('ideas/$idQuest/$ideaId/supportData');
          var url34 = await fsr.getDownloadURL().catchError((e) {
            spl = false;
            return false;
          });
          supportD = url34 == false ? '' : url34;
        }
      }
      link=supportD;
      loadedIdeas.add(Idea.addIdea(
        id: ideaId,
        title: value2['title'],
        content: value2['content'],
        supportDataLink: spl,
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

  Future<Idea> getOneIdeaByQuest(String ideaId, String idQuest) async {
    final url =
        'https://the-rhizome.firebaseio.com/ideas/$idQuest/$ideaId.json?auth=${this.authToken}';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedIdeas = json.decode(response.body);

      Idea loadedIdea;
      if (extractedIdeas == null) {
        print('no hay idea ocn ese idques y ididea');
      } else {
        //print('extractedIdeas: '+extractedIdeas.toString());
      }
      var value2 = extractedIdeas;
      loadedIdea = Idea.addIdea(
        id: ideaId,
        title: value2['title'],
        content: value2['content'],
        //supportData: value2['supportData'],
        owner: value2['owner'],
        published: DateTime.parse(value2['published']),
        supportVotes: value2['supportVotes'],
        discardVotes: value2['discardVotes'],
      );
      return loadedIdea;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetLaunchedIdeasChildren(
      String pQuestId, String pIdeaId, String padresOHijas) async {
    final url =
        'https://the-rhizome.firebaseio.com/ideas/$pQuestId/$pIdeaId.json?auth=${this.authToken}';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedIdea = json.decode(response.body);
      Map<String, dynamic> children = extractedIdea['children'];
      Map<String, dynamic> parents = extractedIdea['parents'];
      if (children == null && padresOHijas == 'ideasHijas') {
        ideasparentsOchildren = [];
        return;
      }
      if (parents == null && padresOHijas != 'ideasHijas') {
        ideasparentsOchildren = [];
        return;
      }

      final List<Idea> loadedIdeas = [];
      if (extractedIdea == null) {
        print('no hay ideas');
        return;
      } else {
        //print('extractedIdeas: '+extractedIdeas.toString());
      }
      if (padresOHijas == 'ideasHijas') {
        for (var key in children.keys) {
          Idea x = await getOneIdeaByQuest(key, pQuestId);
          loadedIdeas.add(x);
          ideasparentsOchildren = loadedIdeas;
        }
      } else {
        for (var key in parents.keys) {
          Idea x = await getOneIdeaByQuest(key, pQuestId);
          loadedIdeas.add(x);
          ideasparentsOchildren = loadedIdeas;
        }
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void addParent(String idParent) {
    if (parents.contains(idParent))
      parents.remove(idParent);
    else
      parents.add(idParent);
  }
}

/*
* Este metodo añade padres de la idea padre, y actualiza las hijas en la base de datos.
* asumiendo que las hijas y los padres son los nodos superiores y los inferiores.
* */
//Future<void> addIdea(String title, String content, List<File> supportData,
//    String idQuest, String padre) async {
//  List<Idea> Iparents = [];
//
//  try {
//    final url =
//        'https://the-rhizome.firebaseio.com/ideas/$idQuest.json?auth=$authToken';
//    http.Response response = await http.post(
//      url,
//      body: json.encode(
//        {
//          'title': title,
//          'content': content,
//          'supportData': [],
//          'owner': userID,
//          'published': DateTime.now().toIso8601String(),
//          'supportVotes': 0,
//          'discardVotes': 0,
//          //'parents': Iparents,
//          //no lleva children porque es nueva.
//        },
//      ),
//    );
//    print('response.statusCode: ' + response.statusCode.toString());
//
//    final String ideaID = json.decode(response.body)['name'];
//    print('ideaID: ' + ideaID);
//
//    DBref.child('ideas/$idQuest').once().then((DataSnapshot snapshot) {
//      Map<dynamic, dynamic> values = snapshot.value;
//
//      print('values');
//      print(values);
//
//      values.forEach((key, value) {
//        //se recorren todas las ideas
//        if (value['children'] != null) {
//          //si las ideas tienen hijos
//          value['children'].forEach((key2, value2) {
//            //dentro de los hijos de las ideas
//            if (key2 == padre) {
//              //si es un abuelo de la idea nueva (papa del padre)
//              //se tiene que meter la nueva idea a la lista de children de los padres.
//              //Se crea la lista de parents de la idea nueva con los abuelos.
//              _addIdeaAux(ideaID, value, idQuest, padre, Iparents, key);
//            } else {
//              print('esta idea no es padre del padre');
//            }
//          });
//
//          print('Se añade al padre nuevo hijo');
//          DBref.child('ideas/$idQuest/$padre/children/$ideaID').set('depth');
//        } else {
//          print('esta idea no tiene children');
//        }
//      });
//    });
//    //Añade el padre a la lista de todos los padres y se sube parents a la nueva
//    print('Iparents');
//    print(Iparents);
//    fetchAndSetOneIdeaByQuest(padre, idQuest).then((value) {
//      Iparents.add(Idea.addIdea(
//        id: _launchedIdea.id,
//        title: _launchedIdea.title,
//        content: _launchedIdea.content,
//        //supportData: value2['supportData'],
//        owner: _launchedIdea.owner,
//        published: _launchedIdea.published,
//        supportVotes: _launchedIdea.supportVotes,
//        discardVotes: _launchedIdea.discardVotes,
//      ));
//      DBref.child('ideas/$idQuest/$ideaID/parents').set(
//        Map.fromIterable(Iparents, key: (e) => e.id, value: (e) => 'depth'),
//      );
//    });
//
//    //Se sube supportData
////      final StorageReference fsr = FirebaseStorage.instance
////          .ref()
////          .child('ideas/$idQuest/$ideaID/supportData');
////      supportData.forEach((element) {
////        // fsr.putFile(element);
////      });
////
////      print('response.statusCode: ' + response.statusCode.toString());
////      print(title);
////      print(content);
////      print('idQuest' + idQuest);
////      print('userID' + userID);
//
//    notifyListeners();
//  } catch (error) {
//    print(error);
//    throw (error);
//  }
//}
//void _addIdeaAux(String ideaNuevaID, dynamic abuelo, String idQuest,
//    String padre, List<Idea> Iparents, String idAbuelo) {
//  print('es un abuelo! ' + idAbuelo);
//  //se añade a la lista de padres cada idea abuela.
//  Iparents.add(Idea.addIdea(
//    id: idAbuelo,
//    title: abuelo['title'],
//    content: abuelo['content'],
//    //supportData: value2['supportData'],
//    owner: abuelo['owner'],
//    published: DateTime.parse(abuelo['published']),
//    supportVotes: abuelo['supportVotes'],
//    discardVotes: abuelo['discardVotes'],
//  ));
//  print('Iparents');
//  print(Iparents);
//
//  Map<dynamic, dynamic> abueloChildren = Map<dynamic, dynamic>();
//  abuelo['children'].forEach((k, v) {
//    abueloChildren[k] = v;
//  });
//  abueloChildren['$ideaNuevaID'] = 'depth';
////    //Se añade a los abuelos el nuevo hijo
//  print('Se añade a los abuelos el nuevo hijo');
//  DBref.child('ideas/$idQuest/$idAbuelo/children').set(abueloChildren);
//}
