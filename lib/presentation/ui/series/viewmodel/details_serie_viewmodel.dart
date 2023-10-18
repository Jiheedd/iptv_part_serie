import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/responses/serie_response.dart';
import '../../../../domain/services/serie_services.dart';
import '../../../resources/constants_manager.dart';

class DetailsSerieViewModel {
  // final MoviesScreenRepository _moviesRouteRepository = MoviesScreenRepository();

  final _focusPartIndexController = BehaviorSubject<int>.seeded(0);
  final _selectedSeasonIndexController = BehaviorSubject<int>.seeded(0);
  final _selectedEpisodeIndexController = BehaviorSubject<int>.seeded(0);
  late List<SeasonModel> listOfSeasons = [];

  final _mapSeasonsEpisodesController =
      BehaviorSubject<Map<String, List<EpisodeModel>>>();

  final _isFavoriteIconController = BehaviorSubject<bool>();
  final isTappedController = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<List<FocusNode>> episodesListNode =
      BehaviorSubject<List<FocusNode>>.seeded([]);

  final ScrollController scrollSeasonController = ScrollController();
  final ScrollController scrollEpisodeController = ScrollController();

  ValueStream<Map<String, List<EpisodeModel>>> get getMapSeasonsEpisodes =>
      _mapSeasonsEpisodesController.stream;

  ValueStream<int> get getFocusedPartIndex => _focusPartIndexController.stream;

  ValueStream<int> get selectedSeasonIndex =>
      _selectedSeasonIndexController.stream;

  ValueStream<int> get selectedEpisodeIndex =>
      _selectedEpisodeIndexController.stream;

  ValueStream<bool> get isFavoriteController =>
      _isFavoriteIconController.stream;

  // ValueStream<List<FocusNode>> get episodeListNodeStream => episodesListNode.stream;

  static late dynamic _slider;

  DetailsSerieViewModel(dynamic slider) {
    _slider = slider;
  }

  // Details Serie
  void Function(dynamic slider) get fetchDetailsData => _fetchDetailsData;

  void _fetchDetailsData(dynamic slider) async {
    Map<String, List<EpisodeModel>> seasonEpisodeMap = {};
    seasonEpisodeMap = await getEpisodeAndSeasonsMap(slider);
    _mapSeasonsEpisodesController.sink.add(seasonEpisodeMap);
  }

  dynamic getSlider() {
    return _slider;
  }

  void toggleMenu({int? direction}) {
    bool value = isTappedController.value;
    print("_isTapped = ${!value}");
    if (direction == 0) {
      isTappedController.sink.add(false);
    } else {
      navigateToPartScreen(_focusPartIndexController.value == 1 ? 0 : 1);
      isTappedController.sink.add(!value);
    }
    return;
  }

  void getNewListEpisodeNode(List<EpisodeModel>? list) {
    print("list of episode : ${list.toString()}");
    print("list length : ${list?.length}");
    episodesListNode.sink.add(
      List.generate(
        list?.length ?? 0,
        (index) => FocusNode(),
      ),
    );
  }

  Future<Map<String, List<EpisodeModel>>> getEpisodeAndSeasonsMap(
      dynamic slider) async {
    // print(
    //     "_listUnderCategoryController = ${_listUnderCategoryController.value}");
    ResponseSeasonBySerie responseSeasonBySerie =
        await serieService.getAllSeasons();

    listOfSeasons = responseSeasonBySerie.listSaisons;
    final Map<String, List<EpisodeModel>> seasonEpisodeMap = {};
    for (int i = 0; i < listOfSeasons.length; i++) {
      print("listOfSeasons[$i] = ${listOfSeasons[i].season}");
      final getListEpisodes = await serieService.getAllEpisodes();
      seasonEpisodeMap[listOfSeasons[i].season] = getListEpisodes.listEpisode;
      if (i == 0) {
        getNewListEpisodeNode(getListEpisodes.listEpisode);
      }
    }

    return seasonEpisodeMap;
  }

  void navigateToPartScreen(int newIndex) {
    if (newIndex == 2) {
      _selectedSeasonIndexController.sink.add(-1);
    } else if (newIndex == 0) {
      _selectedSeasonIndexController.sink.add(0);
    }
    _focusPartIndexController.sink.add(newIndex);
  }

  void handleSeasonSelection(int direction) {
    int indexSeason = _selectedSeasonIndexController.value;

    if (direction == 0) {
      indexSeason = 0;
    } else if (indexSeason + direction >= 0 &&
        indexSeason + direction < listOfSeasons.length) {
      indexSeason += direction;
    }
    getNewListEpisodeNode(
        _mapSeasonsEpisodesController.value[listOfSeasons[indexSeason].season]);
    _selectedSeasonIndexController.sink.add(indexSeason);
    scrollListSeasonToSelected();
  }

  void handleEpisodeSelection(int direction) {
    int indexEpisode = _selectedEpisodeIndexController.value;
    int indexSeason = _selectedSeasonIndexController.value;
    final listOfEpisode =
        _mapSeasonsEpisodesController.value[listOfSeasons[indexSeason].season];
    if (direction == 0) {
      indexEpisode = 0;
      // _navbarItemsFocusNode.map((e) => e.unfocus());
    } else if (indexEpisode + direction >= 0 &&
        indexEpisode + direction < listOfEpisode!.length) {
      indexEpisode += direction;
    }
    _selectedEpisodeIndexController.sink.add(indexEpisode);
    scrollListEpisodeToSelected();
  }

  void scrollListSeasonToSelected() {
    if (scrollSeasonController.hasClients) {
      scrollSeasonController.animateTo(
        _selectedSeasonIndexController.value * (Get.height * .25),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /*void scrollListEpisodeToSelected() {
    if (scrollEpisodeController.hasClients) {
      print("scrolling episode");
      scrollEpisodeController.animateTo(
        _selectedEpisodeIndexController.value * (Get.height * .1),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }*/
  void scrollListEpisodeToSelected() {
    if (scrollEpisodeController.hasClients &&
        _selectedEpisodeIndexController.value < episodesListNode.value.length) {
      int episodeIndex = _selectedEpisodeIndexController.value;
      print("scrolling episode $episodeIndex");

      if (episodeIndex - 1 >= 0) {
        episodeIndex -= 1;
        episodesListNode.value[episodeIndex].requestFocus();
        Scrollable.ensureVisible(
          episodesListNode.value[episodeIndex].context!,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      } else {
        scrollEpisodeController.animateTo(
          episodeIndex * (Get.height * .1),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void onSelectEpisode(int index) {
    _selectedEpisodeIndexController.sink.add(index);
  }

  void toggleFavorite() {
    _slider.isFavorite = !_slider.isFavorite;
    print("serie.isFavorite : ${_slider.isFavorite}");
    if (_slider.isFavorite) {
      _isFavoriteIconController.sink.add(true);
    } else {
      _isFavoriteIconController.sink.add(false);
    }
  }

  /// End Details serie

  /// Start() & dispose()
  void start() {
    _focusPartIndexController.sink.add(0);
    fetchDetailsData(_slider);
  }

  void dispose() {
    _selectedSeasonIndexController.close();
    _selectedEpisodeIndexController.close();
    _focusPartIndexController.close();
  }
}
