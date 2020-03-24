import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idkitflutter/IDKit/IDKitActivityIndicator.dart';

/// Type of toast
enum ToastType {
  // Chrysanthemum
  chrysanthemum,
  // Separate text
  text,
  // Chrysanthemum and text
  all,
}

class ToastStyle extends Diagnosticable {
  const ToastStyle({
    this.alignment,
    this.disappearTime,
    this.type,
    this.radius,
    this.borderWidth,
    this.borderColor,
    this.bgColor,
    this.toastBgColor,
    this.toastWidth,
    this.toastHeight,
  });
  // Position of toast
  final Alignment alignment;
  // Toast auto disappear time
  final int disappearTime;
  // Type of toast
  final ToastType type;
  // Radius of toast
  final double radius;
  // Border width of toast
  final double borderWidth;
  // Border color of toast
  final Color borderColor;
  // The color of the bottom mask of the component.
  final Color bgColor;
  // The color of the bottom of the toast.
  final Color toastBgColor;
  // The width of the toast
  final double toastWidth;
  // The height of the toast
  final double toastHeight;
}

// Default Styles
const ToastStyle _toastStyle = ToastStyle(
  alignment: Alignment.center,
  disappearTime: 2,
  type: ToastType.chrysanthemum,
  radius: 6,
  borderWidth: 1,
  borderColor: Colors.transparent,
  bgColor: Colors.transparent,
  toastBgColor: Colors.black38,
);

const SeparateTextStyle _separateTextStyle = SeparateTextStyle(
  padding: EdgeInsets.all(8),
  maxHeightScale: 0.8,
  maxWidthScale: 0.618,
  textStyle: TextStyle(
    fontSize: 18,
    color: Colors.white,
  ),
);

const ChrysanthemumStyle _chrysanthemumStyle = ChrysanthemumStyle(
  chrysanthemumMargin: EdgeInsets.all(8),
);

/// Widget class of toast
class IDKitToast {
  /// Floating object
  static OverlayEntry _overlayEntry;

  /// Single chrysanthemum rotation
  static void showLoading(
    BuildContext context, {
    ChrysanthemumStyle chrysanthemumStyle,
    ToastStyle toastStyle,
  }) =>
      IDKitToast._showToast(
        context,
        ToastType.chrysanthemum,
        chrysanthemumStyle: chrysanthemumStyle,
        toastStyle: toastStyle,
      );

  /// Separate text toast
  static void showText(BuildContext context, String content,
          {ToastStyle toastStyle, SeparateTextStyle separateTextStyle}) =>
      IDKitToast._showToast(
        context,
        ToastType.text,
        content: content,
        toastStyle: toastStyle,
        separateTextStyle: separateTextStyle,
      );

  /// Loading and text toast
  static void showLoadingText(
    BuildContext context,
    String content, {
    ToastStyle toastStyle,
    SeparateTextStyle separateTextStyle,
    ChrysanthemumStyle chrysanthemumStyle,
  }) =>
      IDKitToast._showToast(
        context,
        ToastType.all,
        content: content,
        separateTextStyle: separateTextStyle,
        chrysanthemumStyle: chrysanthemumStyle,
        toastStyle: toastStyle,
      );

  /// Delete toast
  static void removeToast() {
    if (_overlayEntry == null) return;
    _overlayEntry.remove();
    _overlayEntry = null;
  }

  /// Private implementation popup function
  static void _showToast(
    BuildContext context,
    ToastType type, {
    String content,
    double time,
    ToastStyle toastStyle,
    SeparateTextStyle separateTextStyle,
    ChrysanthemumStyle chrysanthemumStyle,
  }) async {
    // build
    ToastStyle _style = toastStyle;
    if (_style == null) _style = _toastStyle;
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Material(
        color: _style.bgColor ?? _toastStyle.bgColor,
        child: _buildWidget(
          type,
          content: content,
          chrysanthemumStyle: chrysanthemumStyle,
          separateTextStyle: separateTextStyle,
          toastStyle: toastStyle,
        ),
      );
    });
    Overlay.of(context).insert(_overlayEntry);
    // Type judge
    if (type == ToastType.text) {
      // disapper time
      await Future.delayed(
          Duration(seconds: _style.disappearTime ?? _toastStyle.disappearTime),
          () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  // Get build widget
  static Widget _buildWidget(
    ToastType type, {
    ChrysanthemumStyle chrysanthemumStyle,
    String content,
    SeparateTextStyle separateTextStyle,
    ToastStyle toastStyle,
  }) {
    switch (type) {
      // Text build
      case ToastType.text:
        return buildSeparateText(
          content,
          toastStyle: toastStyle,
          separateTextStyle: separateTextStyle,
        );
        break;
      case ToastType.chrysanthemum:
        return buildChrysanthemumToast(
          toastStyle: toastStyle,
          chrysanthemumStyle: chrysanthemumStyle,
        );
        break;
      default:
        return buildChrysanthemumTextToast(
          content,
          chrysanthemumStyle: chrysanthemumStyle,
          separateTextStyle: separateTextStyle,
          toastStyle: toastStyle,
        );
    }
  }
}

/// Separate text toast type
class SeparateTextStyle extends Diagnosticable {
  const SeparateTextStyle({
    this.padding,
    this.maxWidthScale,
    this.maxHeightScale,
    this.textStyle,
  });

  // Inside margin of text
  final EdgeInsets padding;
  // Maximum width scale of toast frame
  final double maxWidthScale;
  // Maximum height scale of toast frame
  final double maxHeightScale;
  // Toast text style
  final TextStyle textStyle;
}

// Separate text toast build
Widget buildSeparateText(
  String content, {
  ToastStyle toastStyle,
  SeparateTextStyle separateTextStyle,
  EdgeInsets margin,
}) {
  var statusHeight = MediaQueryData.fromWindow(window).padding.top;
  var _style = separateTextStyle;
  var _tStyle = toastStyle;
  if (_style == null) _style = _separateTextStyle;
  if (_tStyle == null) _tStyle = _toastStyle;
  return Center(
    child: Align(
      alignment: _tStyle.alignment ?? _toastStyle.alignment,
      child: Container(
        margin: margin ?? EdgeInsets.all(statusHeight),
        constraints: BoxConstraints(
          maxWidth: MediaQueryData.fromWindow(window).size.width *
              (_style.maxWidthScale ?? _separateTextStyle.maxWidthScale),
          maxHeight: MediaQueryData.fromWindow(window).size.height *
              (_style.maxHeightScale ?? _separateTextStyle.maxHeightScale),
        ),
        padding: _style.padding ?? _separateTextStyle.padding,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(_tStyle.radius ?? _toastStyle.radius),
          color: _tStyle.toastBgColor ?? _toastStyle.toastBgColor,
        ),
        child: Text(
          content,
          style: _style.textStyle ?? _separateTextStyle.textStyle,
        ),
      ),
    ),
  );
}

/// Chrysanthemum style
class ChrysanthemumStyle extends Diagnosticable {
  const ChrysanthemumStyle({
    this.color,
    this.activityColor,
    this.chrysanthemumMargin,
    this.lineWidth,
    this.centerOffset,
    this.marginOffset,
  });
  // Track default color
  final Color color;
  // Orbital active color
  final Color activityColor;
  // Track width
  final double lineWidth;
  // Distance between track and center of circle
  final double centerOffset;
  // Distance between track and outer boundary
  final double marginOffset;
  // EdgeInsets margin
  final EdgeInsets chrysanthemumMargin;
}

// Chrysanthemum widget build
Widget buildChrysanthemumToast({
  ChrysanthemumStyle chrysanthemumStyle,
  ToastStyle toastStyle,
}) {
  var _cStyle = chrysanthemumStyle;
  var _tStyle = toastStyle;
  if (_cStyle == null) _cStyle = _chrysanthemumStyle;
  if (_tStyle == null) _tStyle = _toastStyle;

  return Center(
    child: Container(
      margin: _cStyle.chrysanthemumMargin ??
          _chrysanthemumStyle.chrysanthemumMargin,
      decoration: BoxDecoration(
        color: _tStyle.toastBgColor ?? _toastStyle.toastBgColor,
        borderRadius:
            BorderRadius.circular(_tStyle.radius ?? _toastStyle.radius),
      ),
      child: IDKitActivityIndicator(
        bgColor: Colors.transparent,
        style: ActivityIndicatorStyle(
          color: _cStyle.color,
          activityColor: _cStyle.activityColor,
          lineWidth: _cStyle.lineWidth,
          offsetCenter: _cStyle.centerOffset,
          offsetMargin: _cStyle.marginOffset,
        ),
      ),
    ),
  );
}

/// Chrysanthemum and Text
Widget buildChrysanthemumTextToast(
  String content, {
  ToastStyle toastStyle,
  ChrysanthemumStyle chrysanthemumStyle,
  SeparateTextStyle separateTextStyle,
}) {
  var _tStyle = toastStyle;
  var _sStyle = separateTextStyle;
  var _cStyle = chrysanthemumStyle;
  if (_tStyle == null) _tStyle = _toastStyle;
  if (_sStyle == null) _sStyle = _separateTextStyle;
  if (_cStyle == null) _cStyle = _chrysanthemumStyle;

  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: _tStyle.toastBgColor ?? _toastStyle.toastBgColor,
        borderRadius:
            BorderRadius.circular(_tStyle.radius ?? _toastStyle.radius),
      ),
      child: UnconstrainedBox(
        child: Column(
          children: <Widget>[
            Center(
              child: buildChrysanthemumToast(
                chrysanthemumStyle: ChrysanthemumStyle(
                  color: _cStyle.color,
                  activityColor: _cStyle.activityColor,
                  lineWidth: _cStyle.lineWidth,
                  centerOffset: _cStyle.centerOffset,
                  marginOffset: _cStyle.marginOffset,
                  chrysanthemumMargin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                ),
                toastStyle: ToastStyle(
                  toastBgColor: Colors.transparent,
                ),
              ),
            ),
            Center(
              child: buildSeparateText(
                content,
                separateTextStyle: SeparateTextStyle(
                  padding: EdgeInsets.zero,
                  maxHeightScale: _sStyle.maxHeightScale,
                  maxWidthScale: _sStyle.maxWidthScale,
                  textStyle: _sStyle.textStyle,
                ),
                toastStyle: ToastStyle(
                  toastBgColor: Colors.transparent,
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 8),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
