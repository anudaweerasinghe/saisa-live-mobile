class LivestreamEntity{


  int id;
  int tournamentId;
  String url;
  String description;
  bool live;
  bool active;

  LivestreamEntity({
    this.id,
    this.tournamentId,
    this.url,
    this.description,
    this.live,
    this.active
  });

  factory LivestreamEntity.fromJson(Map<String, dynamic> json){
    return new LivestreamEntity(
        tournamentId: json['tournamentId'],
        id: json['id'],
        url: json['url'],
        description: json['description'],
        live: json['live'],
        active: json['active']

    );
  }

}