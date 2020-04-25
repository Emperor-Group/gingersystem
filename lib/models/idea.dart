
import 'package:gingersystem/models/comment.dart';
import 'package:gingersystem/models/participant.dart';
import 'package:gingersystem/models/status.dart';

/// 
/// Class that models the basic entries of the forum which is the quest
/// 
class Idea{

  /// 
  /// Models for a clase sequence to generate unique identifiers
  /// 
  static int _sequence;

  ///
  /// Models the ideas identifier
  ///
  int id;

  ///
  /// Models for the Idea Title for the class
  ///
  String title;

  /// 
  /// Models the description of the idea
  /// 
  String description;

  /// 
  /// Models the status in which the idea is currently at
  /// 
  Status currentStatus;

  ///
  ///
  ///
  Participant owner;

  ///
  ///
  ///
  List<Comment> commentsMade;

  ///
  /// Constructor class for the first idea created in a quest
  ///
  Idea.initialIdea({this.title, this.description, this.owner})
  {
    _sequence++;
    this.id = _sequence;
    currentStatus = Status.OK;
  }

  ///
  /// Construtor class for creating a new idea
  ///
  Idea.addIdea({this.title, this.description, this.owner})
  {
    _sequence++;
    this.id = _sequence;
    currentStatus = Status.VERIFICATION;
  }

  ///
  /// Getter for the comments
  ///
  get sortedCommentsMostVotes
  {
    this.commentsMade.sort((a, b) => b.votes.compareTo(a.votes));
  }
  

}