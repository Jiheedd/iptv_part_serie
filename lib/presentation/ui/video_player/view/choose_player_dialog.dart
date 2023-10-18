import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/styles_manager.dart';


class ChoosePlayerDialog extends StatefulWidget {
  // BuildContext preContext;
  final dynamic viewModel;

  // Duration lastPosition;
  final dynamic video;

  const ChoosePlayerDialog({
    // required this.preContext,
    required this.viewModel,
    // required this.lastPosition,
    this.video,
    Key? key,
  }) : super(key: key);

  @override
  State<ChoosePlayerDialog> createState() => _ChoosePlayerDialogState();
}

class _ChoosePlayerDialogState extends State<ChoosePlayerDialog> {
  late int _selectedButton;
  final FocusNode _rawMainFocus = FocusNode();

  @override
  void initState() {
    _selectedButton = widget.viewModel.useVlc.value ? 1 : 0;
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
        height: Get.height * 0.75,
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
                  Icons.check_circle_outline_rounded,
                  color: ColorManager.selectedNavBarItem,
                  size: Get.height * .2,
                ),
              ),
            ),
            Text(
              'Change video player if is there any problem!',
              style: getRegularStyle(
                color: ColorManager.black,
                fontSize: Get.height * .045,
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
                    // widget.viewModel.useVlc.value = _selectedButton == 1;

                    if (widget.viewModel.useVlc.value) {
                      widget.viewModel.disposeVlc();
                    } else {
                      widget.viewModel.disposeVideoPlayerController(widget.video);
                    }
                    // widget.viewModel.disposeVideoPlayer(widget.video);
                    widget.viewModel.setIsVlc(_selectedButton==1);

                      widget.viewModel
                          .initializeVideoPlayer(Get.context!);
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
                          'Default Player',
                          style: getRegularStyle(
                            color: _selectedButton == 0
                                ? ColorManager.white
                                : ColorManager.selectedNavBarItem,
                            fontSize: Get.height * .055,
                          ),
                        ),
                        onPressed: () {

                          if (_selectedButton == 1) {
                            setState(() {
                              _selectedButton = 0;
                            });
                          } else {
                            if (widget.viewModel.useVlc.value) {
                              widget.viewModel.disposeVlc();
                              widget.viewModel.setIsVlc(false);
                              widget.viewModel
                                  .initializeVideoPlayer(Get.context!);
                            }
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(
                        Get.height * .03,
                      ),
                      height: Get.height * .12,
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
                          'VLC Player',
                          style: getRegularStyle(
                            color: _selectedButton == 1
                                ? ColorManager.white
                                : ColorManager.selectedNavBarItem,
                            fontSize: MediaQuery.of(context).size.height * .055,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          if (_selectedButton == 0) {
                            setState(() {
                              _selectedButton = 1;
                            });
                          } else {
                            if(!widget.viewModel.useVlc.value){
                              widget.viewModel.disposeVideoPlayerController();
                              widget.viewModel.setIsVlc(true);
                              widget.viewModel
                                  .initializeVideoPlayer(Get.context!);
                            }

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
