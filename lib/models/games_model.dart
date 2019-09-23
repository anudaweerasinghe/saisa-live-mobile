import 'package:saisa_live_app/models/participant_model.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:saisa_live_app/models/livestream_entity_model.dart';


class Game{

  int id;
  Participant team1;
  Participant team2;
  String team1Score;
  String team2Score;
  int result;
  int activeStatus;
  LivestreamEntity livestream;
  Tournament tournament;
  String location;
  String gameDescription;
  String startTime;

  Game({this.id, this.team1, this.team2, this.team1Score, this.team2Score,
      this.result, this.activeStatus, this.livestream, this.tournament,
      this.location, this.gameDescription, this.startTime});

  factory Game.fromJson(Map<String, dynamic> json){
    return new Game(
        team1: Participant.fromJson(json['team1']),
        team2: Participant.fromJson(json['team2']),
        livestream: LivestreamEntity.fromJson(json['livestream']),
        tournament: Tournament.fromJson(json['tournament']),
        id: json['id'],
        team1Score: json['team1Score'],
        team2Score: json['team2Score'],
        result: json['result'],
        activeStatus: json['activeStatus'],
        location: json['location'],
        gameDescription: json['gameDescription'],
        startTime: json['startTime'],


    );
  }


}