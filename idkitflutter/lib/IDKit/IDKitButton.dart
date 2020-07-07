import 'dart:ui';
import 'package:flutter/material.dart';

/// Direction of buttons icons
enum IconDirection {
  left_r,
  top_b,
  right_l,
  bottom_t,
}

class IDKitButton extends StatefulWidget {
  IDKitButton({
    Key key,
    this.title,
    this.style,
    this.image,
    Size imageSize,
    this.bgColor,
    this.bgImage,
    this.radius,
    this.radiusBorders,
    this.borderSide,
    double spaceBetweenIconAndText,
    IconDirection iconDirection,
    this.callClick,
    this.callLongClick,
    this.callDownClick,
    this.callCancleClick,
    EdgeInsets margin,
  })  : iconDirection = iconDirection ?? IconDirection.left_r,
        imageSize = imageSize ?? Size(40, 40),
        spaceBetweenIconAndText = spaceBetweenIconAndText ?? 10,
        margin = margin ?? EdgeInsets.all(10),
        super(key: key);

  // Button text
  final String title;
  // Style of button text
  final TextStyle style;
  // Button icon
  final ImageProvider<dynamic> image;
  // Size of button icon
  final Size imageSize;
  // Background color of button
  final Color bgColor;
  // Background image of button
  final ImageProvider<dynamic> bgImage;
  // Button corner cutting
  final double radius;
  // Button vertex setting
  final Map<VertexType, double> radiusBorders;
  // Configuration of button sideline
  final BorderSide borderSide;
  // Direction of button icon
  final IconDirection iconDirection;
  // Space between icon and text
  final double spaceBetweenIconAndText;
  // Element to border distance
  final EdgeInsets margin;
  // Single click event callback
  final Function callClick;
  // Long click event callback
  final Function callLongClick;
  // Button press event callback
  final ValueChanged callDownClick;
  // Button event cancel callback
  final Function callCancleClick;

  _IDKitButton createState() => _IDKitButton();
}

class _IDKitButton extends State<IDKitButton> {
  // Default data settings
  var _defaultBorder = Border();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: widget.bgColor ?? Colors.transparent,
          image: widget.bgImage != null
              ? DecorationImage(
                  image: widget.bgImage,
                  fit: BoxFit.cover,
                )
              : null,
          border: widget.borderSide != null
              ? Border.all(
                  color: widget.borderSide.color ?? Colors.transparent,
                  style: widget.borderSide.style ?? BorderStyle.none,
                  width: widget.borderSide.width ?? 1,
                )
              : _defaultBorder,
          borderRadius: _choiceRadiusGeometry(
            widget.radiusBorders,
            widget.radius,
          ),
        ),
        child: _buildMainWidget(
          widget.image,
          widget.imageSize,
          widget.title,
          widget.style,
          widget.iconDirection,
          widget.spaceBetweenIconAndText,
          widget.margin,
        ),
      ),
      onTapDown: (details) {
        if (widget.callDownClick != null) widget.callClick(details);
      },
      onTap: () {
        if (widget.callClick != null) widget.callClick();
      },
      onLongPress: () {
        if (widget.callLongClick != null) widget.callLongClick();
      },
      onTapCancel: () {
        if (widget.callCancleClick != null) widget.callCancleClick();
      },
    );
  }
}

Widget _buildMainWidget(
  ImageProvider<dynamic> image,
  Size imageSize,
  String title,
  TextStyle style,
  IconDirection iconDirection,
  double spaceBetweenIconAndText,
  EdgeInsets margin,
) {
  Widget _widget;
  var isImage = (image == null);
  var isTitle = (title == null || title.length == 0);
  if (isImage && isTitle) {
    _widget = Container();
  } else if (isImage) {
    _widget = _buildTextWidget(title, style, margin);
  } else if (isTitle) {
    _widget = _buildImageWidget(image, imageSize, margin);
  } else {
    _widget = _biuldWidget(
      image,
      imageSize,
      title,
      style,
      iconDirection,
      spaceBetweenIconAndText,
      margin,
    );
  }
  return _widget;
}

/// Create button main widget
Widget _biuldWidget(
  ImageProvider<dynamic> image,
  Size imageSize,
  String title,
  TextStyle style,
  IconDirection iconDirection,
  double spaceBetweenIconAndText,
  EdgeInsets margin,
) {
  Widget _widget;
  if (iconDirection == IconDirection.left_r) {
    _widget = Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildImageWidget(image, imageSize, EdgeInsets.zero),
          SizedBox(
            width: spaceBetweenIconAndText,
          ),
          _buildTextWidget(title, style, EdgeInsets.zero),
        ],
      ),
    );
  } else if (iconDirection == IconDirection.right_l) {
    _widget = Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTextWidget(title, style, EdgeInsets.zero),
          SizedBox(
            width: spaceBetweenIconAndText,
          ),
          _buildImageWidget(image, imageSize, EdgeInsets.zero),
        ],
      ),
    );
  } else if (iconDirection == IconDirection.bottom_t) {
    _widget = Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTextWidget(title, style, EdgeInsets.zero),
          SizedBox(
            height: spaceBetweenIconAndText,
          ),
          _buildImageWidget(image, imageSize, EdgeInsets.zero),
        ],
      ),
    );
  } else {
    _widget = Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildImageWidget(image, imageSize, EdgeInsets.zero),
          SizedBox(
            height: spaceBetweenIconAndText,
          ),
          _buildTextWidget(
            title,
            style,
            EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
  return _widget;
}

/// Create button text widget
Widget _buildTextWidget(
  String title,
  TextStyle style,
  EdgeInsets margin,
) {
  return Container(
    margin: margin,
    alignment: Alignment.center,
    child: Text(
      title,
      style: style ??
          TextStyle(
            fontSize: 18,
            color: Colors.blue,
          ),
      textAlign: TextAlign.center,
    ),
  );
}

/// Create button image widget
Widget _buildImageWidget(
  ImageProvider<dynamic> image,
  Size imageSize,
  EdgeInsets margin,
) {
  return UnconstrainedBox(
    child: Container(
      margin: margin,
      width: imageSize.width,
      height: imageSize.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

/// Border side type
enum SideType {
  left,
  top,
  right,
  bottom,
}

enum SideConfig {
  color,
  width,
  style,
}

/// The choice of button sideline
BoxBorder _choiceBorder(Map<SideType, Map<SideConfig, dynamic>> borderSides) {
  BoxBorder _boxBorder;
  if (borderSides == null) {
    _boxBorder = Border.all(
      style: BorderStyle.none,
      width: 0,
      color: Colors.transparent,
    );
  } else {
    // Check null value
    dynamic _inspectNull(List<dynamic> list) {
      var _map;
      if (borderSides == null) {
        _map = null;
      } else {
        var _tMap = borderSides[list.first];
        if (_tMap == null) {
          _map = null;
        } else {
          _map = _tMap[list.last] ?? null;
        }
      }
      return _map;
    }

    _boxBorder = Border(
      top: BorderSide(
        color: _inspectNull([SideType.top, SideConfig.color]) ??
            Colors.transparent,
        width: _inspectNull([SideType.top, SideConfig.width]) ?? 1,
        style:
            _inspectNull([SideType.top, SideConfig.style]) ?? BorderStyle.none,
      ),
      left: BorderSide(
        color: _inspectNull([SideType.left, SideConfig.color]) ??
            Colors.transparent,
        width: _inspectNull([SideType.left, SideConfig.width]) ?? 1,
        style:
            _inspectNull([SideType.left, SideConfig.style]) ?? BorderStyle.none,
      ),
      right: BorderSide(
        color: _inspectNull([SideType.right, SideConfig.color]) ??
            Colors.transparent,
        width: _inspectNull([SideType.right, SideConfig.width]) ?? 1,
        style: _inspectNull([SideType.right, SideConfig.style]) ??
            BorderStyle.none,
      ),
      bottom: BorderSide(
        color: _inspectNull([SideType.bottom, SideConfig.color]) ??
            Colors.transparent,
        width: _inspectNull([SideType.bottom, SideConfig.width]) ?? 1,
        style: _inspectNull([SideType.bottom, SideConfig.style]) ??
            BorderStyle.none,
      ),
    );
  }
  return _boxBorder;
}

/// Vertex type
enum VertexType {
  bottomLeft,
  topLeft,
  bottomRight,
  topRight,
}

/// Button chamfer selection
BorderRadiusGeometry _choiceRadiusGeometry(
    Map<VertexType, double> radiusBorders, double radius) {
  BorderRadiusGeometry _borderRadiusGeometry;
  var _borderRadius = (radiusBorders == null);
  var _radius = (radius == null || radius == 0);
  if (_borderRadius && _radius) {
    _borderRadiusGeometry = BorderRadius.circular(0);
  } else if (_borderRadius) {
    _borderRadiusGeometry = BorderRadius.circular(radius);
  } else if (_radius) {
    _borderRadiusGeometry = BorderRadius.only(
      bottomLeft: Radius.circular(radiusBorders[VertexType.bottomLeft] ?? 0),
      topLeft: Radius.circular(radiusBorders[VertexType.topLeft] ?? 0),
      bottomRight: Radius.circular(radiusBorders[VertexType.bottomRight] ?? 0),
      topRight: Radius.circular(radiusBorders[VertexType.topRight] ?? 0),
    );
  } else {
    _borderRadiusGeometry = BorderRadius.only(
      bottomLeft:
          Radius.circular(radiusBorders[VertexType.bottomLeft] ?? radius),
      topLeft: Radius.circular(radiusBorders[VertexType.topLeft] ?? radius),
      bottomRight:
          Radius.circular(radiusBorders[VertexType.bottomRight] ?? radius),
      topRight: Radius.circular(radiusBorders[VertexType.topRight] ?? radius),
    );
  }
  return _borderRadiusGeometry;
}
