import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:http/http.dart' as http;

class QuestsProvider with ChangeNotifier {
  ///quests_provider.dart
  ///
  ///
  List<Quest> _launchedQuests = [];

  ///quests_provider.dart
  ///
  ///
  List<Quest> get launchedQuests {
    return [..._launchedQuests];
  }

  List<Quest> get upComingQuests {
    List<Quest> copy = _launchedQuests
        .where((quest) => quest.deadline.isAfter(DateTime.now()))
        .toList();
    copy.sort((questA, questB) => questA.deadline.compareTo(questB.deadline));
    return copy;
  }

  ///quests_provider.dart
  ///
  ///
  Quest getByID(String id) {
    return _launchedQuests.firstWhere((Quest quest) => quest.id == id);
  }

  ///quests_provider.dart
  ///
  ///
  Future<void> addQuest(Quest quest) async {
    const url = 'https://the-rhizome.firebaseio.com/quests.json';
    try {
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'title': quest.title,
            'launched': quest.publisher,
            'deadline': quest.deadline,
            'ideas': [
              {
                'title': quest.initialIdea.title,
                'content': quest.initialIdea.content,
                'published': quest.initialIdea.published,
              },
            ],
          },
        ),
      );

      _launchedQuests.insert(
        0,
        Quest.initializeQuest(
          id: json.decode(response.body)['name'],
          title: quest.title,
          launchedDate: quest.launchedDate,
          deadline: quest.deadline,
          initIdeaID: '0',
        ),
      );
      notifyListeners();
    } catch (error) {}
  }

  ///quest.dart
  ///
  ///
  Future<void> fetchAndSetLaunchedQuests() async {
    const url = 'https://the-rhizome.firebaseio.com/quests.json';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedQuests = json.decode(response.body);
      final List<Quest> loadedQuests = [];
      if (extractedQuests == null) {
        return;
      }
      extractedQuests.forEach(
        (key, value) {
          loadedQuests.add(
            Quest.initializeQuest(
              id: key,
              title: value['title'],
              launchedDate: DateTime.parse(value['launched']),
              deadline: DateTime.parse(value['deadline']),
              initIdeaID: (value['initialIdea'] as Map).keys.toList()[0],
            ),
          );
        },
      );
      _launchedQuests = loadedQuests;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
