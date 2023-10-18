import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

import '../view/initialize_popup.dart';

enum PlayerType { videoPlayer, vlcPlayer }

class VideoPlayerViewModel {
  late VideoPlayerController videoPlayerController;
  late VlcPlayerController vlcPlayerController;
  late RxInt duration = RxInt(0);
  RxBool useVlc = RxBool(false);

  dynamic video;
  bool _isLive = false;

  late final BehaviorSubject<bool> _showControlsSubject =
      BehaviorSubject<bool>.seeded(false);
  late final BehaviorSubject<Duration> _positionSubject =
      BehaviorSubject<Duration>.seeded(Duration.zero);
  bool _positionSubjectIsClosed = false;

  late final BehaviorSubject<bool> _isPlayingSubject =
      BehaviorSubject<bool>.seeded(false);
  final _focusedButtonIndexController = BehaviorSubject<int>();

  ValueStream<bool> get getShowControls => _showControlsSubject.stream;

  ValueStream<Duration> get getPosition => _positionSubject.stream;

  Stream<bool> get isPlayingStream => _isPlayingSubject.stream;

  ValueStream<int> get getFocusedButtonIndex =>
      _focusedButtonIndexController.stream;

  PlayerType selectedPlayer = PlayerType.videoPlayer; // Add this line

  void handleButtonSelection(int direction, length) {
    int currentIndex = _focusedButtonIndexController.value;
    if (currentIndex + direction >= 0 && currentIndex + direction <= length) {
      int newIndex = currentIndex + direction;
      _focusedButtonIndexController.sink.add(newIndex);
    }
  }

  void setIsVlc(bool isVlc){
    useVlc = RxBool(isVlc);
  }

  void setDuration(Duration dur) {
    duration = RxInt(dur.inMilliseconds);
    if (useVlc.value && videoPlayerController.value.isInitialized) {
      disposeVideoPlayerController();
    }
  }

  VideoPlayerViewModel(dynamicVideo, {bool isLive = false}){
    video = dynamicVideo;
    _isLive = isLive;
  }

  void toggleControlsVisibility(bool visible) {
    _showControlsSubject.sink.add(!visible);
  }



  Future<void> initializeVideoPlayer(
      BuildContext context) async {


    videoPlayerController = VideoPlayerController.network(video.url);
    if(!_isLive) {
      videoPlayerController.initialize().then((_) {
        print("rx duration = $duration");
        setDuration(videoPlayerController.value.duration);
        if (!useVlc.value) {
          videoPlayerController.play();
        } else {
          videoPlayerController.pause();
        }
      });
    }

    print("using vlc ? ${useVlc.value}");
    if (useVlc.value) {
      vlcPlayerController = VlcPlayerController.network(
        video.url,
        hwAcc: HwAcc.full,
        autoInitialize: true,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
    }

    if(!_isLive) {
      _focusedButtonIndexController.sink.add(-1);

      /*print("start init");
    await videoPlayerController.initialize().then((value) {
      print("initialized");
      videoPlayerController.play();
    });*/

      // await videoPlayerController.initialize();
      // videoPlayerController.play();


      if (useVlc.value) {
        vlcPlayerController.addListener(() {
          final Duration currentPosition = vlcPlayerController.value.position;
          if (!_positionSubjectIsClosed) {
            _positionSubject.sink.add(
              currentPosition);
          }
        });
      } else {
        videoPlayerController.addListener(() {
          final Duration currentPosition = videoPlayerController.value.position;
          if (!_positionSubjectIsClosed) {
            _positionSubject.sink.add(
              currentPosition);
          }
        });
      }

      Timer(const Duration(seconds: 5), () {
        _showControlsSubject.sink.add(false);
      });
    }
    _isPlayingSubject.sink.add(true);
  }

  Future<void> playPause() async {
    if (useVlc.value) {
      print("value.isPlaying = ${vlcPlayerController.value.isPlaying}");
      if (vlcPlayerController.value.isPlaying) {
        _showControlsSubject.sink.add(true);
        await vlcPlayerController.pause();
      } else {
        await vlcPlayerController.play();
        Timer(const Duration(seconds: 2), () {
          _showControlsSubject.sink.add(false);
        });
      }
      _isPlayingSubject.add(vlcPlayerController.value.isPlaying);
    } else {
      print("value.isPlaying = ${videoPlayerController.value.isPlaying}");
      if (videoPlayerController.value.isPlaying) {
        _showControlsSubject.sink.add(true);
        await videoPlayerController.pause();
      } else {
        await videoPlayerController.play();
        Timer(const Duration(seconds: 2), () {
          _showControlsSubject.sink.add(false);
        });
      }
      _isPlayingSubject.add(videoPlayerController.value.isPlaying);
    }
  }

  void seekTo(Duration position) {
    if (useVlc.value) {
      // if(!vlcPlayerController.viewId!.isNull) {
        print("seek vlc");
        vlcPlayerController.setTime(position.inMilliseconds);
      // }
    } else {
      videoPlayerController.seekTo(position);
    }
    _positionSubject.add(position);
  }



  closePosition() async{
    _positionSubjectIsClosed = true;
    _positionSubject.close();
  }
  disposeVlc()async{
    print("disposing VLC player !");
    vlcPlayerController.removeListener(() {});
    await vlcPlayerController.stopRendererScanning();
    await vlcPlayerController.stopRecording();
    await vlcPlayerController.stop();
    vlcPlayerController.dispose();
  }

  disposeVideoPlayerController() async{
    print("disposing video player !");
    videoPlayerController.removeListener(() {});
    videoPlayerController.dispose();
  }

  Future<void> disposeVideoPlayer() async {

    // Add this:
    if (useVlc.value) {
      vlcPlayerController.removeListener(() {
        print("removed vlc");
      });
    } else {
      videoPlayerController.removeListener(() {
        print("removed video player");
      });
    }

    _focusedButtonIndexController.close();
    _showControlsSubject.close();
    _isPlayingSubject.close();
    closePosition();

    if (useVlc.value) {
      disposeVlc();
    }else {
      disposeVideoPlayerController();
    }
  }
}
