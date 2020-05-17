import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:saisa_live_app/models/livestream_model.dart';
import 'package:saisa_live_app/models/games_model.dart';
import 'package:saisa_live_app/models/media_model.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:saisa_live_app/models/tournament_participant_model.dart';
import 'package:saisa_live_app/models/meets_model.dart';
import 'package:saisa_live_app/models/meets2_model.dart';
import 'package:saisa_live_app/models/team_model.dart';


//const baseUrl = "http://142.93.212.170:8080/saisa-live/";
const baseUrl = "http://anuda.me:8080/saisa-live/";


Future<List<Livestream>> getAllLivestreams(bool liveStatus, int tournamentId) async{
  String url;
  if(liveStatus) {
   url = baseUrl + '/livestreams?tournamentId='+tournamentId.toString()+'&liveNow=1';
  }else{
    url = baseUrl + '/livestreams?tournamentId='+tournamentId.toString()+'&liveNow=0';
  }
  final response = await http.get(url);

  if(response.statusCode==200){
    List<Livestream> liveStreamsList;

    var data = json.decode(response.body) as List;
    liveStreamsList = data.map<Livestream>((json)=>Livestream.fromJson(json)).toList();

    return liveStreamsList;

  }else{
    return null;
  }

}

Future<List<Team>> getAllTeams() async{

  String url = baseUrl+'/teams?teamId=0';

  final response = await http.get(url);

  if(response.statusCode==200){
    List<Team> teamsList;

    var data = json.decode(response.body) as List;
    teamsList = data.map<Team>((json)=>Team.fromJson(json)).toList();

    return teamsList;

  }else{
    return null;
  }

}


Future<List<Game>> getGames(int activeStatus) async{

  String url = baseUrl+'/games?activeStatus='+activeStatus.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<Game> gamesList;

    var data = json.decode(response.body) as List;
    gamesList = data.map<Game>((json)=>Game.fromJson(json)).toList();

    return gamesList;
  }else{
    return null;
  }

}


Future<List<Media>> getMedia(int type, int tournamentId) async{
  String url = baseUrl+'/media?tournamentId='+tournamentId.toString()+'&type='+type.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<Media> mediaList;

    var data = json.decode(response.body) as List;
    mediaList = data.map<Media>((json)=>Media.fromJson(json)).toList();

    return mediaList;
  }else{
    return null;
  }

}

Future<List<Media>> getPhotos(int tournamentId, String accessCode) async{
  String url = baseUrl+'/media?tournamentId='+tournamentId.toString()+'&type=1&accessCode='+accessCode;

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<Media> mediaList;

    var data = json.decode(response.body) as List;
    mediaList = data.map<Media>((json)=>Media.fromJson(json)).toList();

    return mediaList;
  }else{
    return null;
  }

}

Future<List<Tournament>> getTournaments(bool active) async{

  String url;

  if(active){
    url = baseUrl+'/tournaments?tournamentId=0';
  }else{
    url = baseUrl+'/tournaments/inactive';
  }

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<Tournament> tournamentList;

    var data = json.decode(response.body) as List;
    tournamentList = data.map<Tournament>((json)=>Tournament.fromJson(json)).toList();

    return tournamentList;
  }else{
    return null;
  }

}

Future<Tournament> getTournamentById(int tournamentId) async{

  String url = baseUrl+'/tournaments?tournamentId='+tournamentId.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    Tournament tournament;

    var data = json.decode(response.body);
    tournament = new Tournament.fromJson(data);
    return tournament;
  }else{
    return null;
  }




}

Future<List<Game>> getGamesByTorunamentId(int activeStatus, int tournamentId) async{

  String url = baseUrl+'/games?activeStatus='+activeStatus.toString()+'&tournamentId='+tournamentId.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<Game> gamesList;

    var data = json.decode(response.body) as List;
    gamesList = data.map<Game>((json)=>Game.fromJson(json)).toList();

    return gamesList;
  }else{
    return null;
  }

}

Future<TournamentParticipants> getParticipantsByTournament(int tournamentId) async{

  String url = baseUrl+'/tournaments/participants/?tournamentId='+tournamentId.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    TournamentParticipants tournamentParticipants;

    var data = json.decode(response.body);
    tournamentParticipants = new TournamentParticipants.fromJson(data);
    return tournamentParticipants;
  }else{
    return null;
  }




}

Future<List<Meets>> getMeets(int activeStatus) async{

  String url = baseUrl+'/meets?activeStatus='+activeStatus.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<Meets> meetsList;

    var data = json.decode(response.body) as List;
    meetsList = data.map<Meets>((json)=>Meets.fromJson(json)).toList();

    return meetsList;
  }else{
    return null;
  }

}

Future<List<MeetsLive>> getMeetsLive(int activeStatus) async{

  String url = baseUrl+'/meets?activeStatus='+activeStatus.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<MeetsLive> meetsList;

    var data = json.decode(response.body) as List;
    meetsList = data.map<MeetsLive>((json)=>MeetsLive.fromJson(json)).toList();

    return meetsList;
  }else{
    return null;
  }

}

Future<List<Meets>> getMeetsByTournamentId(int activeStatus, int tournamentId) async{

  String url = baseUrl+'/meets?activeStatus='+activeStatus.toString()+'&tournamentId='+tournamentId.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<Meets> meetsList;

    var data = json.decode(response.body) as List;
    meetsList = data.map<Meets>((json)=>Meets.fromJson(json)).toList();

    return meetsList;
  }else{
    return null;
  }

}

Future<List<MeetsLive>> getMeetsLiveByTournamentId(int activeStatus, int tournamentId) async{

  String url = baseUrl+'/meets?activeStatus='+activeStatus.toString()+'&tournamentId='+tournamentId.toString();

  final response = await http.get(url);

  if(response.statusCode == 200){
    List<MeetsLive> meetsList;

    var data = json.decode(response.body) as List;
    meetsList = data.map<MeetsLive>((json)=>MeetsLive.fromJson(json)).toList();

    return meetsList;
  }else{
    return null;
  }

}

Future<int>registerUser(String deviceName) async{

  String url = baseUrl+'/users/new?deviceName='+deviceName;

  final response = await http.get(url);

  if(response.statusCode==200){
    return int.parse(response.body);
  }else{
    return null;
  }

}

Future<bool>followTeams(List<int>followingList, int userId) async{

  String url = baseUrl+'/users/follow';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"userId": "'+userId.toString()+'", "followingList": '+followingList.toString()+'}';

  final response = await http.post(url, headers: headers, body: json1);

  if(response.statusCode==200){
    return true;
  }else{
    return null;
  }

}
