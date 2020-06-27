import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IDKitActivityIndicator extends StatefulWidget {
  const IDKitActivityIndicator({
    Key key,
    this.size,
    this.radius,
    this.trackCount,
    this.style,
    this.bgColor,
  }) : super(key: key);
  // Bottom size of the activity indicator
  final Size size;
  // Corner of activity indicator
  final double radius;
  // Number of moving indicator tracks
  final int trackCount;
  // Activity indicator track style
  final ActivityIndicatorStyle style;
  // Activity indicator track style
  final Color bgColor;

  _IDKitActivityIndicator createState() => _IDKitActivityIndicator();
}

class _IDKitActivityIndicator extends State<IDKitActivityIndicator> {
  // Status refresh timer
  Timer _timer;
  // Current active indicator point front position
  int _curIndex = 0;
  // Bottom rotating track
  Picture _trackBgPicture;
  // Bottom size of the activity indicator is default
  Size _defaultSize = Size(80, 80);
  int _defaultCount = 12;
  // Default style for active indicators
  ActivityIndicatorStyle _defaultStyle = ActivityIndicatorStyle(
    color: Colors.black45,
    activityColor: Colors.white,
    lineWidth: 1,
    offsetCenter: 10,
    offsetMargin: 20,
  );

  ActivityIndicatorStyle _style;

  @override
  void initState() {
    super.initState();
    _style = widget.style ?? _defaultStyle;
    _style = ActivityIndicatorStyle(
      color: _style.color ?? _defaultStyle.color,
      activityColor: _style.activityColor ?? _defaultStyle.activityColor,
      lineWidth: _style.lineWidth ?? _defaultStyle.lineWidth,
      offsetCenter: _style.offsetCenter ?? _defaultStyle.offsetCenter,
      offsetMargin: _style.offsetMargin ?? _defaultStyle.offsetMargin,
    );
    _trackBgPicture = DrawTrack(
      count: widget.trackCount ?? _defaultCount,
      size: widget.size ?? _defaultSize,
      style: _style,
    ).getTrackBgImage();
    _timer = Timer.periodic(Duration(milliseconds: 80), (timer) {
      setState(() {
        if (_curIndex >= (widget.trackCount ?? _defaultCount)) {
          _curIndex = 1;
        } else {
          _curIndex += 1;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _trackBgPicture.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var _size = widget.size;
    if (_size == null) _size = _defaultSize;
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor ?? Colors.black26,
        borderRadius: BorderRadius.circular(widget.radius ?? 8),
      ),
      width: _size.width ?? _defaultSize.width,
      height: _size.height ?? _defaultSize.height,
      child: CustomPaint(
        size: widget.size ?? _defaultSize,
        painter: _IDKitActivityIndicatorPaint(
          activityIndex: _curIndex,
          trackBgImage: _trackBgPicture,
          style: _style,
          count: widget.trackCount ?? _defaultCount,
        ),
      ),
    );
  }
}

// Draw the bottom rotation track
class DrawTrack {
  DrawTrack({
    @required this.count,
    @required this.size,
    @required this.style,
  });
  // Count of track line
  final int count;
  // Size of drawing board at the bottom of track
  final Size size;
  // Style of track
  final ActivityIndicatorStyle style;
  // Track bottom Sketchpad recorder
  PictureRecorder _recorder = PictureRecorder();

  // Get the bottom image of the track
  Picture getTrackBgImage() {
    double _angle = 2 * pi / count;
    Canvas _canvas = Canvas(_recorder);
    _canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _paintTrack(_canvas, _angle);
    return _recorder.endRecording();
  }

  // Draw the default track for the active indicator
  void _paintTrack(Canvas canvas, double angle) {
    double halfWidrh = size.width * 0.5;
    double halfHeight = size.height * 0.5;
    canvas.translate(halfWidrh, halfHeight);
    var _paint = new Paint()
      ..color = style.color
      ..strokeWidth = style.lineWidth
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < count; i++) {
      canvas.save();
      canvas.rotate(i * angle);
      Offset p1 = Offset(0, style.offsetCenter);
      Offset p2 = Offset(0, halfHeight - style.offsetMargin);
      canvas.drawLine(p1, p2, _paint);
      canvas.restore();
    }
  }
}

class _IDKitActivityIndicatorPaint extends CustomPainter {
  _IDKitActivityIndicatorPaint({
    @required this.activityIndex,
    @required this.trackBgImage,
    @required this.style,
    @required this.count,
  });

  final int count;
  final int activityIndex;
  final ActivityIndicatorStyle style;
  final Picture trackBgImage;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(trackBgImage);
    _rotateActivityLine(canvas, size);
  }

  void _rotateActivityLine(Canvas canvas, Size size) {
    double _angle = 2 * pi / count;
    double _halfw = size.width * 0.5;
    double _halfh = size.height * 0.5;
    canvas.save();
    canvas.translate(_halfw, _halfh);
    canvas.rotate(_angle * activityIndex);
    var _paint = Paint()
      ..color = style.activityColor
      ..strokeWidth = style.lineWidth
      ..strokeCap = StrokeCap.round;
    Offset p1 = Offset(0, style.offsetCenter);
    Offset p2 = Offset(0, _halfh - style.offsetMargin);
    canvas.drawLine(p1, p2, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// Style of active indicator
class ActivityIndicatorStyle with Diagnosticable {
  const ActivityIndicatorStyle({
    this.color,
    this.activityColor,
    this.lineWidth,
    this.offsetCenter,
    this.offsetMargin,
  });

  final Color color;
  final Color activityColor;
  final double lineWidth;
  final double offsetCenter;
  final double offsetMargin;
}
