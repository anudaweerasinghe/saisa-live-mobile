import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:async/async.dart';
import 'package:saisa_live_app/helpers/api.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:saisa_live_app/models/tournament_participant_model.dart';

class StandingsScreen extends StatefulWidget {
  final int tournamentId;

  StandingsScreen({Key key, @required this.tournamentId}) : super(key: key);

  @override
  _StandingsScreenState createState() =>
      new _StandingsScreenState(tournamentId: tournamentId);
}

class _StandingsScreenState extends State<StandingsScreen> {
  int tournamentId;
  Tournament tournamentDetails;
  TournamentParticipants tournamentParticipants;
  int scores;

  _StandingsScreenState({Key key, @required this.tournamentId});

  @override
  initState() {
    super.initState();
    scores = 0;   //Scores null
    tournamentDetails = new Tournament();
    tournamentDetails.name = "";
    tournamentParticipants = new TournamentParticipants();

    getData();
  }

  getData() async {
    tournamentDetails = await getTournamentById(tournamentId);
    tournamentParticipants = await getParticipantsByTournament(tournamentId);

    for(int i=0;i<tournamentParticipants.pools.length;i++){

      tournamentParticipants.pools[i].participants.sort((a, b){
        return a.standing.compareTo(b.standing);
      });

    }

    if(tournamentDetails.scoresActive){
      scores = 1; //Scores active
    }else{
      scores = 2; //Scores inactive
    }



    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    if(scores ==1){
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              elevation: 0,
              title: new Text(
                tournamentDetails.name,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      new Color.fromARGB(255, 20, 136, 204),
                      new Color.fromARGB(255, 43, 51, 178)
                    ],
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(55)),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: tournamentParticipants.pools.length,
                  itemBuilder: (context, index) {
                    return new Column(
                      children: <Widget>[
                        Text(
                          "Pool " + (index + 1).toString(),
                          style: new TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Roboto'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                "",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Team",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Games",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Wins",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Losses",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "NRs",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Points",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Standing",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: tournamentParticipants
                                .pools[index].participants.length,
                            itemBuilder: (context, index1) {

                              return new Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Image.network(
                                            tournamentParticipants.pools[index].participants[index1].team.logo,
                                            width: 25,
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                          )
                                        ],
                                      )
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].team.name,
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].games.toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].wins.toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].losses.toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].ties.toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].points.toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].standing.toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                ],
                              );
                            }),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        )
                      ],
                    );
                  })
            ],
          ),
        ),
      );
    }else if(scores == 0){
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              elevation: 0,
              title: new Text(
                tournamentDetails.name,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      new Color.fromARGB(255, 20, 136, 204),
                      new Color.fromARGB(255, 43, 51, 178)
                    ],
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(55)),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      );

    } else{
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              elevation: 0,
              title: new Text(
                tournamentDetails.name,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      new Color.fromARGB(255, 20, 136, 204),
                      new Color.fromARGB(255, 43, 51, 178)
                    ],
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(55)),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: tournamentParticipants.pools.length,
                  itemBuilder: (context, index) {
                    return new Column(
                      children: <Widget>[
                        Text(
                          "Pool " + (index + 1).toString(),
                          style: new TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Roboto'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                "",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Team",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),

                            Expanded(
                              flex: 5,
                              child: Text(
                                "Points",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Standing",
                                style: new TextStyle(
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: tournamentParticipants
                                .pools[index].participants.length,
                            itemBuilder: (context, index1) {

                              return new Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Image.network(
                                            tournamentParticipants.pools[index].participants[index1].team.logo,
                                            width: 25,
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                          )
                                        ],
                                      )
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].team.name,
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].points.toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      tournamentParticipants.pools[index].participants[index1].standing.toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto'),
                                    ),
                                  ),
                                ],
                              );
                            }),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        )
                      ],
                    );
                  })
            ],
          ),
        ),
      );
    }

  }
}
