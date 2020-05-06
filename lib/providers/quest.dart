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
  String id;

  ///quest.dart
  ///
  ///
  String name;

  ///quest.dart
  ///
  ///
  DateTime launchedDate;

  ///quest.dart
  ///
  ///
  DateTime deadline;

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

  ///quest.dart
  ///
  ///
  Quest.initializeQuest({
    @required this.id,
    @required this.name,
    @required this.deadline,
    @required this.initialIdea,
  }) {
    launchedDate = DateTime.now();
    _dynamicIdeasForum = new DirectedValueGraph();
    _dynamicIdeasForum.add(initialIdea);
  }

  ///quest.dart
  /// Returns an idea based on the given id
  ///
  Idea getByID(String id) {
    return _dynamicIdeasForum.firstWhere(
      (dynamic idea) => (idea as Idea).id == id,
    );
  }

  ///quest.dart
  /// Gets all the children for a given idea
  ///
  List<Idea> getAllChildren(String parentID) {
    Idea theParent = this.getByID(parentID);
    return this
        ._dynamicIdeasForum
        .where((dynamic idea) =>
            this._dynamicIdeasForum.hasEdgeToBy<Connector>(theParent, idea))
        .toList();
  }

  ///quest.dart
  /// Gets the last ideas that have no children
  ///
  List<Idea> getLeafs() {
    return this._dynamicIdeasForum.where((dynamic idea) =>
        this._dynamicIdeasForum.valueTosBy<Connector>(idea).isEmpty);
  }

  ///quest.dart
  ///
  ///
  List<Idea> getChildrenIdeasFilteredByType(String parentID, Connector type) {
    Idea parent = this.getByID(parentID);
    return this.getAllChildren(parentID).where(
          (element) =>
              (this._dynamicIdeasForum.getBy<Connector>(parent, element)
                  as Connector) ==
              type,
        );
  }

  ///quest.dart
  ///
  ///
  List<Idea> getParents(String childID) {
    Idea child = this.getByID(childID);
    return this
        ._dynamicIdeasForum
        .where(
          (element) => this._dynamicIdeasForum.hasEdgeToBy<Connector>(
                element,
                child,
              ),
        )
        .toList();
  }

  ///quest.dart
  ///
  ///
  void addIdeaLinkedToParentByConnector(
      String parentID, Idea child, Connector type) {
    this._dynamicIdeasForum.add(child);
    Idea parent = this.getByID(parentID);
    this._dynamicIdeasForum.setToBy<Connector>(parent, child, type);
    notifyListeners();
  }

  ///quest.dart
  ///
  ///
  void combineIdeas(List<String> parentsIDs, Idea mixedChild) {
    this._dynamicIdeasForum.add(mixedChild);
    List<Idea> parents = new List();
    parentsIDs.forEach((String id) => parents.add(this.getByID(id)));
    parents.forEach(
      (element) => this._dynamicIdeasForum.setToBy<Connector>(
            element,
            mixedChild,
            Connector.CONVERGENT,
          ),
    );
    notifyListeners();
  }
}
