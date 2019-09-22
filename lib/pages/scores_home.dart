import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saisa_live_app/pages/home.dart';
import 'package:saisa_live_app/pages/live_home.dart';

class ScoresHomeScreen extends StatefulWidget {
  @override
  _ScoresHomeScreenState createState() => new _ScoresHomeScreenState();
}

class _ScoresHomeScreenState extends State<ScoresHomeScreen> {

  bool live;
  bool fixtures;
  bool results;

  @override
  initState() {
    super.initState();

    live = true;
    fixtures = false;
    results = false;
  }

  int selectedIndex = 0;
  Color eventsBg = Colors.black54;
  Color scoresBg = Color.fromARGB(255, 20, 136, 204);

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
        );
      } else if (selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new LiveHomeScreen()),
        );
      }
    });
  }

  void changeType(int newSelection){
    if(newSelection == 1){
      live = true;
      fixtures = false;
      results = false;
    }else if(newSelection ==2){
      fixtures = true;
      live = false;
      results = false;
    }else{
      results = true;
      fixtures = false;
      live = false;
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
                        child: Text("LIVE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration: live?TextDecoration.underline:null)
                                ),
                        color: Colors.transparent,
                        elevation: 0,
                        onPressed: (){
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
                                decoration: fixtures?TextDecoration.underline:null)
                                ),
                        color: Colors.transparent,
                        elevation: 0,
                        onPressed: (){
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
                                decoration: results?TextDecoration.underline:null)
                        ),
                        color: Colors.transparent,
                        elevation: 0,
                        onPressed: (){
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
              child: Text("text"),
            ),
          ]),
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
