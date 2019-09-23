import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:saisa_live_app/models/livestream_model.dart';
import 'package:saisa_live_app/models/games_model.dart';
import 'package:saisa_live_app/models/media_model.dart';


const baseUrl = "http://localhost:8080";


Future<List<Livestream>> getAllLivestreams(bool liveStatus) async{
  String url;
  if(liveStatus) {
   url = baseUrl + '/livestreams?tournamentId=0&liveNow=1';
  }else{
    url = baseUrl + '/livestreams?tournamentId=0&liveNow=0';
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


Future<List<Media>> getMedia(int type) async{
  String url = baseUrl+'/media?tournamentId=0&type='+type.toString();

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