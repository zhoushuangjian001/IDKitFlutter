import 'dart:ui';
import 'package:flutter/material.dart';

/// Device screen adaptation
class IDKitScreenFit {
  // Default parameter settings
  // Refer to the width and hieght of the UI design, the unit pixel.
  static num _referenceUIWidth = 1080.0;
  static num _referenceUIHeight = 1920.0;
  // Width and height of screen
  static double _screenWidth;
  static double _screenHeight;
  // Height of device status bar
  static double _statusBarHeight;
  // Height of device navigation bar
  static double _navigationBarHeight;
  // Safe distance at the bottom of equipment
  static double _safeBottomHeight;
  // Status navigation bar height
  static double _statusNavigationBarHeight;
  // Pixel density
  static double _pixelDensity;
  // Font magnification
  static double _fontScale;

  // Specify a simple chaung'jian reference to UI, unit px
  static void init({num referenceWidth, num referenceHeight}) {
    if (_instance == null) {
      _instance = _initInstance();
    }
    _referenceUIHeight = referenceHeight;
    _referenceUIWidth = referenceWidth;
  }

  // Create single interest to prevent multiple calls from generating multiple pairs of images
  static IDKitScreenFit _instance;
  factory IDKitScreenFit() => _initInstance();
  static IDKitScreenFit get instance => _initInstance();
  static IDKitScreenFit _initInstance() {
    if (_instance == null) {
      _instance = IDKitScreenFit._init();
    }
    return _instance;
  }

  IDKitScreenFit._init() {
    MediaQueryData _widow = MediaQueryData.fromWindow(window);
    _screenWidth = _widow.size.width;
    _screenHeight = _widow.size.height;
    _statusBarHeight = _widow.padding.top;
    _safeBottomHeight = _widow.padding.bottom;
    _pixelDensity = _widow.devicePixelRatio;
    _navigationBarHeight = 44.0;
    _statusNavigationBarHeight = _statusBarHeight + _navigationBarHeight;
    _fontScale = _widow.textScaleFactor;
  }

  /// Property's getter method
  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static double get statusBarHeight => _statusBarHeight;
  static double get safeBottomHeight => _safeBottomHeight;
  static double get navigationBarHeight => _navigationBarHeight;
  static double get statusNavigationBarHeight => _statusNavigationBarHeight;
  static double get pixelDensity => _pixelDensity;

  /// Width adaptation method
  static double widthFit(double width) =>
      (_screenWidth / _referenceUIWidth) * width * _pixelDensity;

  /// Height adaptation method
  static double heightFit(double height) =>
      (_screenHeight / _referenceUIHeight) * height * _pixelDensity;

  /// Font size adaptation
  static double fontFit(double fontsize, {bool autoFit = false}) =>
      autoFit == true
          ? (fontsize * _pixelDensity * (_screenWidth / _referenceUIWidth)) /
              _fontScale
          : fontsize * (_screenWidth / _referenceUIWidth) * _pixelDensity;
}
