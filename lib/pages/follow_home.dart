import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saisa_live_app/pages/scores_home.dart';
import 'package:saisa_live_app/models/team_model.dart';
import 'package:saisa_live_app/helpers/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


class FollowScreen extends StatefulWidget {
  @override
  _FollowScreenState createState() => new _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      new Color.fromARGB(255, 20, 136, 204),
      new Color.fromARGB(255, 43, 51, 178)
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  List<Team> teamsList;
  List<bool> clickList;

  int userId;
  SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    teamsList = new List();
    clickList = new List();
    checkLogInStatus();



  }

  checkLogInStatus()async{

    prefs = await SharedPreferences.getInstance();
    if(prefs.get('userId')!=null){
      print(prefs.get('userId'));
//      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (ctxt) => new ScoresHomeScreen()),
      );
    }else{
      for(int i=0; i<11;i++) {
        clickList.add(false);
      }
      getData();


      registerTheUser("iOS3");
    }

  }

  getData() async {
    teamsList = await getAllTeams();

    setState(() {

    });
  }

  registerTheUser(String deviceName) async{





    OneSignal.shared.init(
        "604461e0-965b-4e8a-b0fe-d1bf13f39dd9",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        }
    );

//    var status = await OneSignal.shared.getPermissionSubscriptionState();
//
//    deviceName =status.subscriptionStatus.userId;

    userId = await registerUser(deviceName);

    OneSignal.shared.setExternalUserId(userId.toString());
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

  }

  teamSelect(int index){


    setState(() {

      if(clickList[index]){
        clickList[index]=false;
      }else{
        clickList[index]=true;
      }
    });
  }

  saveAndContinue() async{

    List<int> followingList = new List();

    for(int i=0; i<clickList.length;i++){

      if(clickList[i]){
        int teamId = teamsList[i].id;
        followingList.add(teamId);
      }

    }


    bool success = false;

    if(followingList.isNotEmpty){
      success = await followTeams(followingList, userId);
      print(success);
    }

    if(success){
      prefs.setInt("userId", userId);
    }
//    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (ctxt) => new ScoresHomeScreen()),
    );

  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      margin: new EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: teamsList.isEmpty?Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Text('Welcome',
                      style: new TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Roboto')),
                  Text(
                    'Select Your Favorite Teams',
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.normal,
                        foreground: Paint()..shader = linearGradient),
                  ),
                ]),
          ),
          Expanded(
            flex: 36,
            child: Padding(padding: EdgeInsets.all(0)),
          ),
          Expanded(
            flex: 3,
            child: new FractionallySizedBox(
              widthFactor: 1,
              child: RaisedButton(
                onPressed: () {},
                textColor: Colors.white,
                color: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0),
                      bottomLeft: const Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromARGB(255, 20, 136, 204),
                        Color.fromARGB(255, 43, 51, 178)
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Continue',
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(padding: EdgeInsets.all(0)),
          ),
        ],
      ):Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 14,
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Text('Welcome',
                      style: new TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Roboto')),
                  Text(
                    'Select Your Favorite Teams',
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                        foreground: Paint()..shader = linearGradient),
                  ),
                ]),
          ),
          Expanded(
            flex: 1,
            child: Padding(padding: EdgeInsets.all(0)),
          ),
          Expanded(
            flex: 15,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    onTap: (){
                      teamSelect(0);
                    },
                    child:Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[0].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[0]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[0].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )

                        ],
                      ),
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    onTap: (){
                      teamSelect(1);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[1].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[1]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[1].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    onTap: (){
                      teamSelect(2);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[2].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[2]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[2].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(padding: EdgeInsets.all(0)),
          ),
          Expanded(
            flex: 15,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    onTap: (){
                      teamSelect(3);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[3].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[3]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[3].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    onTap: (){
                      teamSelect(4);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[4].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[4]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[4].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    onTap: (){
                      teamSelect(5);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[5].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[5]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[5].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(padding: EdgeInsets.all(0)),
          ),
          Expanded(
            flex: 15,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    onTap: (){
                      teamSelect(6);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[6].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[6]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[6].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),

                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[7].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[7]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[7].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      teamSelect(7);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
                Expanded(
                  flex: 6,
                  child: new GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[8].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[8]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[8].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      teamSelect(8);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(padding: EdgeInsets.all(0)),
          ),
          Expanded(
            flex: 15,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
                Expanded(
                  flex: 12,
                  child: new GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[9].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[9]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[9].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      teamSelect(9);
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
                Expanded(
                  flex: 12,
                  child: new GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Image.network(
                                  teamsList[10].logo,
                                  height: double.infinity,
                                ),
                              )
                          ),

                          Expanded(
                              flex: 1,
                              child: Container(
                                  decoration: clickList[10]?
                                  new BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromARGB(255, 20, 136, 204),
                                        Color.fromARGB(255, 43, 51, 178)
                                      ],
                                    ),
                                  ):
                                  new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                    child: Text(
                                      teamsList[10].name,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                    onTap:(){
                      teamSelect(10);
                    } ,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(padding: EdgeInsets.all(0)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(padding: EdgeInsets.all(0)),
          ),
          Expanded(
            flex: 7,
            child: new FractionallySizedBox(
              widthFactor: 1,
              child: RaisedButton(
                onPressed: () {
                  saveAndContinue();
                },
                textColor: Colors.white,
                color: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.all(0.0),
                child: Container(
//                  height: double.infinity,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0),
                      bottomLeft: const Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromARGB(255, 20, 136, 204),
                        Color.fromARGB(255, 43, 51, 178)
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Continue',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
//          Expanded(
//            flex: 1,
//            child: Padding(padding: EdgeInsets.all(0)),
//          ),
        ],
      ),
    ));
  }
}
