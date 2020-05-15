import 'package:saisa_live_app/models/participant_model.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:saisa_live_app/models/livestream_entity_model.dart';


class Meets{

  int id;
  Participant p1Team;
  Participant p2Team;
  Participant p3Team;
  int activeStatus;
  LivestreamEntity livestream;
  Tournament tournament;
  String description;
  String startTime;
  String resultUrl;
  String p1name;
  String p2name;
  String p3name;
  String p1result;
  String p2result;
  String p3result;
  bool p1record;
  bool p2record;
  bool p3record;


  Meets({this.id, this.p1Team, this.p2Team, this.p3Team, this.activeStatus,
      this.livestream, this.tournament, this.description, this.startTime,
      this.resultUrl, this.p1name, this.p2name, this.p3name, this.p1result,
      this.p2result, this.p3result, this.p1record, this.p2record,
      this.p3record});

  factory Meets.fromJson(Map<String, dynamic> json){
    return new Meets(
        p1Team: Participant.fromJson(json['p1Team']),
        p2Team: Participant.fromJson(json['p2Team']),
        p3Team: Participant.fromJson(json['p3Team']),
        livestream: LivestreamEntity.fromJson(json['livestream']),
        tournament: Tournament.fromJson(json['tournament']),
        id: json['id'],
        activeStatus: json['activeStatus'],
        description: json['description'],
        startTime: json['startTime'],
        p1name: json['p1name'],
        p1result: json['p1result'],
        p1record: json['p1record'],
        p2name: json['p2name'],
        p2result: json['p2result'],
        p2record: json['p2record'],
        p3name: json['p3name'],
        p3result: json['p3result'],
        p3record: json['p3record'],
        resultUrl: json['resultUrl']


    );
  }


}