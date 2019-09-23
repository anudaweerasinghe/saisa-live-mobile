import 'package:saisa_live_app/models/pool_model.dart';


class TournamentParticipants{

  List<Pool> pools;
  String name;
  int sportId;
  String url;
  String logo;
  String location;
  String startDate;
  String endDate;
  bool standingsActive;
  bool scoresActive;
  bool poolsActive;
  int poolQuantity;
  bool active;

  TournamentParticipants({this.pools, this.name, this.sportId, this.url,
      this.logo, this.location, this.startDate, this.endDate,
      this.standingsActive, this.scoresActive, this.poolsActive,
      this.poolQuantity, this.active});

  factory TournamentParticipants.fromJson(Map<String, dynamic> json){

    var poolsFromJson = json['pools'] as List;
    List<Pool> poolsList = poolsFromJson.map<Pool>((json)=>Pool.fromJson(json)).toList();

    return new TournamentParticipants(
      pools: poolsList,
      name:json['name'],
      sportId:json['sportId'],
      url:json['url'],
      logo:json['logo'],
      location:json['location'],
      startDate:json['startDate'],
      endDate:json['endDate'],
      standingsActive:json['standingsActive'],
      scoresActive:json['scoresActive'],
      poolsActive:json['poolsActive'],
      poolQuantity:json['poolQuantity'],
      active:json['active'],

    );
  }


}