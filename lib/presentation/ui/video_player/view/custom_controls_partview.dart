import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../viewmodel/videoplayer_viewmodel.dart';

class CustomControls extends StatefulWidget {
  final VideoPlayerViewModel viewModel;
  int focusButtonIndex;
  List<Map<String, dynamic>> buttonConfigurations;

  CustomControls({
    super.key,
    required this.viewModel,
    required this.focusButtonIndex,
    required this.buttonConfigurations,
  });

  @override
  _CustomControlsState createState() => _CustomControlsState();
}

class _CustomControlsState extends State<CustomControls> {
  // late Duration _currentPosition;
  late FocusNode _sliderFocusNode;

  @override
  void initState() {
    super.initState();
    // Hide controls after 2 seconds of video playback
    Timer(const Duration(seconds: 2), () {
      widget.viewModel.toggleControlsVisibility(false);
    });
    _sliderFocusNode = FocusNode();
    _sliderFocusNode.unfocus();
    // widget.viewModel.getPosition.listen((pos) {
    //   _currentPosition = pos;
    // });
  }

  @override
  Widget build(BuildContext context) {
    _sliderFocusNode.unfocus();
    return Positioned(
      // alignment: Alignment.bottomCenter,
      bottom: 0,
      // child: Visibility(
      //   visible: _showController,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .3,
        color: ColorManager.black.withOpacity(0.7),
        child: Wrap(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                widget.buttonConfigurations.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // for (var config in buttonConfigurations)
                          for (int i = 0;
                              i < widget.buttonConfigurations.length - 1;
                              i++)
                            i == 2
                                ? Container(
                                    width: Get.width * .1,
                                    height: Get.height * .12,
                                    color: widget.focusButtonIndex == i
                                        ? ColorManager.selectedNavBarItem
                                        : ColorManager.transparent,
                                    child: StreamBuilder<bool>(
                                      stream: widget.viewModel.isPlayingStream,
                                      initialData: false,
                                      builder: (context, snapshot) {
                                        return IconButton(
                                          icon: Icon(
                                            snapshot.data!
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: FontSize.s40,
                                          ),
                                          onPressed: widget.viewModel.playPause,
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    width: Get.width * .09,
                                    height: Get.height * .12,
                                    color: widget.focusButtonIndex == i
                                        ? ColorManager.selectedNavBarItem
                                        : ColorManager.transparent,
                                    child: IconButton(
                                      icon: Icon(
                                        widget.buttonConfigurations[i]['icon'],
                                        color: Colors.white,
                                        size: FontSize.s30,
                                      ),
                                      onPressed: widget.buttonConfigurations[i]
                                          ['onPressed'],
                                    ),
                                  ),
                        ],
                      )
                    : Container(),
                StreamBuilder<Duration>(
                  stream: widget.viewModel.getPosition,
                  initialData: Duration.zero,
                  builder: (context, snapshot) {
                    Duration duration = const Duration(milliseconds: 0);
                    final position = snapshot.data ?? Duration.zero;
                    if (widget.viewModel.duration.value == 0) {
                      widget.viewModel.setDuration(
                        widget.viewModel.videoPlayerController.value.duration,
                      );
                    } else {
                      duration = Duration(
                        milliseconds: widget.viewModel.duration.value,
                      );
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        // if (!duration.isNull && duration.inMilliseconds > 0 && !position.isNull && position.inMilliseconds <= duration.inMilliseconds)
                        widget.viewModel.duration.value > 0
                            ? Slider(
                                value: position.inMilliseconds.toDouble(),
                                overlayColor: MaterialStatePropertyAll(
                                  ColorManager.transparent,
                                ),
                                activeColor: ColorManager.white,
                                focusNode: _sliderFocusNode,
                                autofocus: false,
                                min: 0,
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  final newPosition =
                                      Duration(milliseconds: value.toInt());
                                  if (newPosition.inMilliseconds ==
                                      duration.inMilliseconds.toInt()) {
                                    widget.viewModel.seekTo(Duration.zero);
                                  } else {
                                    widget.viewModel.seekTo(newPosition);
                                  }
                                },
                                onChangeStart: (value) {
                                  widget.viewModel
                                      .toggleControlsVisibility(true);
                                },
                                onChangeEnd: (value) {
                                  widget.viewModel
                                      .toggleControlsVisibility(true);
                                },
                              )
                            : Container(),
                      ],
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours < 1) {
      final minutes = duration.inMinutes;
      final seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      final hours = duration.inHours;
      final minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
  }
}
