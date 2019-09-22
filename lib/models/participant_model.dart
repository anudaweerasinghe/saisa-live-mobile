import 'package:saisa_live_app/models/team_model.dart';

class Participant{

  int id;
  Team team;
  int standing;
  int wins;
  int losses;
  int ties;
  int games;
  double points;
  int pool;
  String teamPhoto;
  bool active;

  Participant({this.id, this.team, this.standing, this.wins, this.losses,
      this.ties, this.games, this.points, this.pool, this.teamPhoto,
      this.active});


  factory Participant.fromJson(Map<String, dynamic> json){
    return new Participant(
        team: Team.fromJson(json['team']),
        id: json['id'],
        standing: json['standing'],
        wins: json['wins'],
        losses: json['losses'],
        ties: json['ties'],
        games: json['games'],
        points: json['points'],
        pool: json['pool'],
        teamPhoto: json['teamPhoto'],
        active: json['active']

    );
  }

}