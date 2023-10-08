class ResponseSeriesByCategoryInfo {
  List<SerieByCategoryInfosModel> listSeriesInfos;

  ResponseSeriesByCategoryInfo({required this.listSeriesInfos});

  factory ResponseSeriesByCategoryInfo.fromJson(List<dynamic> json) {
    return ResponseSeriesByCategoryInfo(
      listSeriesInfos: List<SerieByCategoryInfosModel>.from(
          json.map((x) => SerieByCategoryInfosModel.fromJson(x))),
    );
  }
}

class SerieByCategoryInfosModel {
  dynamic id;
  String? name;
  String? icon;
  String? plot;
  String? cast;
  String? director;
  String? genre;
  String? date;
  String categoryId;
  double? rate;
  bool isFavorite;

  SerieByCategoryInfosModel({
    required this.id,
    required this.name,
    this.icon,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.date,
    this.rate,
    required this.categoryId,
    this.isFavorite = false,
  });

  factory SerieByCategoryInfosModel.fromJson(Map<String, dynamic> json) {
    print("SerieByCategoryInfosModel = $json");
    return SerieByCategoryInfosModel(
      id: json['id']??"",
      name: json['name']??"",
      icon: json['icon']??"",
      date: json['date']??"",
      genre: json['genre']??"",
      cast: json['cast']??"",
      plot: json['plot']??"",
      director: json['director']??"",
      categoryId: json['category_id']??"",
      rate: json['rate']??1.0,
    );
  }
}


class SerieByIdInfoModel {
  dynamic id;
  String? name;
  String? icon;
  String? plot;
  String? cast;
  String? director;
  String? genre;
  String? date;
  double? rate;
  bool isFavorite;

  SerieByIdInfoModel({
    required this.id,
    required this.name,
    this.icon,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.date,
    this.rate,
    this.isFavorite = false,
  });


  factory SerieByIdInfoModel.fromJson(Map<String, dynamic> json) {
    // print("SerieByCategoryInfosModel = $json");
    return SerieByIdInfoModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      date: json['date'],
      genre: json['genre'],
      cast: json['cast'],
      plot: json['plot'],
      director: json['director'],
      rate: json['rate'],
    );
  }
}



  // Saison
 // **************************

class ResponseSaisonBySerie {
  List<SeasonModel> listSaisons;

  ResponseSaisonBySerie({required this.listSaisons});

  factory ResponseSaisonBySerie.fromJson(List<dynamic> json) {
    return ResponseSaisonBySerie(
      listSaisons: List<SeasonModel>.from(
          json.map((x) => SeasonModel.fromJson(x))),
    );
  }
}

class SeasonModel {
  String season;

  SeasonModel({
    required this.season,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      season: json['saison'],
    );
  }
}


// Episode
// ***********************************************

class ResponseEpisodeBySerieAndSeason {
  List<EpisodeModel> listEpisode;

  ResponseEpisodeBySerieAndSeason({required this.listEpisode});

  factory ResponseEpisodeBySerieAndSeason.fromJson(List<dynamic> json) {
    return ResponseEpisodeBySerieAndSeason(
      listEpisode: List<EpisodeModel>.from(
          json.map((x) => EpisodeModel.fromJson(x))),
    );
  }
}

class EpisodeModel {
  dynamic id;
  String name;
  String? icon;
  String? url;
  String episode;

  EpisodeModel({
    required this.id,
    required this.name,
    this.icon,
    this.url,
    required this.episode,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      url: json['url'],
      episode: json['episode'],
    );
  }
}
