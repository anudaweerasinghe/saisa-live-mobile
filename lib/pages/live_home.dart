import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saisa_live_app/pages/home.dart';
import 'dart:async';
import 'package:saisa_live_app/helpers/api.dart';

import 'package:saisa_live_app/models/livestream_model.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:saisa_live_app/pages/scores_home.dart';

class LiveHomeScreen extends StatefulWidget {
  @override
  _LiveHomeScreenState createState() => new _LiveHomeScreenState();
}

class _LiveHomeScreenState extends State<LiveHomeScreen> {
  List<Livestream> liveStreamList;
  List<Livestream> pastFootageList;

  bool live;

  @override
  initState() {
    super.initState();

    liveStreamList = new List();
    pastFootageList = new List();

    live=true;

    getData();
  }

  int selectedIndex = 1;
  Color eventsBg = Colors.black54;
  Color scoresBg = Colors.black54;


  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
        );
      }else if(selectedIndex == 0){
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new ScoresHomeScreen()),
        );
      }
    });
  }

  getData() async {
    List<Livestream> liveL = await getAllLivestreams(true);
    List<Livestream> pastL = await getAllLivestreams(false);

    liveStreamList = liveL.reversed.toList();
    pastFootageList = pastL.reversed.toList();

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
          preferredSize: Size.fromHeight(55)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
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
          Expanded(
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
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('HOME')),
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