import 'package:gingersystem/models/connector.dart';
import 'package:gingersystem/models/idea.dart';
import 'package:gingersystem/models/participant.dart';
import 'package:graph_collection/graph.dart';

class Quest {
  ///
  /// Models the sequence to generate ids
  ///
  static int _sequence;

  ///
  /// Models the unique identifier for the quest
  ///
  int id;

  ///
  /// Models the name given to the quest
  ///
  String name;

  ///
  /// Models the participants in the quest
  ///
  List<Participant> participants;

  ///
  /// Models the graph of ideas
  ///
  Graph dynamicForum;

  ///
  /// Constructor for the class
  ///
  Quest.startQuest({this.name, this.participants, Idea initialIdea}) {
    _sequence++;
    this.id = _sequence;
    this.dynamicForum = new Graph();
    this.dynamicForum.add(initialIdea);
  }

  ///
  /// Add to an Idea and set this as child of an specified parent Idea with ID
  ///
  void addIdeaLinkedTo(int ideaID, Idea newIdea, Connector type) {
    this.dynamicForum.add(newIdea);
    Idea parent = this
        .dynamicForum
        .firstWhere((dynamic element) => (element as Idea).id == ideaID);
    this.dynamicForum.setTo(parent, newIdea, 'type', type);
  }

  ///
  /// Get all child nodes from a parent Idea with the specified ID
  ///
  List<Idea> allChildIdeas(int ideaID) {
    Idea parent = this
        .dynamicForum
        .firstWhere((dynamic element) => (element as Idea).id == ideaID);
    return this.dynamicForum.where((dynamic element) =>
        this.dynamicForum.hasEdgeTo(parent, element, 'type'));
  }

  ///
  /// Get the parent of the Idea identified with ID
  ///
  Idea parent(int ideaID) {
    Idea child = this
        .dynamicForum
        .firstWhere((dynamic element) => (element as Idea).id == ideaID);
    return this.dynamicForum.firstWhere((dynamic element) =>
        (this.dynamicForum.get(element, child, 'type') as int) ==
        Connector.values.indexOf(Connector.DEPTH));
  }
}
