class Media{

  int id;
  int tournamentId;
  int type;
  String coverImg;
  String contentUrl;
  String title;
  String timestamp;
  String text;
  bool active;

  Media({this.id, this.tournamentId, this.type, this.coverImg, this.contentUrl,
      this.title, this.timestamp, this.text, this.active});


  factory Media.fromJson(Map<String, dynamic> json){
    return new Media(
      id: json['id'],
      tournamentId: json['tournamentId'],
      type: json['type'],
      coverImg: json['coverImg'],
      contentUrl: json['contentUrl'],
      title: json['title'],
      timestamp: json['timestamp'],
      text: json['text'],
      active: json['active'],
    );
  }


}