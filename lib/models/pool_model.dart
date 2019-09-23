import 'package:saisa_live_app/models/participant_model.dart';

class Pool{

  int pool;
  List<Participant> participants;

  Pool({this.pool, this.participants});

  factory Pool.fromJson(Map<String, dynamic> json){


    var participantsFromJson = json['participants'] as List;
    List<Participant> participantList = participantsFromJson.map<Participant>((json)=>Participant.fromJson(json)).toList();

    return new Pool(
      participants:participantList,
      pool: json['pool'],
    );
  }


}