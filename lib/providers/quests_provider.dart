import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:http/http.dart' as http;

class QuestsProvider with ChangeNotifier {
  ///quests_provider.dart
  ///
  ///
  List<Quest> _launchedQuests;

  ///quests_provider.dart
  ///
  ///
  List<Quest> get launchedQuests {
    return [..._launchedQuests];
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
  void addQuest(Quest quest) {
    _launchedQuests.add(quest);
    notifyListeners();
  }
}
