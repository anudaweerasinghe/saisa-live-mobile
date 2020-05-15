import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saisa_live_app/pages/live_home.dart';
import 'package:saisa_live_app/pages/scores_home.dart';
import 'package:saisa_live_app/pages/events_home.dart';


import 'package:saisa_live_app/helpers/api.dart';
import 'package:async/async.dart';
import 'package:saisa_live_app/models/media_model.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:saisa_live_app/pages/news_detail.dart';
import 'package:saisa_live_app/models/tournament_model.dart';
import 'package:intl/intl.dart';
import 'meets_home.dart';


class MediaHomeScreen extends StatefulWidget {
  final int tournamentId;

  MediaHomeScreen(
      {Key key, this.tournamentId})
      : super(key: key);

  @override
  _MediaHomeScreenState createState() => new _MediaHomeScreenState(tournamentId: tournamentId);
}

class _MediaHomeScreenState extends State<MediaHomeScreen> {
  List<Media> photosList;
  List<Media> videosList;
  List<Media> newsList;
  TextEditingController accessCodeController = new TextEditingController();


  bool photos;
  bool videos;
  bool news;

  Tournament tournamentDetails;
  int tournamentId;
  bool tournamentSelected;

  bool accessGranted;

  _MediaHomeScreenState({Key key, this.tournamentId});

  @override
  initState() {
    super.initState();

    photos = true;
    videos = false;
    news = false;
    accessGranted=false;

    photosList = new List();
    videosList = new List();
    newsList = new List();

    tournamentDetails = new Tournament();
    tournamentDetails.name = "";

    if(tournamentId==null){
      tournamentSelected = false;
    }else{
      tournamentSelected = true;
    }

    getData();
  }

  int selectedIndex = 3;
  Color eventsBg = Colors.black54;
  Color scoresBg = Colors.black54;

  getData() async {

    if(tournamentSelected==false) {
      List<Media> videosL = await getMedia(2,0);
      List<Media> newsL = await getMedia(3,0);


      videosList = videosL.reversed.toList();
      newsList = newsL.reversed.toList();
    }else{

      tournamentDetails = await getTournamentById(tournamentId);

      List<Media> videosL = await getMedia(2,tournamentId);
      List<Media> newsL = await getMedia(3,tournamentId);


      videosList = videosL.reversed.toList();
      newsList = newsL.reversed.toList();

    }


    setState(() {});
  }

  getPhotosData() async {

    if(tournamentSelected==false) {
      List<Media> photosL = await getPhotos(0, accessCodeController.text);
      if(photosL!=null) {
        accessGranted = true;
        photosList = photosL.reversed.toList();
      }else{
        _showDialog("Incorrect Access Code! Please try again");
      }
    }else{

      tournamentDetails = await getTournamentById(tournamentId);

      List<Media> photosL = await getPhotos(tournamentId, accessCodeController.text);
      if(photosL!=null) {
        accessGranted = true;
        photosList = photosL.reversed.toList();
      }else{
        _showDialog("Incorrect Access Code! Please try again");
      }
    }


    setState(() {});
  }

  openContent(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
      } else if (selectedIndex==1){

        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new MeetsHomeScreen()),
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
      photos = true;
      videos = false;
      news = false;
    } else if (newSelection == 2) {
      videos = true;
      photos = false;
      news = false;
    } else {
      news = true;
      photos = false;
      videos = false;
    }

    setState(() {});
  }
  void _showDialog(String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new TextField(
            controller: accessCodeController,
            decoration: InputDecoration(
              hintText: "Enter Access Code",

            ),

          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                  "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("View Photos", style: new TextStyle(color: Color.fromARGB(
                  255, 20, 136, 204)),),
              onPressed: () {
                getPhotosData();
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  String formatDate(String unixDate){

    var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate)*1000);
    date = date.toLocal();
    String formattedDate = DateFormat('hh:mm a, EEEE dd MMMM yyyy').format(date);
    return formattedDate;

  }
  
  @override
  Widget build(BuildContext context) {
    if(photos) {
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
        body: Center(
            child: Column(
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
                            child: Text("PHOTOS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    photos ? TextDecoration.underline : null)),
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
                            child: Text("VIDEOS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    videos ? TextDecoration.underline : null)),
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
                            child: Text("NEWS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    news ? TextDecoration.underline : null)),
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
                    child: !accessGranted?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("For privacy reasons, you need an access code to gain access to Photos from SAISA Events.\n\nContact your team's Athletics Director to get an access code.\n\n\n", textAlign: TextAlign.left,),

                        Center(
                            child: ButtonTheme(
                              minWidth: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  _showDialog("Gain Access to Photos");
                                },
                                textColor: Colors.white,
                                color: Colors.redAccent,
                                elevation: 5,
                                child: Text("I Have an Access Code", style: new TextStyle(fontSize: 18),),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .circular(10)
                                ),
                              ),
                            )
                        ),
                      ],
                    ):photosList.isEmpty?Text("There are no Photo right now. \n\nCome back and check later...", textAlign: TextAlign.left,):
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: photosList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                              ),
                              Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(photosList[index].title,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto')),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                      ),
                                      Text(
                                        formatDate(photosList[index].timestamp),
                                        style: new TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                      ),
                                      new Image.network(
                                        photosList[index].coverImg,
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.85),
                                        colorBlendMode: BlendMode.modulate,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 8),
                                      ),
                                      Center(
                                          child: ButtonTheme(
                                            minWidth: double.infinity,
                                            child: RaisedButton(
                                              onPressed: () {
                                                openContent(photosList[index]
                                                    .contentUrl);
                                              },
                                              textColor: Colors.white,
                                              color: Color.fromARGB(
                                                  255, 20, 136, 204),
                                              elevation: 0,
                                              child: Text("View Photos"),
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
                        }),
                  ),
                )
              ],
            )),
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
    }else if(videos){
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
        body: Center(
            child: Column(
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
                            child: Text("PHOTOS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    photos ? TextDecoration.underline : null)),
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
                            child: Text("VIDEOS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    videos ? TextDecoration.underline : null)),
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
                            child: Text("NEWS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    news ? TextDecoration.underline : null)),
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
                    child: videosList.isEmpty?
                    Text("There are no Videos right now. \n\nCome back and check later...", textAlign: TextAlign.left,):
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: videosList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                              ),
                              Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(videosList[index].title,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto')),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                      ),
                                      Text(
                                        formatDate(videosList[index].timestamp),
                                        style: new TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                      ),
                                      new Image.network(
                                        videosList[index].coverImg,
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.85),
                                        colorBlendMode: BlendMode.modulate,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 8),
                                      ),
                                      Center(
                                          child: ButtonTheme(
                                            minWidth: double.infinity,
                                            child: RaisedButton(
                                              onPressed: () {
                                                openContent(videosList[index]
                                                    .contentUrl);
                                              },
                                              textColor: Colors.white,
                                              color: Color.fromARGB(
                                                  255, 20, 136, 204),
                                              elevation: 0,
                                              child: Text("Watch Video"),
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
                        }),
                  ),
                )
              ],
            )),
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
    }else if(news){
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
        body: Center(
            child: Column(
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
                            child: Text("PHOTOS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    photos ? TextDecoration.underline : null)),
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
                            child: Text("VIDEOS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    videos ? TextDecoration.underline : null)),
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
                            child: Text("NEWS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration:
                                    news ? TextDecoration.underline : null)),
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
                    child: newsList.isEmpty?
                    Text("There are no News items right now. \n\nCome back and check later...", textAlign: TextAlign.left,):
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                              ),
                              Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(newsList[index].title,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Roboto')),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                      ),
                                      Text(
                                        formatDate(newsList[index].timestamp),
                                        style: new TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                      ),
                                      new Image.network(
                                        newsList[index].coverImg,
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.85),
                                        colorBlendMode: BlendMode.modulate,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 8),
                                      ),
                                      Center(
                                          child: ButtonTheme(
                                            minWidth: double.infinity,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (ctxt) =>
                                                      new NewsDetailScreen(
                                                        coverImg: newsList[index].coverImg, title: newsList[index].title, text: newsList[index].text,timestamp: formatDate(newsList[index].timestamp),)),
                                                );
                                              },
                                              textColor: Colors.white,
                                              color: Color.fromARGB(
                                                  255, 20, 136, 204),
                                              elevation: 0,
                                              child: Text("Read News"),
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
                        }),
                  ),
                )
              ],
            )),
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
}
