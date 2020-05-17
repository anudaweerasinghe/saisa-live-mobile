import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:saisa_live_app/helpers/api.dart';
import 'package:saisa_live_app/pages/events_home.dart';


import 'package:saisa_live_app/models/livestream_model.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:saisa_live_app/pages/scores_home.dart';
import 'package:saisa_live_app/pages/media_home.dart';
import 'meets_home.dart';

class LiveHomeScreen extends StatefulWidget {
  final int tournamentId;

  LiveHomeScreen(
      {Key key, this.tournamentId})
      : super(key: key);

  @override
  _LiveHomeScreenState createState() => new _LiveHomeScreenState(tournamentId: tournamentId);
}

class _LiveHomeScreenState extends State<LiveHomeScreen> {
  List<Livestream> liveStreamList;
  List<Livestream> pastFootageList;

  bool live;

  Tournament tournamentDetails;
  int tournamentId;
  bool tournamentSelected;

  _LiveHomeScreenState({Key key, this.tournamentId});

  @override
  initState() {
    super.initState();

    liveStreamList = new List();
    pastFootageList = new List();

    live=true;

    tournamentDetails = new Tournament();
    tournamentDetails.name = "";

    if(tournamentId==null){
      tournamentSelected = false;
    }else{
      tournamentSelected = true;
    }

    getData();
  }

  int selectedIndex = 2;
  Color eventsBg = Colors.black54;

  Color scoresBg = Colors.black54;


  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if(selectedIndex == 0){
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new ScoresHomeScreen()),
        );
      }else if (selectedIndex==1){

        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new MeetsHomeScreen()),
        );

      }else if(selectedIndex == 3){
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

  getData() async {

//    TournamentParticipants tournamentParticipants = await getParticipantsByTournament(1);


    if(tournamentSelected==false) {
      List<Livestream> liveL = await getAllLivestreams(true,0);
      List<Livestream> pastL = await getAllLivestreams(false, 0);

      liveStreamList = liveL.reversed.toList();
      pastFootageList = pastL.reversed.toList();
    }else{

      tournamentDetails = await getTournamentById(tournamentId);

      List<Livestream> liveL = await getAllLivestreams(true,tournamentId);
      List<Livestream> pastL = await getAllLivestreams(false, tournamentId);

      liveStreamList = liveL.reversed.toList();
      pastFootageList = pastL.reversed.toList();


    }

    if(liveStreamList.length==0&&pastFootageList.length!=0){
      live=false;
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

  void changeType() {
    if(live){
      live = false;
    }else{
      live = true;
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Text("LIVESTREAMS",
                          textAlign: TextAlign.center,
                          style: live?TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline):TextStyle(
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
                      child: Text("PAST FOOTAGE",
                          textAlign: TextAlign.center,
                          style: !live?TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline):TextStyle(
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
          (live?liveStreamList.isNotEmpty:pastFootageList.isNotEmpty)?Expanded(
            flex: 15,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: live?ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: liveStreamList.length,
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
                                Text(liveStreamList[index].tournament.name,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Roboto')),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                ),
                                Text(liveStreamList[index].description,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto')),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                ),
                                new Stack(
                                  children: <Widget>[
                                    new Image.network(
                                        'http://i3.ytimg.com/vi/' +
                                            liveStreamList[index]
                                                .url
                                                .substring(17) +
                                            '/maxresdefault.jpg',
                                      color: Color.fromRGBO(255, 255, 255, 0.85),
                                      colorBlendMode: BlendMode.modulate,
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Text("LIVE",
                                          textAlign: TextAlign.right,
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              backgroundColor: Colors.black45,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.red,
                                              fontFamily: 'Roboto')),
                                    ),
                                    Positioned.fill(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.play_circle_filled,
                                            color: Colors.white,size: 50,
                                          ),
                                          onPressed: (){
                                            openStream(liveStreamList[index].url);
                                          },
                                        )
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }):ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: pastFootageList.length,
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
                                Text(pastFootageList[index].tournament.name,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Roboto')),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                ),
                                Text(pastFootageList[index].description,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto')),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                ),
                                new Stack(
                                  children: <Widget>[
                                    new Image.network(
                                      'http://i3.ytimg.com/vi/' +
                                          pastFootageList[index]
                                              .url
                                              .substring(17) +
                                          '/maxresdefault.jpg',
                                      color: Color.fromRGBO(255, 255, 255, 0.85),
                                      colorBlendMode: BlendMode.modulate,
                                    ),
                                    Positioned.fill(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.play_circle_filled,
                                            color: Colors.white,size: 50,
                                          ),
                                          onPressed: (){
                                            openStream(pastFootageList[index].url);
                                          },
                                        )
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ):
          Expanded(
            flex: 15,
            child: Padding(padding: EdgeInsets.all(20),
            child: Text("There are no Live Streams right now. \n\nCome back and check later...", textAlign: TextAlign.left,),),
          )
        ],
      ),
      bottomNavigationBar: tournamentSelected?null:BottomNavigationBar(
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
      ),
    );
  }
}
