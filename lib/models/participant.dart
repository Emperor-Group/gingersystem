import 'package:gingersystem/models/quest.dart';
import 'package:gingersystem/models/user.dart';

class Participant
{
  /// 
  /// The secret identifier for a participant 
  /// 
  String pseudonym;

  ///
  /// The support percentage for the quest
  ///
  double supportPercentage;
  
  ///
  /// The owner of the pseudonym 
  ///
  User user;

  ///
  /// The quest the user is being a participant on
  ///
  Quest participating;


  ///
  /// Constructor for the class
  ///
  Participant({this.pseudonym, this.user, this.participating})
  {
    this.supportPercentage = 0.0;
  }

}