import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsDetailScreen extends StatefulWidget {

  final String title;
  final String text;
  final String coverImg;
  final String timestamp;

  NewsDetailScreen(
      {Key key, @required this.title, @required this.text, @required this.coverImg, @required this.timestamp})
      : super(key: key);

  @override
  _NewsDetailScreenState createState() => new _NewsDetailScreenState(title: title, text: text, coverImg:coverImg, timestamp:timestamp);
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {

  String title;
  String text;
  String coverImg;
  String timestamp;


  _NewsDetailScreenState({Key key, @required this.title, @required this.text, @required this.coverImg, @required this.timestamp});

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          child: new AppBar(
            elevation: 0,
            title: new Text(
              'SAISA Live News',
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
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
            child: Text(title,
                textAlign: TextAlign.left,
                style: new TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto')),
          ),
          new Image.network(
            coverImg,
            color: Color.fromRGBO(
                255, 255, 255, 0.85),
            colorBlendMode: BlendMode.modulate,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Text("Published at "+timestamp,
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w200,
                fontFamily: 'Roboto',
                fontStyle: FontStyle.italic
              ),),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10, left: 15, right: 15),
            child: Text(text,
                textAlign: TextAlign.left,
                style: new TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto')),
          ),
        ],
      ),
    );
  }

}