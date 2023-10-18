import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../widgets/waiting_widget.dart';
import '../viewmodel/videoplayer_viewmodel.dart';
import 'choose_player_dialog.dart';
import 'custom_controls_partview.dart';

class VideoPlayerView extends StatefulWidget {
  final dynamic video;
  final bool isLive;
  const VideoPlayerView({
    required this.video,
    this.isLive = false,
    super.key,
  });

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerViewModel _viewModel;

  late bool _isPlaying = false;
  late bool _showController;
  late Duration _currentPosition;

  int _focusedButtonIndex = 0;
  late FocusNode _rawMainFocusNode;
  late List<Map<String, dynamic>> buttonConfigurations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies huuh");
    // Call the method to initialize the player here instead of initState
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _rawMainFocusNode = FocusNode();

    _viewModel = VideoPlayerViewModel(widget.video, isLive: widget.isLive);
    _viewModel.initializeVideoPlayer(context);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _viewModel.initializeVideoPlayer(context, widget.video);
    // });
    // _viewModel.initializeVideoPlayer(context, widget.video).then((_) {
    //   setState(() {});
    // });
    _viewModel.isPlayingStream.listen((isPlaying) {
      _isPlaying = isPlaying;
    });
    _viewModel.getShowControls.listen((showController) {
      _showController = showController;
    });
    _viewModel.getFocusedButtonIndex.listen((index) {
      setState(() {
        _focusedButtonIndex = index;
      });
    });
    _viewModel.getPosition.listen((pos) {
      _currentPosition = pos;
    });

    buttonConfigurations = [
      {
        'icon': Icons.fast_rewind,
        'onPressed': () {
          _viewModel.seekTo(Duration.zero);
        },
      },
      {
        'icon': Icons.replay_10,
        'onPressed': () {
          if (_currentPosition.inSeconds > 10) {
            _viewModel.seekTo(_currentPosition - const Duration(seconds: 10));
          } else {
            _viewModel.seekTo(Duration.zero);
          }
        },
      },
      {
        'icon': Icons.play_arrow,
        'onPressed': () {
          print("oui on pause");
          _viewModel.playPause();
        },
      },
      {
        'icon': Icons.forward_10,
        'onPressed': () {
          _viewModel.seekTo(
            _currentPosition + const Duration(seconds: 10),
          );
        },
      },
      {
        'icon': Icons.fast_forward,
        'onPressed': () {
          Duration globalDuration =
              Duration(milliseconds: _viewModel.duration.value);
          Duration newPosition = _currentPosition +
              Duration(milliseconds: _viewModel.duration.value ~/ 5);
          if (newPosition < globalDuration) {
            _viewModel.seekTo(newPosition);
          } else {
            _viewModel.seekTo(
              Duration(seconds: globalDuration.inSeconds - 10),
            );
          }
        },
      },
      {
        'icon': Icons.change_circle,
        'onPressed': () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return ChoosePlayerDialog(
                  viewModel: _viewModel,
                  // lastPosition: Duration.zero,
                  // preContext: context,
                  video: widget.video,
                );
              },
            ),
      },
    ];
  }

  @override
  void dispose() {
    _viewModel.disposeVideoPlayer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPlaying) {
      return Scaffold(
        body: Container(
          color: ColorManager.black,
          child: Center(
            child: CircularProgressIndicator(
              color: ColorManager.white,
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (!_showController) {
          return true;
        } else {
          _viewModel.toggleControlsVisibility(true);
          return false;
        }
      },
      child: GestureDetector(
        onTap: () {
          _viewModel.toggleControlsVisibility(_showController);
          if (_showController) {
            // Hide controls after 2 seconds of inactivity
            Timer(const Duration(seconds: 3), () {
              _viewModel.toggleControlsVisibility(true);
            });
          }
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        },
        child: RawKeyboardListener(
          focusNode: _rawMainFocusNode,
          onKey: _handleKeyEvent,
          child: Scaffold(
            body: Stack(
              children: [
                // Chewie(controller: _chewieController),
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Container(
                      color: ColorManager.black,
                      width: Get.width,
                      height: Get.height,
                      child: _viewModel.useVlc.value
                          ? VlcPlayer(
                              controller: _viewModel.vlcPlayerController,
                              aspectRatio: 16 / 9,
                              // virtualDisplay: false,
                              placeholder: WaitingWidget(title: ""),
                            )
                          : VideoPlayer(_viewModel.videoPlayerController),
                    ),
                  ),
                ),
                widget.isLive?
                  const  SizedBox.shrink()
                :
                StreamBuilder<bool>(
                  stream: _viewModel.getShowControls,
                  initialData: false,
                  builder: (context, snapshot) {
                    return AnimatedOpacity(
                      opacity: snapshot.data! ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: _buildControlsOverlay(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent && widget.isLive == false) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _viewModel.toggleControlsVisibility(_showController);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_showController) {
          _viewModel.toggleControlsVisibility(_showController);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (_showController) {
          _viewModel.handleButtonSelection(1, buttonConfigurations.length);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (_showController) {
          _viewModel.handleButtonSelection(-1, buttonConfigurations.length);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        if (!_showController) {
          _viewModel.toggleControlsVisibility(_showController);
        } else {
          switch (_focusedButtonIndex) {
            case 0:
              _viewModel.seekTo(Duration.zero);
              break;
            case 1:
              if (_currentPosition.inSeconds > 10) {
                _viewModel
                    .seekTo(_currentPosition - const Duration(seconds: 10));
              } else {
                _viewModel.seekTo(Duration.zero);
              }
              break;
            case 2:
              _viewModel.playPause();
              break;
            case 3:
              _viewModel.seekTo(_currentPosition + const Duration(seconds: 10));
              break;
            case 4:
              // int durationInMilliSeconds = _viewModel.duration.value;y
              Duration globalDuration =
                  Duration(milliseconds: _viewModel.duration.value);
              Duration newPosition = _currentPosition +
                  Duration(milliseconds: _viewModel.duration.value ~/ 5);
              if (newPosition < globalDuration) {
                _viewModel.seekTo(newPosition);
              } else {
                _viewModel.seekTo(
                  Duration(milliseconds: globalDuration.inSeconds - 10),
                );
              }
              break;
            case 5:
              buttonConfigurations[5]['onPressed'];
              break;
            default:
              buttonConfigurations[2]['onPressed'];
              break;
          }
        }
      }
    }
  }

  Widget _buildControlsOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: StreamBuilder<bool>(
        stream: _viewModel.isPlayingStream,
        initialData: false,
        builder: (context, snapshot) {
          return Stack(
            children: [
              CustomControls(
                viewModel: _viewModel,
                focusButtonIndex: _focusedButtonIndex,
                buttonConfigurations: buttonConfigurations,
              ),
              // Add settings button at top right corner
              Positioned(
                bottom: Get.height * .32,
                right: 16.0,
                child: Container(
                  width: Get.width * .1,
                  height: Get.height * .2,
                  color: _focusedButtonIndex == 5
                      ? ColorManager.selectedNavBarItem
                      : ColorManager.transparent,
                  child: IconButton(
                    icon: Icon(
                      buttonConfigurations[5]['icon'],
                      color: _focusedButtonIndex == 5
                          ? ColorManager.selectedNavBarItem
                          : ColorManager.white,
                      size: FontSize.s50,
                    ),
                    onPressed: buttonConfigurations[5]['onPressed'],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
