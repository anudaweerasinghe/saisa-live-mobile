import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saisa_live_app/pages/live_home.dart';
import 'package:saisa_live_app/pages/scores_home.dart';
import 'package:saisa_live_app/pages/home.dart';

import 'package:saisa_live_app/helpers/api.dart';
import 'package:async/async.dart';
import 'package:saisa_live_app/models/media_model.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:saisa_live_app/pages/news_detail.dart';


class MediaHomeScreen extends StatefulWidget {
  @override
  _MediaHomeScreenState createState() => new _MediaHomeScreenState();
}

class _MediaHomeScreenState extends State<MediaHomeScreen> {
  List<Media> photosList;
  List<Media> videosList;
  List<Media> newsList;

  bool photos;
  bool videos;
  bool news;

  @override
  initState() {
    super.initState();

    photos = true;
    videos = false;
    news = false;

    photosList = new List();
    videosList = new List();
    newsList = new List();

    getData();
  }

  int selectedIndex = 3;
  Color eventsBg = Colors.black54;
  Color scoresBg = Colors.black54;

  getData() async {
    List<Media> photosL = await getMedia(1);
    List<Media> videosL = await getMedia(2);
    List<Media> newsL = await getMedia(3);

    photosList = photosL.reversed.toList();
    videosList = videosL.reversed.toList();
    newsList = newsL.reversed.toList();

    print("Hello");

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

      if (selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new LiveHomeScreen()),
        );
      } else if (selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new ScoresHomeScreen()),
        );
      } else if (selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
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

  @override
  Widget build(BuildContext context) {
    if(photos) {
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
        body: Center(
            child: Column(
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
                    child: ListView.builder(
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
                                            vertical: 3, horizontal: 8),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('HOME')),
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
        body: Center(
            child: Column(
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
                    child: ListView.builder(
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
                                            vertical: 3, horizontal: 8),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('HOME')),
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
        body: Center(
            child: Column(
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
                    child: ListView.builder(
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
                                            vertical: 3, horizontal: 8),
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
                                                        coverImg: newsList[index].coverImg, title: newsList[index].title, text: newsList[index].text,)),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('HOME')),
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
