import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repositories/new_route_repo.dart';
import '../../../../domain/models/route_screen_model.dart';
import '../../../../domain/responses/category_response.dart';
import '../../../../domain/responses/serie_response.dart';
import '../../../../domain/services/category_services.dart';
import '../../../../domain/services/serie_services.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/constants_manager.dart';

class SeriesHomeViewModel {
  List<SerieByCategoryInfosModel> listInitialOfSeries = [];

  List<String> listYears = [];
  List<String> listGenres = [];
  late List<CategoryModel> navbarList = [];


  final _seriesRouteDataStreamController = BehaviorSubject<RouteScreenModel>();

  ValueStream<RouteScreenModel> get seriesRouteDataStream =>
      _seriesRouteDataStreamController.stream;

  final _selectedFilterIndexController = BehaviorSubject<int>();

  ValueStream<int> get selectedFilterIndex =>
      _selectedFilterIndexController.stream;

  final _mapSeasonsEpisodesController =
      BehaviorSubject<Map<String, List<EpisodeModel>>>();

  ValueStream<Map<String, List<EpisodeModel>>> get getMapSeasonsEpisodes =>
      _mapSeasonsEpisodesController.stream;

  late final BehaviorSubject<Map<String, String>>
      _menuFilterChosenValueController = BehaviorSubject<Map<String, String>>();

  ValueStream<Map<String, String>> get getMenuChosenValues =>
      _menuFilterChosenValueController.stream;

  // start Serie home view
  Function() get fetchSeriesHomeData => _fetchSeriesHomeData;

  void _fetchSeriesHomeData() async {
    // if(navbarList.isNotEmpty) {
    ResponseCategory responseCategory =
    await categoryService.getCategoriesCategories();
      ResponseSeriesByCategoryInfo responseSeries =
      await serieService.getAllSeries();

      navbarList = responseCategory.listCategories;

      RouteScreenModel screenRouteData =
      ScreenModelRepository().getRouteScreenData(
        navbarList,
        responseSeries.listSeriesInfos,
        0,
        AssetsManager.bgSeries,
      );
      screenRouteData.indexSliderClicked = -1;
      _seriesRouteDataStreamController.sink.add(screenRouteData);

      listInitialOfSeries = responseSeries.listSeriesInfos;
      getFilterData();
    // }
  }

  void onSliderClicked(int index, var slider) async {
    final screenModel = _seriesRouteDataStreamController.value;
    if (screenModel.indexSliderClicked == index) {
      if (kDebugMode) {
        print("slider clicked ($index) = ${slider.name}");
      }
    }
    screenModel.indexSliderClicked = index;
    _seriesRouteDataStreamController.sink.add(screenModel);
    // _selectedSliderIndexController.sink.add(index);
  }

  void onNavbarItemClicked(int index, Future<dynamic> getByCategory) async {
    final screenModel = _seriesRouteDataStreamController.value;
    screenModel.indexSliderClicked = -1;
    _seriesRouteDataStreamController.sink.add(screenModel);
    screenModel.indexNavbarClicked = index;
    if (navbarList[index].icon.isNotEmpty) {
      screenModel.backgroundImage = navbarList[index].icon;
    } else {
      screenModel.backgroundImage = AssetsManager.bgSeries;
    }
    dynamic responseCategory = await getByCategory;
    screenModel.listOfBodyItems = responseCategory.listSeriesInfos;
    _seriesRouteDataStreamController.sink.add(screenModel);

    listInitialOfSeries = responseCategory.listSeriesInfos;
    getFilterData();
    // listOfLiveChannels = responseCategories.listChannels;
  }

  /// End Serie home view


  /// filter feature
  Function() get getFilterData => _getAllYearsFromMovies;

  void _getAllYearsFromMovies() async {
    if (_seriesRouteDataStreamController.hasValue) {
      final seriesList = _seriesRouteDataStreamController.value.listOfBodyItems;
      // final listSeries = _seriesRouteDataStreamController.value.listOfBodyItems;
      // final seriesList = listSeries;
      // Extract all years from the movies list
      Set<String> yearsSet = seriesList!
          .map((movie) => movie.date.toString().split('-')[0])
          .toSet();
      // Convert the set of years to a list of strings
      List<String> yearsList = ["All"];
      yearsList.addAll(yearsSet.map((year) => year).toList());
      yearsList = yearsList.where((s) => s.isNotEmpty).toList();

      // Sort the list of years in descending order
      yearsList.sort((a, b) => b.compareTo(a));

      List<String> allGenres = ["All"];
      final List<String> genresSet = seriesList
          .fold<List<String>>([], (previousValue, element) {
            allGenres.addAll(element.genre?.split(",") as Iterable<String>);
            allGenres =
                allGenres.map((genre) => genre.trimLeft()).toSet().toList();
            allGenres = allGenres.where((s) => s.isNotEmpty).toList();
            return allGenres;
          })
          .toSet()
          .toList();

      listYears.clear();
      listGenres.clear();
      listYears.addAll(yearsList);
      listGenres.addAll(genresSet);
    }
  }

  void onApplyFilter(Map<String, String> menu) {
    bool thereIsFilter = false;
    List<SerieByCategoryInfosModel> filteredSeries = [];
    String selectedYear = "", selectedGenre = "", selectedOrderAlphabet = "";
    for (int i = 0; i < AppConstants.menusFilterValue.length; i++) {
      String value = menu[AppConstants.menusFilterKey[i]] ?? "";
      if (kDebugMode) {
        print("value = $value");
      }
      if (value != AppConstants.menusFilterValue[i] && value.isNotEmpty) {
        thereIsFilter = true;
        if (i == 0) {
          selectedYear = value;
         } else if (i == 1) {
          selectedGenre = value;
        } else if (i == 3) {
          selectedOrderAlphabet = value;
        }

      }
    }
    if (kDebugMode) {
      print("listInitialOfSeries = $listInitialOfSeries");
    }
    for (var serie in listInitialOfSeries) {
      // Check if the series year matches the selected year
      if (selectedYear.isNotEmpty &&
          selectedYear != serie.date.toString().split('-')[0].trimLeft()) {
        continue;
      }

      // Check if the serie's genres contain the selected genre
      if (selectedGenre.isNotEmpty &&
          serie.genre?.contains(selectedGenre) == false) {
        continue;
      }

      // If the serie matches both filters, add it to the filteredSeries list
      filteredSeries.add(serie);
    }

    if (selectedOrderAlphabet.isNotEmpty) {
      if (selectedOrderAlphabet == AppConstants.menusOrderValue[1]) {
        filteredSeries.sort((a, b) => b.name!.compareTo(a.name!));
      } else {
        filteredSeries.sort((a, b) => a.name!.compareTo(b.name!));
      }
    }

    final screenModel = _seriesRouteDataStreamController.value;
    screenModel.listOfBodyItems = filteredSeries;
    screenModel.indexSliderClicked = -1;

    if (!thereIsFilter) {
      screenModel.listOfBodyItems = listInitialOfSeries;
    }

    _seriesRouteDataStreamController.add(screenModel);
  }

  void onInitMenuFilterValue() {
    Map<String, String> map = {};
    for (int i = 0; i < AppConstants.menusFilterValue.length; i++) {
      map[AppConstants.menusFilterKey[i]] = AppConstants.menusFilterValue[i];
    }
    _menuFilterChosenValueController.sink.add(map);
  }

  void onFilterClicked(int index, bool changePage) async {
    _selectedFilterIndexController.sink.add(index);

    if (changePage) {
      _selectedFilterIndexController.sink.add(-1);
    }
  }

  void scrollNavbarToSelected(
      int index, ScrollController scrollNavbarController) {
    if (scrollNavbarController.hasClients) {
      scrollNavbarController.animateTo(
        index * (Get.width * .12),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollFilterToSelected(
      int index, ScrollController scrollFilterController) {
    if (scrollFilterController.hasClients) {
      scrollFilterController.animateTo(
        index * (Get.height * .05),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollSlidersToSelected(
      int index, ScrollController scrollController, int crossAxisCount) {
    int row = index ~/ crossAxisCount; // calculate the row index
    double offset = row * (Get.height * .445); // calculate the offset

    if (scrollController.hasClients) {
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Start() & dispose()
  void start() {
    fetchSeriesHomeData();
    onInitMenuFilterValue();
  }

  void dispose() {
    _selectedFilterIndexController.close();
    _seriesRouteDataStreamController.close();
  }
  /// End start() & dispose()

}


