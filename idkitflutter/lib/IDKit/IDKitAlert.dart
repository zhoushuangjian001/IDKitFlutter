import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Alert enumeration type
enum AlertType {
  alert,
  sheetAlert,
}

/// Alert style class
class AlertStyle with Diagnosticable {
  const AlertStyle({
    this.bgColor,
    this.radius,
    this.divideLineColor,
    this.titleStyle,
    this.contentStyle,
    this.actionsStyle,
  });
  // Background color
  final Color bgColor;
  // Corner cutting
  final double radius;
  // Split line color
  final Color divideLineColor;
  // Title Style
  final TextStyle titleStyle;
  // Content Style
  final TextStyle contentStyle;
  // Actions Style
  final List<TextStyle> actionsStyle;
}

/// Alert class
class IDKitAlert {
  // Mask definition
  static OverlayEntry _overlayEntry;
  // Default style definition
  static const AlertStyle _defaultStyle = AlertStyle(
    bgColor: Colors.white,
    radius: 6,
    divideLineColor: Colors.black38,
    titleStyle: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    contentStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    actionsStyle: [
      TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      TextStyle(
        fontSize: 16,
        color: Colors.blue,
      ),
    ],
  );

  // Alert Type method
  static void alert(
    BuildContext context, {
    Color color,
    AlertType type,
    String title,
    String content,
    List<String> actions,
    bool autoDisapper = false,
    AlertStyle style,
    Function(int) clickMethod,
  }) =>
      IDKitAlert._buildAlert(
        context,
        type,
        color: color,
        title: title,
        content: content,
        style: style,
        actions: actions,
        clickMethod: clickMethod,
        autoDisapper: autoDisapper,
      );

  // SheetAlert Type method
  static void sheetAlert(
    BuildContext context, {
    Color color,
    AlertType type,
    String title,
    String content,
    List<String> actions,
    bool autoDisapper = false,
    AlertStyle style,
    Function(int) clickMethod,
  }) =>
      _buildAlert(
        context,
        AlertType.sheetAlert,
        color: color,
        title: title,
        content: content,
        style: style,
        actions: actions,
        clickMethod: clickMethod,
        autoDisapper: false,
      );

  // Remove alert
  static void removeAlert() {
    _overlayEntry.remove();
    _overlayEntry = null;
  }

  // Private method to create alert
  static void _buildAlert(
    BuildContext context,
    AlertType type, {
    Color color,
    AlertStyle style,
    String title,
    String content,
    List<String> actions,
    bool autoDisapper,
    Function(int) clickMethod,
  }) {
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      var _style = style;
      if (_style == null) _style = _defaultStyle;
      return Material(
        color: color ?? Colors.black38,
        child: _buildWidget(
          type ?? AlertType.alert,
          title: title,
          style: AlertStyle(
            bgColor: _style.bgColor ?? _defaultStyle.bgColor,
            radius: _style.radius ?? _defaultStyle.radius,
            divideLineColor:
                _style.divideLineColor ?? _defaultStyle.divideLineColor,
            titleStyle: _style.titleStyle ?? _defaultStyle.titleStyle,
            contentStyle: _style.contentStyle ?? _defaultStyle.contentStyle,
            actionsStyle: _style.actionsStyle ?? _defaultStyle.actionsStyle,
          ),
          clickMethod: clickMethod,
          content: content,
          actions: actions,
        ),
      );
    });
    Overlay.of(context).insert(_overlayEntry);
    if (autoDisapper) {
      Future.delayed(Duration(seconds: 3), () {
        removeAlert();
      });
    }
  }
}

// Building widget
Widget _buildWidget(
  AlertType type, {
  AlertStyle style,
  String title,
  String content,
  List<String> actions,
  Function(int) clickMethod,
}) {
  Widget _widget;
  Size _size = MediaQueryData.fromWindow(window).size;
  if (type == AlertType.alert) {
    _widget = Center(
      child: UnconstrainedBox(
        child: Container(
          constraints: BoxConstraints(
            minHeight: 45,
          ),
          width: _size.width * 0.618,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: style.bgColor,
          ),
          child: _buildAlertWidget(
            title,
            content,
            actions,
            style,
            clickMethod,
          ),
        ),
      ),
    );
  } else {
    var _safebttom = MediaQueryData.fromWindow(window).padding.bottom;
    _widget = Align(
      alignment: Alignment.bottomCenter,
      child: UnconstrainedBox(
        child: Container(
          padding: EdgeInsets.only(bottom: _safebttom + 10),
          constraints: BoxConstraints(
            minHeight: 45,
          ),
          width: _size.width * 0.95,
          child: buildSheetAlert(title, content, actions, style, clickMethod),
        ),
      ),
    );
  }
  return _widget;
}

/// Build alert type widget
Widget _buildAlertWidget(
  String title,
  String content,
  List<String> actions,
  AlertStyle style,
  Function(int) clickMethod,
) {
  Widget _widget;
  List<Widget> _list = List();
  var isTitle = (title == null || title.length == 0);
  var isContent = (content == null || content.length == 0);
  var isActions = (actions == null || actions.length == 0);

  if (!isActions) {
    for (int i = 0; i < actions.length; i++) {
      var _actionStyle;
      try {
        _actionStyle = style.actionsStyle[i];
      } catch (e) {
        _actionStyle = TextStyle(
          fontSize: 16,
          color: Colors.blue,
        );
      }
      var title = actions[i];
      var item = GestureDetector(
        onTap: () => clickMethod(i),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            title,
            style: _actionStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
      if (i > 0 && i < actions.length) {
        _list.add(Container(
          width: 0.5,
          color: style.divideLineColor,
          height: 45,
        ));
      }
      _list.add(
        Expanded(child: item),
      );
    }
  }
  if (isTitle && isContent && isActions) {
    _widget = _buildNoDataWidget();
  } else if (isTitle && isContent) {
    _widget = Container(
      child: Row(
        children: _list,
      ),
    );
  } else if (isTitle) {
    _widget = Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              content,
              style: style.contentStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            color: style.divideLineColor,
            height: 1,
          ),
          Container(
            height: 45,
            child: Row(
              children: _list,
            ),
          ),
        ],
      ),
    );
  } else if (isContent) {
    _widget = Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              title,
              style: style.titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            color: style.divideLineColor,
            height: 1,
          ),
          Container(
            height: 45,
            child: Row(
              children: _list,
            ),
          ),
        ],
      ),
    );
  } else {
    _widget = Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text(
                title,
                style: style.titleStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
              child: Text(
                content,
                style: style.contentStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(
            color: style.divideLineColor,
            height: 1,
          ),
          Row(
            children: _list,
          ),
        ],
      ),
    );
  }
  return _widget;
}

/// Build sheetAlert type widget
Widget buildSheetAlert(
  String title,
  String content,
  List<String> actions,
  AlertStyle style,
  Function(int) clickMethod,
) {
  Widget _widget;
  var isTitle = (title == null || title.length == 0);
  var isContent = (content == null || content.length == 0);
  var isActions = (actions == null || actions.length == 0);

  if (isActions && isTitle && isContent) {
    _widget = _buildNoDataWidget();
  } else if (isTitle && isContent) {
    _widget = Container(
      child: actions.length == 1
          ? _buildSheetMiddleWidget(actions, style, clickMethod)
          : Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: style.bgColor,
                    borderRadius: BorderRadius.circular(style.radius),
                  ),
                  child: _buildSheetMiddleWidget(actions, style, clickMethod),
                ),
                SizedBox(
                  height: 15,
                ),
                _biuldSheetItem(
                  actions.last,
                  style.actionsStyle.last,
                  actions.length - 1,
                  clickMethod,
                  radius: style.radius,
                  color: style.bgColor,
                ),
              ],
            ),
    );
  } else if (isActions) {
    _widget = Container(
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(style.radius),
      ),
      child: _buildSheetTopWidget(title, content, style),
    );
  } else {
    _widget = Container(
      child: Column(
        children: actions.length == 1
            ? <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: style.bgColor,
                    borderRadius: BorderRadius.circular(style.radius),
                  ),
                  child: _buildSheetTopWidget(
                    title,
                    content,
                    style,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _buildSheetMiddleWidget(
                  actions,
                  style,
                  clickMethod,
                ),
              ]
            : <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: style.bgColor,
                    borderRadius: BorderRadius.circular(style.radius),
                  ),
                  child: Column(
                    children: <Widget>[
                      _buildSheetTopWidget(
                        title,
                        content,
                        style,
                      ),
                      Divider(
                        height: 0.5,
                        color: style.divideLineColor,
                      ),
                      _buildSheetMiddleWidget(
                        actions,
                        style,
                        clickMethod,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _biuldSheetItem(
                  actions.last,
                  style.actionsStyle.last,
                  actions.length - 1,
                  clickMethod,
                  radius: style.radius,
                  color: style.bgColor,
                ),
              ],
      ),
    );
  }
  return _widget;
}

/// Build sheetAlert type top view
Widget _buildSheetTopWidget(
  String title,
  String content,
  AlertStyle style,
) {
  Widget _widget;
  var isTitle = (title == null || title.length == 0);
  var isContent = (content == null || content.length == 0);
  if (isTitle || isContent) {
    _widget = Container(
      padding: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          isTitle == true ? content : title,
          style: isTitle == true ? style.contentStyle : style.titleStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  } else {
    _widget = Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                title,
                style: style.titleStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Center(
              child: Text(
                content,
                style: style.contentStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
  return _widget;
}

/// Build without data prompt widget
Widget _buildNoDataWidget() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Align(
      child: Text(
        "你不传数据，我咋展示！",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    height: 60,
  );
}

/// Build the middle widget of sheetalert
Widget _buildSheetMiddleWidget(
  List<String> actions,
  AlertStyle style,
  Function(int) clickMethod,
) {
  Widget _widget;
  if (actions.length == 1) {
    _widget = Container(
      child: _biuldSheetItem(
        actions.last,
        style.actionsStyle.last,
        0,
        clickMethod,
        color: style.bgColor,
        radius: style.radius,
      ),
    );
  } else {
    List<Widget> _listWidget = List();
    for (int i = 0; i < actions.length - 1; i++) {
      var _title = actions[i];
      var _style;
      try {
        _style = style.actionsStyle[i];
      } catch (err) {
        _style = TextStyle(
          fontSize: 18,
          color: Colors.blue,
        );
      }
      var _item = _biuldSheetItem(_title, _style, i, clickMethod);
      var _divider = Divider(
        height: 0.5,
        color: style.divideLineColor,
      );
      if (i >= 1 && i < actions.length - 1) _listWidget.add(_divider);
      _listWidget.add(_item);
      _widget = Column(
        children: _listWidget,
      );
    }
  }
  return _widget;
}

/// Building a touchable module of sheetalert
Widget _biuldSheetItem(
  String content,
  TextStyle style,
  int index,
  Function(int) clickMethod, {
  double radius,
  Color color,
}) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 0.0),
        color: color ?? Colors.transparent,
      ),
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          content,
          style: style,
        ),
      ),
    ),
    onTap: () {
      clickMethod(index);
      if (radius != null) IDKitAlert.removeAlert();
    },
  );
}
