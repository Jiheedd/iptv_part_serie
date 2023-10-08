import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';

class WaitingWidget extends StatefulWidget {
  final String title;
  final bool isTransparent;
  final bool isEmpty;
  final String? bgImage;

  WaitingWidget({
    required this.title,
    this.isTransparent = false,
    this.isEmpty = false,
    this.bgImage,
    Key? key,
  }) : super(key: key);

  @override
  _WaitingWidgetState createState() => _WaitingWidgetState();
}

class _WaitingWidgetState extends State<WaitingWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.bgImage != null && widget.bgImage != ""
            ? Image.asset(
          widget.bgImage!,
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        )
            : Container(
          height: double.infinity,
          width: double.infinity,
          color: widget.isTransparent
              ? ColorManager.transparent
              : ColorManager.black,
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: Get.height * .15,
              width: Get.width * .1,
              child: Image.asset(
                AssetsManager.progressGif, // Replace with your GIF image path
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            )
        )
      ],
    );
  }
}

