import 'package:saisa_live_app/models/tournament_model.dart';

class Livestream {

  int id;
  Tournament tournament;
  String url;
  String description;
  bool live;
  bool active;

  Livestream({
    this.id,
    this.tournament,
    this.url,
    this.description,
    this.live,
    this.active
  });

  factory Livestream.fromJson(Map<String, dynamic> json){
    return new Livestream(
        tournament: Tournament.fromJson(json['tournament']),
        id: json['id'],
        url: json['url'],
        description: json['description'],
        live: json['live'],
        active: json['active']

    );
  }

}