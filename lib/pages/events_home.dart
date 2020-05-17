import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saisa_live_app/pages/live_home.dart';
import 'package:saisa_live_app/pages/scores_home.dart';
import 'package:saisa_live_app/pages/media_home.dart';
import 'package:saisa_live_app/helpers/api.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:saisa_live_app/pages/standings.dart';
import 'package:intl/intl.dart';

import 'meets_home.dart';


class EventsHomeScreen extends StatefulWidget {

  @override
  _EventsHomeScreenState createState() => new _EventsHomeScreenState();

}

class _EventsHomeScreenState extends State<EventsHomeScreen> {

  List<Tournament> liveTournaments;
  List<Tournament> archivedTournaments;

  bool live;

  @override
  initState() {
    super.initState();
    live = true;
    liveTournaments = new List();
    archivedTournaments = new List();

    getData();
  }

  void changeType() {
    if (live) {
      live = false;
    } else {
      live = true;
    }

    setState(() {

    });
  }

  getData() async {
    List<Tournament> liveT = await getTournaments(true);
    List<Tournament> archiveT = await getTournaments(false);

    liveTournaments = liveT.reversed.toList();
    archivedTournaments = archiveT.reversed.toList();

    if(liveTournaments.length==0){
      live=false;
    }

    setState(() {});
  }


  int selectedIndex = 4;
  Color eventsBg = Color.fromARGB(255, 20, 136, 204);
  Color scoresBg = Colors.black54;

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;


      if (selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new LiveHomeScreen()),
        );
      } else if (selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new ScoresHomeScreen()),
        );
      } else if (selectedIndex == 3) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new MediaHomeScreen()),
        );
      }else if (selectedIndex==1){

        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new MeetsHomeScreen()),
        );

      }
    });
  }

  String formatDate(String unixDate){

    var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate)*1000);
    date = date.toLocal();
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(date);
    return formattedDate;

  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: PreferredSize(
          child: new AppBar(
            elevation: 0,
            title: new Text(
              'SAISA Live',
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
          preferredSize: Size.fromHeight(55)
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                      child: Text("LIVE NOW",
                          textAlign: TextAlign.center,
                          style: live ? TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline) : TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,)),
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: changeType,
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      textColor: Colors.white,
                      child: Text("ARCHIVES",
                          textAlign: TextAlign.center,
                          style: !live ? TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline) : TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,)),
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: changeType,
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          (live?liveTournaments.isNotEmpty:archivedTournaments.isNotEmpty)?Expanded(
            flex: 15,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: live?liveTournaments.length:archivedTournaments.length,
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
                                  vertical: 15, horizontal: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    live?liveTournaments[index].name:archivedTournaments[index].name,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Roboto'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Image.network(
                                          live?liveTournaments[index].logo:archivedTournaments[index].logo,
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              live?formatDate(liveTournaments[index].startDate):formatDate(archivedTournaments[index].startDate),
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto'),
                                            ),
                                            Text(
                                              live?liveTournaments[index].location:archivedTournaments[index].location,
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto'),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                  ),
                                  Row(
                                    children: <Widget>[
                                        (live?liveTournaments[index].standingsActive:archivedTournaments[index].standingsActive)?
                                        Expanded(
                                        flex: 15,
                                          child: ButtonTheme(
                                            minWidth: double.infinity,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (ctxt) =>
                                                      new StandingsScreen(
                                                        tournamentId: live?liveTournaments[index].id:archivedTournaments[index].id,)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              color: Color.fromARGB(
                                                  255, 20, 136, 204),
                                              elevation: 0,
                                              child: Text("STANDINGS", style: TextStyle(fontSize: 10),),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(10)
                                              ),
                                            ),
                                          )
                                      ):Padding(
                                        padding: EdgeInsets.all(0),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      (live?liveTournaments[index].scoresActive:archivedTournaments[index].scoresActive)?
                                      Expanded(
                                          flex: 15,
                                          child: ButtonTheme(
                                            minWidth: double.infinity,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (ctxt) =>
                                                      new ScoresHomeScreen(
                                                        tournamentId: live?liveTournaments[index].id:archivedTournaments[index].id,)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              color: Color.fromARGB(
                                                  255, 20, 136, 204),
                                              elevation: 0,
                                              child: Text("SCORES", style: TextStyle(fontSize: 10),),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(10)
                                              ),
                                            ),
                                          )
                                      ):Padding(padding: EdgeInsets.all(0),),
                                      (live?liveTournaments[index].scoresActive&&liveTournaments[index].meetsActive:archivedTournaments[index].scoresActive&&archivedTournaments[index].meetsActive)?
                                      Expanded(
                                        flex: 1,
                                        child: Padding(padding: EdgeInsets.all(0)),
                                      ):Padding(padding: EdgeInsets.all(0),),
                                      (live?liveTournaments[index].meetsActive:archivedTournaments[index].meetsActive)?
                                      Expanded(
                                          flex: 15,
                                          child: ButtonTheme(
                                            minWidth: double.infinity,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (ctxt) =>
                                                      new MeetsHomeScreen(
                                                        tournamentId: live?liveTournaments[index].id:archivedTournaments[index].id,)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              color: Color.fromARGB(
                                                  255, 20, 136, 204),
                                              elevation: 0,
                                              child: Text("MEET RESULTS", style: TextStyle(fontSize: 10),),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(10)
                                              ),
                                            ),
                                          )
                                      ):Padding(padding: EdgeInsets.all(0),),

                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 15,
                                          child: ButtonTheme(
                                            minWidth: double.infinity,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (ctxt) =>
                                                      new LiveHomeScreen(
                                                        tournamentId: live?liveTournaments[index].id:archivedTournaments[index].id,)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              color: Color.fromARGB(
                                                  255, 20, 136, 204),
                                              elevation: 0,
                                              child: Text("LIVESTREAMS", style: TextStyle(fontSize: 10),),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(10)
                                              ),
                                            ),
                                          )
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(padding: EdgeInsets.all(0)),
                                      ),
                                      Expanded(
                                          flex: 15,
                                          child: ButtonTheme(
                                            minWidth: double.infinity,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (ctxt) =>
                                                      new MediaHomeScreen(
                                                        tournamentId: live?liveTournaments[index].id:archivedTournaments[index].id,)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              color: Color.fromARGB(
                                                  255, 20, 136, 204),
                                              elevation: 0,
                                              child: Text("MEDIA", style: TextStyle(fontSize: 10),),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(10)
                                              ),
                                            ),
                                          )
                                      ),

                                    ],
                                  )
                                ],
                              )
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ),
          )
              :Expanded(
            flex: 15,
            child: Padding(padding: EdgeInsets.all(20),
              child: Text("There are no Live Events right now. \n\nCome back and check later...", textAlign: TextAlign.left,),),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: new Image.asset(
                "images/scores.png", width: 24, height: 24, color: scoresBg,),
              title: Text('SCORES')),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run), title: Text('MEETS')),
          BottomNavigationBarItem(
              icon: Icon(Icons.live_tv), title: Text('LIVE')),

          BottomNavigationBarItem(
              icon: Icon(Icons.photo_library), title: Text('MEDIA')),
          BottomNavigationBarItem(
              icon: new Image.asset(
                "images/trophy.png", width: 24, height: 24, color: eventsBg,),
              title: Text('EVENTS')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Color.fromARGB(255, 20, 136, 204),
        onTap: onNavigationItemTapped,
      ),
    );
  }

}