import 'dart:convert';
import 'package:flutter/services.dart';

import '../../data/env/env.dart';
import 'package:http/http.dart' as http;

import '../responses/category_response.dart';
import '../responses/serie_response.dart';

class SerieServices {
  // static String decryptedData = "";

  Future<ResponseSeriesByCategoryInfo> getAllSeries() async {
    String jsonString = await rootBundle.loadString('assets/json/series.json');


    print("getSeries (from getAllSeries) = $jsonString");

    return ResponseSeriesByCategoryInfo.fromJson(jsonDecode(jsonString));
  }


  Future<ResponseSeasonBySerie> getAllSeasons() async {

    String jsonString = await rootBundle.loadString('assets/json/seasons.json');


    print("getSeries (from getAllSeries) = $jsonString");
    return ResponseSeasonBySerie.fromJson(jsonDecode(jsonString));
  }

  Future<ResponseEpisodeBySerieAndSeason> getAllEpisodes() async {
    String jsonString = await rootBundle.loadString('assets/json/episodes.json');


    print("getSeries (from getAllSeries) = $jsonString");
    return ResponseEpisodeBySerieAndSeason.fromJson(jsonDecode(jsonString));
  }

}

final serieService = SerieServices();
