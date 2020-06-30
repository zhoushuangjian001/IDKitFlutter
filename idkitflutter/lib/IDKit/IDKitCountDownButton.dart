import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// style
@immutable
class CountDownButtonStyle with Diagnosticable {
  const CountDownButtonStyle({
    this.bgColor,
    this.radius,
    this.textStyle,
    this.margin,
    this.padding,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
  });

  // background color
  final Color bgColor;

  // Tangent radius
  final double radius;

  // text style
  final TextStyle textStyle;

  // side offset
  final EdgeInsetsGeometry margin;
  // int offset
  final EdgeInsetsGeometry padding;

  // border color
  final Color borderColor;
  // border width
  final double borderWidth;
  // border style
  final BorderStyle borderStyle;
}

class IDKitCountDownButton extends StatefulWidget {
  /// time
  final int totalTime;

  /// init title
  final String title;

  /// countdown type
  final Function(Function(String), int time) countDownTitle;

  /// method block
  final Function(Function(bool) callBlock) methodBlock;

  /// style
  final CountDownButtonStyle style;

  const IDKitCountDownButton(this.title, this.countDownTitle,
      {this.totalTime, this.methodBlock, this.style, Key key})
      : super(key: key);
  _IDKitCountDownButton createState() => _IDKitCountDownButton();
}

class _IDKitCountDownButton extends State<IDKitCountDownButton> {
  // current time
  int curTime = 0;
  // countdown type
  String curctTile;
  // state
  bool isDoing = false;
  // timer
  Timer _timer;

  /// style
  CountDownButtonStyle defaultStyle;
  CountDownButtonStyle effectiveStyle;

  /// init
  @override
  void initState() {
    super.initState();
    effectiveStyle = widget.style;
    defaultStyle = _initDefaultStyle();
    if (effectiveStyle == null) {
      effectiveStyle = defaultStyle;
    }
    curTime = widget.totalTime ?? 60;
    curctTile = widget.title;
  }

  /// handle type of countdown
  void _handleType() {
    widget.countDownTitle((title) {
      curctTile = title;
    }, curTime);
  }

  /// init default style
  CountDownButtonStyle _initDefaultStyle() {
    return CountDownButtonStyle(
      bgColor: Colors.white,
      radius: 0.0,
      textStyle: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      borderColor: Colors.grey,
      borderWidth: 1,
      borderStyle: BorderStyle.solid,
    );
  }

  @override
  Widget build(BuildContext context) {
    _handleType();
    return GestureDetector(
      child: Container(
        margin: effectiveStyle.margin ?? defaultStyle.margin,
        padding: effectiveStyle.padding ?? defaultStyle.padding,
        decoration: BoxDecoration(
          color: effectiveStyle.bgColor ?? defaultStyle.bgColor,
          borderRadius: BorderRadius.circular(
            effectiveStyle.radius ?? defaultStyle.radius,
          ),
          border: Border.all(
            color: effectiveStyle.borderColor ?? defaultStyle.borderColor,
            width: effectiveStyle.borderWidth ?? defaultStyle.borderWidth,
            style: effectiveStyle.borderStyle ?? defaultStyle.borderStyle,
          ),
        ),
        child: Center(
          child: Text(
            isDoing == false ? widget.title : curctTile,
            style: effectiveStyle.textStyle ?? defaultStyle.textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      onTap: () {
        widget.methodBlock(
          (isStart) {
            if (isStart && !isDoing) {
              isDoing = true;
              _timer = Timer.periodic(
                Duration(seconds: 1),
                (timer) {
                  if (curTime < 1) {
                    isDoing = false;
                    curctTile = widget.title;
                  } else {
                    curTime -= 1;
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
