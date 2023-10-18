import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../domain/responses/serie_response.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../video_player/view/videoplayer_view.dart';
import '../viewmodel/details_serie_viewmodel.dart';

// ignore: must_be_immutable
class VerticalDropdownButtonList extends StatefulWidget {
  final Map<String, List<EpisodeModel>> options;
  final List<String> seasonsList;
  final FocusNode mainFocusNode;
  final DetailsSerieViewModel viewModel;
  int focusPartScreen;

  VerticalDropdownButtonList({
    Key? key,
    required this.options,
    required this.seasonsList,
    required this.mainFocusNode,
    required this.viewModel,
    required this.focusPartScreen,
  }) : super(key: key);

  @override
  _VerticalDropdownButtonListState createState() =>
      _VerticalDropdownButtonListState();
}

class _VerticalDropdownButtonListState
    extends State<VerticalDropdownButtonList> {
  int _selectedSeasonIndex = -1;
  int _selectedEpisodeIndex = 0;
  StreamSubscription? _seasonIndexSubscription;
  StreamSubscription? _episodeIndexSubscription;
  StreamSubscription? _listNodeSubscription;
  StreamSubscription? _isTappedSubscription;

  bool _isTapped = false;

  @override
  void initState() {
    _isTappedSubscription =
        widget.viewModel.isTappedController.stream.listen((value) {
      if (mounted) {
        setState(() {
          print("listen is tapped $value");
          _isTapped = value;
        });
      }
    });
    _seasonIndexSubscription =
        widget.viewModel.selectedSeasonIndex.listen((indexSelected) {
      if (mounted) {
        setState(() {
          _selectedSeasonIndex = indexSelected;
        });
      }
    });

    _episodeIndexSubscription =
        widget.viewModel.selectedEpisodeIndex.listen((indexSelected) {
      if (mounted) {
        setState(() {
          _selectedEpisodeIndex = indexSelected;
        });
      }
    });
    _listNodeSubscription =
        widget.viewModel.episodesListNode.stream.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  void showSnackBar(String title, String subTitle) {
    Get.snackbar(
      title,
      subTitle,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black87.withOpacity(0.5),
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _seasonIndexSubscription?.cancel();
    _episodeIndexSubscription?.cancel();
    _listNodeSubscription?.cancel();
    _isTappedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('_isTapped from will pop scope : $_isTapped');
        if (_isTapped) {
          widget.viewModel.toggleMenu();
          return false;
        } else {
          return true;
        }
      },
      child: RawKeyboardListener(
        focusNode: widget.mainFocusNode,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              if (widget.focusPartScreen == 0) {
                widget.viewModel.handleSeasonSelection(-1);
              } else if (widget.focusPartScreen == 1) {
                widget.viewModel.handleEpisodeSelection(-1);
              }
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              if (widget.focusPartScreen == 0) {
                widget.viewModel.handleSeasonSelection(1);
              } else if (widget.focusPartScreen == 1) {
                widget.viewModel.handleEpisodeSelection(1);
              }
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              if (widget.focusPartScreen == 0) {
                widget.viewModel.navigateToPartScreen(2);
                if (_isTapped) {
                  widget.viewModel.toggleMenu();
                }
              } else if (widget.focusPartScreen == 1) {
                widget.viewModel.toggleMenu(direction: 0);
                widget.viewModel.handleEpisodeSelection(0);
                widget.viewModel.navigateToPartScreen(0);
              }
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              print("widget.focusPartScreen = ${widget.focusPartScreen}");
              if (widget.focusPartScreen == 2) {
                widget.viewModel.navigateToPartScreen(0);
              }
            } else if (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter) {
              if (widget.focusPartScreen == 0) {
                if (widget.options[widget.seasonsList[_selectedSeasonIndex]]!
                    .isNotEmpty) {
                  widget.viewModel.handleEpisodeSelection(0);
                  widget.viewModel.toggleMenu();
                } else {
                  showSnackBar(
                      "Empty data", "There is no episodes for this Season");
                }
              } else if (widget.focusPartScreen == 1) {
                final serie = widget.options[widget
                    .seasonsList[_selectedSeasonIndex]]![_selectedEpisodeIndex];
                Get.to(
                  () => VideoPlayerView(
                    video: serie,
                  ),
                );
              } else if (widget.focusPartScreen == 2) {
                widget.viewModel.toggleFavorite();
              }
            } else {
              // print("from else");
              // widget.viewModel.toggleMenu(direction: 0);
              // widget.viewModel.navigateToPartScreen(0);
              // widget.viewModel.handleSeasonSelection(0);
              // widget.viewModel.handleEpisodeSelection(0);
            }
          }
        },
        child: ListView.builder(
          controller: widget.viewModel.scrollSeasonController,
          itemCount: widget.options.length,
          itemBuilder: (BuildContext context, int i) {
            return InkWell(
              onTap: () {
                widget.viewModel.handleSeasonSelection(i);
                widget.viewModel.toggleMenu();
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: (_selectedSeasonIndex == i)
                          ? ColorManager.selectedNavBarItem
                          : Colors.transparent,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            (_selectedSeasonIndex == i && _isTapped)
                                ? Icons.keyboard_arrow_up_outlined
                                : Icons.keyboard_arrow_down_outlined,
                            color: ColorManager.white,
                            size: AppSize.s35,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .011,
                          ),
                          Text(
                            "Season ${widget.seasonsList[i]}",
                            style: getSemiBoldStyle(
                              color: (_selectedSeasonIndex == i)
                                  ? ColorManager.yellow
                                  : ColorManager.white,
                              fontSize: FontSize.s18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (_selectedSeasonIndex == i && _isTapped == true),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: widget.viewModel.scrollEpisodeController,
                          physics: const ScrollPhysics(),
                          itemCount:
                              widget.options[widget.seasonsList[i]]!.length,
                          itemBuilder: (BuildContext context, int j) {
                            return TextButton(
                              focusNode:
                                  widget.viewModel.episodesListNode.value[j],
                              onPressed: () {
                                final episodeModel =
                                    widget.options[widget.seasonsList[i]]![j];
                                final slider = widget.viewModel.getSlider();
                                episodeModel.icon = slider.icon;

                                (_selectedEpisodeIndex == j)
                                    ? Get.to(() =>
                                        VideoPlayerView(video: episodeModel))
                                    : setState(() {
                                        _selectedEpisodeIndex = j;
                                      });
                              },
                              child: Center(
                                child: Container(
                                  width: double.infinity,
                                  color: (_selectedEpisodeIndex == j)
                                      ? ColorManager.grey.withOpacity(0.3)
                                      : null,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 1),
                                  padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * .04,
                                    top: 10.0,
                                    bottom: 10.0,
                                  ),
                                  child: Text(
                                    "Episode ${_selectedSeasonIndex + 1}.${j + 1}",
                                    style: getRegularStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
