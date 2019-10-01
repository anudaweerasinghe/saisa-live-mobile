import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saisa_live_app/pages/live_home.dart';
import 'package:saisa_live_app/models/games_model.dart';
import 'package:saisa_live_app/helpers/api.dart';
import 'package:saisa_live_app/pages/media_home.dart';
import 'package:saisa_live_app/pages/events_home.dart';
import 'package:saisa_live_app/models/tournament_model.dart';

import 'package:async/async.dart';

import 'package:url_launcher/url_launcher.dart';


class ScoresHomeScreen extends StatefulWidget {

  final int tournamentId;

  ScoresHomeScreen(
      {Key key, this.tournamentId})
      : super(key: key);

  @override
  _ScoresHomeScreenState createState() => new _ScoresHomeScreenState(tournamentId: tournamentId);
}

class _ScoresHomeScreenState extends State<ScoresHomeScreen> {

  bool live;
  bool fixtures;
  bool results;


  List<Game> liveList;
  List<Game> resultsList;
  List<Game> fixturesList;
  List<String> resultDescriptions;

  Tournament tournamentDetails;
  int tournamentId;
  bool tournamentSelected;

  _ScoresHomeScreenState({Key key, this.tournamentId});


  @override
  initState() {
    super.initState();

    live = true;
    fixtures = false;
    results = false;

    liveList = new List();
    resultsList = new List();
    fixturesList = new List();
    resultDescriptions = new List();

    tournamentDetails = new Tournament();
    tournamentDetails.name = "";

    if(tournamentId==null){
      tournamentSelected = false;
    }else{
      tournamentSelected = true;
    }


    getData();
  }

  getData() async {

    if(tournamentSelected==false) {
      List<Game> liveG = await getGames(1);
      List<Game> resultG = await getGames(2);
      List<Game> fixtureG = await getGames(0);

      liveList = liveG.reversed.toList();
      resultsList = resultG.reversed.toList();
      fixturesList = fixtureG.reversed.toList();

    }else{

      tournamentDetails = await getTournamentById(tournamentId);

      List<Game> liveG = await getGamesByTorunamentId(1, tournamentId);
      List<Game> resultG = await getGamesByTorunamentId(2, tournamentId);
      List<Game> fixtureG = await getGamesByTorunamentId(0, tournamentId);

      liveList = liveG.reversed.toList();
      resultsList = resultG.reversed.toList();
      fixturesList = fixtureG;


    }

    for(int i=0;i<resultsList.length; i++){
      if(resultsList[i].result==1){
        resultDescriptions.add(resultsList[i].team1.team.name+" Won");
      }else if(resultsList[i].result==2){
        resultDescriptions.add(resultsList[i].team2.team.name+" Won");
      }else{
        resultDescriptions.add("No Result");
      }
    }

    setState(() {});
  }

  openStream(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int selectedIndex = 0;
  Color eventsBg = Colors.black54;
  Color scoresBg = Color.fromARGB(255, 20, 136, 204);

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new LiveHomeScreen()),
        );
      } else if (selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new MediaHomeScreen()),
        );
      }else if (selectedIndex == 3) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new EventsHomeScreen()),
        );
      }
    });
  }

  void changeType(int newSelection) {
    if (newSelection == 1) {
      live = true;
      fixtures = false;
      results = false;
    } else if (newSelection == 2) {
      fixtures = true;
      live = false;
      results = false;
    } else {
      results = true;
      fixtures = false;
      live = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if(live) {
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              elevation: 0,
              title: new Text(
                tournamentSelected?tournamentDetails.name:'SAISA Live',
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
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          new Color.fromARGB(255, 20, 136, 204),
                          new Color.fromARGB(255, 43, 51, 178)
                        ],
                      ),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          blurRadius: 8.0,
                        ),
                      ]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("LIVE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration:
                                  live ? TextDecoration.underline : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(1);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("FIXTURES",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: fixtures
                                      ? TextDecoration.underline
                                      : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(2);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("RESULTS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration:
                                  results ? TextDecoration.underline : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(3);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: liveList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          ),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          liveList[index].tournament.name,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "LIVE",
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto',
                                              color: Colors.redAccent),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                  ),
                                  Text(
                                    liveList[index].gameDescription +
                                        " - " +
                                        liveList[index].startTime,
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Image.network(
                                          liveList[index].team1.team.logo,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          liveList[index].team1.team.name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                          liveList[index].team1Score,
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Image.network(
                                          liveList[index].team2.team.logo,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          liveList[index].team2.team.name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                          liveList[index].team2Score,
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Center(
                                      child: ButtonTheme(
                                        minWidth: double.infinity,
                                        child: RaisedButton(
                                          onPressed: () {
                                            openStream(liveList[index].livestream.url);
                                          },
                                          textColor: Colors.white,
                                          color: Color.fromARGB(
                                              255, 20, 136, 204),
                                          elevation: 0,
                                          child: Text("Watch Live"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10)
                                          ),
                                        ),
                                      )
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ]),
        bottomNavigationBar: !tournamentSelected?BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: new Image.asset(
                  "images/scores.png",
                  width: 24,
                  height: 24,
                  color: scoresBg,
                ),
                title: Text('SCORES')),
            BottomNavigationBarItem(
                icon: Icon(Icons.live_tv), title: Text('LIVE')),

            BottomNavigationBarItem(
                icon: Icon(Icons.photo_library), title: Text('MEDIA')),
            BottomNavigationBarItem(
                icon: new Image.asset(
                  "images/trophy.png",
                  width: 24,
                  height: 24,
                  color: eventsBg,
                ),
                title: Text('EVENTS')),
          ],
          currentIndex: selectedIndex,
          fixedColor: Color.fromARGB(255, 20, 136, 204),
          onTap: onNavigationItemTapped,
        ):null,
      );
    }else if(fixtures){
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              elevation: 0,
              title: new Text(
                tournamentSelected?tournamentDetails.name:'SAISA Live',
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
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          new Color.fromARGB(255, 20, 136, 204),
                          new Color.fromARGB(255, 43, 51, 178)
                        ],
                      ),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          blurRadius: 8.0,
                        ),
                      ]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("LIVE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration:
                                  live ? TextDecoration.underline : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(1);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("FIXTURES",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: fixtures
                                      ? TextDecoration.underline
                                      : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(2);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("RESULTS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration:
                                  results ? TextDecoration.underline : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(3);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: fixturesList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          ),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          fixturesList[index].tournament.name,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0))
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                  ),
                                  Text(
                                    fixturesList[index].gameDescription +
                                        " - " +
                                        fixturesList[index].startTime,
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Image.network(
                                          fixturesList[index].team1.team.logo,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          fixturesList[index].team1.team.name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                          "0",
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Image.network(
                                          fixturesList[index].team2.team.logo,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          fixturesList[index].team2.team.name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                          "0",
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ]),
        bottomNavigationBar: !tournamentSelected?BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: new Image.asset(
                  "images/scores.png",
                  width: 24,
                  height: 24,
                  color: scoresBg,
                ),
                title: Text('SCORES')),
            BottomNavigationBarItem(
                icon: Icon(Icons.live_tv), title: Text('LIVE')),

            BottomNavigationBarItem(
                icon: Icon(Icons.photo_library), title: Text('MEDIA')),
            BottomNavigationBarItem(
                icon: new Image.asset(
                  "images/trophy.png",
                  width: 24,
                  height: 24,
                  color: eventsBg,
                ),
                title: Text('EVENTS')),
          ],
          currentIndex: selectedIndex,
          fixedColor: Color.fromARGB(255, 20, 136, 204),
          onTap: onNavigationItemTapped,
        ):null,
      );
    }else{
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              elevation: 0,
              title: new Text(
                tournamentSelected?tournamentDetails.name:'SAISA Live',
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
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          new Color.fromARGB(255, 20, 136, 204),
                          new Color.fromARGB(255, 43, 51, 178)
                        ],
                      ),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          blurRadius: 8.0,
                        ),
                      ]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("LIVE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration:
                                  live ? TextDecoration.underline : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(1);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("FIXTURES",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: fixtures
                                      ? TextDecoration.underline
                                      : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(2);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text("RESULTS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration:
                                  results ? TextDecoration.underline : null)),
                          color: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            changeType(3);
                          },
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: resultsList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          ),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          resultsList[index].tournament.name,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0))
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                  ),
                                  Text(
                                    resultsList[index].gameDescription +
                                        " - " +
                                        resultsList[index].startTime,
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Image.network(
                                          resultsList[index].team1.team.logo,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          resultsList[index].team1.team.name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                          resultsList[index].team1Score,
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Image.network(
                                          resultsList[index].team2.team.logo,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          resultsList[index].team2.team.name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                          resultsList[index].team2Score,
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 19.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Center(
                                    child:Text(
                                      resultDescriptions[index],
                                      textAlign: TextAlign.right,
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                      ),
                                    ) ,
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                  ),
                                  Center(
                                      child: ButtonTheme(
                                        minWidth: double.infinity,
                                        child: RaisedButton(
                                          onPressed: () {
                                            openStream(resultsList[index].livestream.url);
                                          },
                                          textColor: Colors.white,
                                          color: Color.fromARGB(
                                              255, 20, 136, 204),
                                          elevation: 0,
                                          child: Text("Replay Game Coverage"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10)
                                          ),
                                        ),
                                      )
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ]),
        bottomNavigationBar: !tournamentSelected?BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: new Image.asset(
                  "images/scores.png",
                  width: 24,
                  height: 24,
                  color: scoresBg,
                ),
                title: Text('SCORES')),
            BottomNavigationBarItem(
                icon: Icon(Icons.live_tv), title: Text('LIVE')),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_library), title: Text('MEDIA')),
            BottomNavigationBarItem(
                icon: new Image.asset(
                  "images/trophy.png",
                  width: 24,
                  height: 24,
                  color: eventsBg,
                ),
                title: Text('EVENTS')),
          ],
          currentIndex: selectedIndex,
          fixedColor: Color.fromARGB(255, 20, 136, 204),
          onTap: onNavigationItemTapped,
        ):null,
      );

    }
  }
}
