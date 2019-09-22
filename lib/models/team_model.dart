class Team {
  int id;
  String name;
  String fullName;
  String logo;
  String mascot;
  String webUrl;
  bool active;

  Team({this.id, this.name, this.fullName, this.logo, this.mascot, this.webUrl,
    this.active});


  factory Team.fromJson(Map<String, dynamic> json){
    return new Team(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      fullName: json['fullName'],
      mascot: json['mascot'],
      webUrl: json['webUrl'],
      active: json['active'],
    );
  }
}