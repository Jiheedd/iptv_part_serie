import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/styles_manager.dart';
import '../viewmodel/videoplayer_viewmodel.dart';

class InitializeDialog extends StatefulWidget {
  final BuildContext preContext;
  final VideoPlayerViewModel viewModel;
  final Duration lastPosition;

  const InitializeDialog({
    Key? key,
    required this.preContext,
    required this.viewModel,
    required this.lastPosition,
  }) : super(key: key);

  @override
  State<InitializeDialog> createState() => _InitializeDialogState();
}

class _InitializeDialogState extends State<InitializeDialog> {
  int _selectedButton = 0;
  final FocusNode _rawMainFocus = FocusNode();

  @override
  void initState() {
    // _viewModel = VideoPlayerViewModel();
    // _viewModel.initializeVideoPlayer(context, );
    super.initState();
  }

  @override
  void dispose() {
    _rawMainFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .017),
        height: Get.height * 0.6,
        width: Get.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: Get.height * .05,
              ),
              height: Get.height * .2,
              width: Get.width * .2,
              // color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: ColorManager.selectedNavBarItem,
                  size: Get.height * .2,
                ),
              ),
            ),
            Text(
              'You already started this Show',
              style: getRegularStyle(
                color: ColorManager.black,
                fontSize: Get.height * .07,
              ),
              textAlign: TextAlign.center,
            ),
            RawKeyboardListener(
              focusNode: _rawMainFocus,
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                    if (_selectedButton == 0) {
                      setState(() {
                        _selectedButton = 1;
                      });
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                    if (_selectedButton == 1) {
                      setState(() {
                        _selectedButton = 0;
                      });
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.select) {
                    if (_selectedButton == 0) {
                      widget.viewModel.seekTo(widget.lastPosition);
                    } else {
                      widget.viewModel.seekTo(Duration.zero);
                    }
                    // _viewModel.initChewieController();
                    Get.back();
                  }
                }
              },
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(
                        Get.height * .03,
                      ),
                      height: Get.height * .12,
                      child: OutlinedButton(
                        // focusNode: _okButtonFocus,
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Set the desired border radius value
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            _selectedButton == 0
                                ? ColorManager.selectedNavBarItem
                                : Colors.transparent,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                              width: 1,
                              color: ColorManager.selectedNavBarItem,
                            ),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(
                              150,
                              Get.height * .11,
                            ),
                          ),
                        ),
                        child: Text(
                          'Resume',
                          style: getRegularStyle(
                            color: _selectedButton == 0
                                ? ColorManager.white
                                : ColorManager.selectedNavBarItem,
                            fontSize: Get.height * .075,
                          ),
                        ),
                        onPressed: () {
                          if (_selectedButton == 1) {
                            setState(() {
                              _selectedButton = 0;
                            });
                          } else {
                            widget.viewModel.seekTo(widget.lastPosition);
                            // widget.viewModel.playPause();
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(
                        MediaQuery.of(context).size.height * .03,
                      ),
                      height: MediaQuery.of(context).size.height * .12,
                      child: OutlinedButton(
                        // focusNode: _cancelButtonFocus,
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Set the desired border radius value
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            _selectedButton == 1
                                ? ColorManager.selectedNavBarItem
                                : Colors.transparent,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                                width: 1,
                                color: ColorManager.selectedNavBarItem),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(
                              150,
                              MediaQuery.of(context).size.height * .11,
                            ),
                          ),
                        ),
                        child: Text(
                          'Restart',
                          style: getRegularStyle(
                            color: _selectedButton == 1
                                ? ColorManager.white
                                : ColorManager.selectedNavBarItem,
                            fontSize: MediaQuery.of(context).size.height * .075,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          if (_selectedButton == 0) {
                            setState(() {
                              _selectedButton = 1;
                            });
                          } else {
                            widget.viewModel.seekTo(Duration.zero);
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
