class Tournament{

  int id;
  String name;
  int sportId;
  String url;
  String logo;
  String location;
  String startDate;
  String endDate;
  bool standingsActive;
  bool scoresActive;
  bool poolsActive;
  int poolQuantity;
  bool active;

  Tournament({
    this.id, 
    this.name, 
    this.sportId, 
    this.url, 
    this.logo,
    this.location, 
    this.startDate, 
    this.endDate, 
    this.standingsActive,
    this.scoresActive, 
    this.poolsActive, 
    this.poolQuantity, 
    this.active
  });


  factory Tournament.fromJson(Map<String, dynamic> json){
    return new Tournament(
      id:json['id'],
      name:json['name'],
      sportId:json['sportId'],
      url:json['url'],
      logo:json['logo'],
      location:json['location'],
      startDate:json['startDate'],
      endDate:json['endDate'],
      standingsActive:json['standingsActive'],
      scoresActive:json['scoresActive'],
      poolsActive:json['poolsActive'],
      poolQuantity:json['poolQuantity'],
      active:json['active'],

    );
  }



}