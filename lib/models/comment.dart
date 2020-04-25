import 'package:gingersystem/models/participant.dart';

class Comment{

  /// 
  /// Models for a clase sequence to generate unique identifiers
  /// 
  static int _sequence;

  ///
  /// Models the comments identifier
  ///
  int id;

  ///
  /// Models the title of a comment
  ///
  String title;

  ///
  /// Models the description of the comment
  ///
  String content;

  ///
  /// Models the number of votes the comment has
  ///
  int votes;

  /// 
  /// Models who published this comment
  /// 
  Participant publisher;

  ///
  /// Constructor for creating a comment
  ///
  Comment.create({this.title, this.content, this.publisher})
  {
    _sequence++;
    this.id = _sequence;
    this.votes = 0;
  }

}