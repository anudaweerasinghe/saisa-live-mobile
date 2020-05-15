import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saisa_live_app/pages/live_home.dart';
import 'package:saisa_live_app/helpers/api.dart';
import 'package:saisa_live_app/pages/media_home.dart';
import 'package:saisa_live_app/pages/events_home.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:saisa_live_app/pages/scores_home.dart';

import 'package:async/async.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'package:saisa_live_app/models/games_model.dart';
import 'package:saisa_live_app/models/meets_model.dart';
import 'package:saisa_live_app/models/meets2_model.dart';

class MeetsHomeScreen extends StatefulWidget {

  final int tournamentId;

  MeetsHomeScreen(
      {Key key, this.tournamentId})
      : super(key: key);

  @override
  _MeetsHomeScreenState createState() => new _MeetsHomeScreenState(tournamentId: tournamentId);
}

class _MeetsHomeScreenState extends State<MeetsHomeScreen> {

  bool live;
  bool fixtures;
  bool results;


  List<MeetsLive> liveList;
  List<Meets> resultsList;
  List<MeetsLive> fixturesList;
  List<String> resultDescriptions;

  Tournament tournamentDetails;
  int tournamentId;
  bool tournamentSelected;


  _MeetsHomeScreenState({Key key, this.tournamentId});


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
      List<MeetsLive> liveG = await getMeetsLive(1);
      List<Meets> resultG = await getMeets(2);
      List<MeetsLive> fixtureG = await getMeetsLive(0);

      liveList = liveG.reversed.toList();
      resultsList = resultG.reversed.toList();

      fixturesList = fixtureG;

    }else{

      tournamentDetails = await getTournamentById(tournamentId);

      List<MeetsLive> liveG = await getMeetsLiveByTournamentId(1, tournamentId);
      List<Meets> resultG = await getMeetsByTournamentId(2, tournamentId);
      List<MeetsLive> fixtureG = await getMeetsLiveByTournamentId(0, tournamentId);

      liveList = liveG.reversed.toList();
      resultsList = resultG.reversed.toList();
      fixturesList = fixtureG;


    }

    if(liveList.length==0){

      if(fixturesList.length!=0){
        live = false;
        fixtures = true;
        results = false;
      }else{
        live = false;
        fixtures = false;
        results = true;
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

  int selectedIndex = 1;
  Color eventsBg = Colors.black54;
  Color scoresBg = Colors.black54;

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new ScoresHomeScreen()),
        );
      } else if (selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new LiveHomeScreen()),
        );
      }else if (selectedIndex == 3) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new MediaHomeScreen()),
        );
      }else if (selectedIndex == 4) {
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

  String formatDate(String unixDate){

    var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate)*1000);
    date = date.toLocal();
    String formattedDate = DateFormat('hh:mm a, EEEE dd MMMM yyyy').format(date);
    return formattedDate;

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
                  child:liveList.isEmpty?
                  Text("There are no Live Meet Events right now. \n\nCome back and check later...", textAlign: TextAlign.left,):
                  ListView.builder(
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
                                        vertical: 12, horizontal: 4),
                                  ),
                                  Text(
                                    liveList[index].description +
                                        " - " +
                                        formatDate(liveList[index].startTime),
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 6),
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
                icon: Icon(Icons.directions_run), title: Text('MEETS')),
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
                  child: fixturesList.isEmpty?
                  Text("There are no Meet Event Fixtures right now. \n\nCome back and check later...", textAlign: TextAlign.left,):
                  ListView.builder(
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
                                          child: Image.network(
                                            fixturesList[index].tournament.logo,
                                            width: 40,
                                            height: 40,
                                          )
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                  ),
                                  Text(
                                    fixturesList[index].description,
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 6),
                                  ),

                                  Text(
                                    formatDate(fixturesList[index].startTime),
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                    ),
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
                icon: Icon(Icons.directions_run), title: Text('MEETS')),
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
                  child: resultsList.isEmpty?
                  Text("There are no Meets Event Results right now. \n\nCome back and check later...", textAlign: TextAlign.left,):
                  ListView.builder(
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
                                    resultsList[index].description +
                                        " - " +
                                        formatDate(resultsList[index].startTime),
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
                                          resultsList[index].p1Team.team.logo,
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
                                        flex: 14,
                                        child: Text(
                                          resultsList[index].p1name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 15,
                                        child: Text(
                                          resultsList[index].p1result,
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: resultsList[index].p1record?Text(
                                          "R",
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ):Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
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
                                          resultsList[index].p2Team.team.logo,
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
                                        flex: 14,
                                        child: Text(
                                          resultsList[index].p2name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 15,
                                        child: Text(
                                          resultsList[index].p2result,
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: resultsList[index].p2record?Text(
                                          "R",
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ):Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
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
                                          resultsList[index].p3Team.team.logo,
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
                                        flex: 14,
                                        child: Text(
                                          resultsList[index].p3name,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 15,
                                        child: Text(
                                          resultsList[index].p3result,
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: resultsList[index].p3record?Text(
                                          "R",
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto'),
                                        ):Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
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
                                            openStream(resultsList[index].resultUrl);
                                          },
                                          textColor: Colors.white,
                                          color: Color.fromARGB(
                                              255, 20, 136, 204),
                                          elevation: 0,
                                          child: Text("View Full Results"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10)
                                          ),
                                        ),
                                      )
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
                icon: Icon(Icons.directions_run), title: Text('MEETS')),
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