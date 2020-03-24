import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Style of IDKitSegmented
class SegmentedStyle extends Diagnosticable {
  const SegmentedStyle({
    this.unSelectedBgColor,
    this.selectedBgColor,
    this.unSelectedTextColor,
    this.selectedTextColor,
    this.unSelectedFontSize,
    this.selectedFontSize,
    this.radius,
    this.borderWidth,
    this.borderColor,
    this.height,
  });

  // The background color of item is checked and unchecked
  final Color unSelectedBgColor;
  final Color selectedBgColor;

  // The color when the text in the item is selected or unchecked.
  final Color unSelectedTextColor;
  final Color selectedTextColor;

  // Item text font of unselected size and selected size
  final double unSelectedFontSize;
  final double selectedFontSize;

  // The tangent value of the widget
  final double radius;

  //  The border width and color of the widget
  final double borderWidth;
  final Color borderColor;

  // Height of widget
  final double height;
}

class IDKitSegmented extends StatefulWidget {
  IDKitSegmented({
    Key key,
    this.items,
    this.itemActionClick,
    int defaultSelectedIndex,
    this.style,
    this.splitLineStyle,
    this.splitImage,
    this.splitImageFit,
  })  : assert(items != null, "items can't be null"),
        selectedIndex =
            (items.length < defaultSelectedIndex) ? 0 : defaultSelectedIndex,
        super(key: key);
  // List of items passed in by widget
  final List<String> items;

  // Callback function of item being clicked
  final Function(int index) itemActionClick;

  // Widget selects the item value by default.
  final int selectedIndex;

  /// Style of widget
  final SegmentedStyle style;

  /// Style of split line
  final SplitLineStyle splitLineStyle;

  /// image of split line
  final ImageProvider splitImage;

  /// image fit of split line
  final BoxFit splitImageFit;

  @override
  _IDKitSegmentedState createState() => _IDKitSegmentedState();
}

class _IDKitSegmentedState extends State<IDKitSegmented> {
  /// Set default value
  static const SegmentedStyle _defaultStyle = SegmentedStyle(
    unSelectedBgColor: Colors.white,
    selectedBgColor: Colors.blue,
    unSelectedTextColor: Colors.black,
    selectedTextColor: Colors.white,
    unSelectedFontSize: 16,
    selectedFontSize: 16,
    borderColor: Colors.black,
    borderWidth: 1,
    radius: 0,
    height: 30,
  );

  // State Record Map
  Map<String, dynamic> mapState = new Map();

  //  Data initialization
  @override
  void initState() {
    super.initState();
    widget.items.forEach((key) {
      var item = widget.items;
      int index = item.indexOf(key);
      mapState[key] = index == widget.selectedIndex;
    });
    if (widget.itemActionClick != null)
      widget.itemActionClick(widget.selectedIndex);
  }

  // Initializes element components
  List<Widget> buildItemsWidget(Map map, SegmentedStyle style) {
    var listState = map.values.toList();
    List<Widget> listWidget = new List();
    for (var i = 0; i < listState.length; i++) {
      var state = listState[i];
      var value = widget.items[i];
      var item = Item(
        selected: state,
        title: value,
        style: SegmentedStyle(
          unSelectedBgColor:
              style.unSelectedBgColor ?? _defaultStyle.unSelectedBgColor,
          selectedBgColor:
              style.selectedBgColor ?? _defaultStyle.selectedBgColor,
          unSelectedFontSize:
              style.unSelectedFontSize ?? _defaultStyle.unSelectedFontSize,
          selectedFontSize:
              style.selectedFontSize ?? _defaultStyle.selectedFontSize,
          selectedTextColor:
              style.selectedTextColor ?? _defaultStyle.selectedTextColor,
          unSelectedTextColor:
              style.unSelectedTextColor ?? _defaultStyle.unSelectedTextColor,
        ),
        itemActionClick: () => _handleItemsClick(value),
      );
      listWidget.add(Expanded(child: item));

      if (i != listState.length - 1) {
        var lineItem = SplitLine(
          style: widget.splitLineStyle,
          image: widget.splitImage,
          fit: widget.splitImageFit,
        );
        listWidget.add(lineItem);
      }
    }
    return listWidget;
  }

  // Element Click Event Processing Function
  void _handleItemsClick(String value) {
    List mapKeys = mapState.keys.toList();
    setState(() {
      mapKeys.forEach((f) {
        mapState[f] = f == value;
      });
    });
    //  Event callback
    if (widget.itemActionClick != null) {
      int index = mapKeys.indexOf(value);
      widget.itemActionClick(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    SegmentedStyle _style = widget.style ?? _defaultStyle;
    return Container(
      height: _style.height ?? _defaultStyle.height,
      decoration: BoxDecoration(
        border: Border.all(
          width: _style.borderWidth ?? _defaultStyle.borderWidth,
          color: _style.borderColor ?? _defaultStyle.borderColor,
        ),
        borderRadius:
            BorderRadius.circular(_style.radius ?? _defaultStyle.radius),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular((_style.radius ?? _defaultStyle.radius) - 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildItemsWidget(mapState, _style),
        ),
      ),
    );
  }
}

//  Item Widget Class
class Item extends StatelessWidget {
  Item({
    Key key,
    this.title,
    this.selected,
    this.style,
    this.itemActionClick,
  }) : super(key: key);

  final bool selected;
  final String title;
  final SegmentedStyle style;
  final Function itemActionClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color:
            selected == false ? style.unSelectedBgColor : style.selectedBgColor,
        child: Center(
          child: Text(
            title,
            maxLines: 1,
            style: TextStyle(
              color: selected == false
                  ? style.unSelectedTextColor
                  : style.selectedTextColor,
              fontSize: selected == false
                  ? style.unSelectedFontSize
                  : style.selectedFontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onTap: itemActionClick,
    );
  }
}

// Split line class
class SplitLine extends StatelessWidget {
  SplitLine({
    Key key,
    this.style,
    this.image,
    this.fit,
  }) : super(key: key);

  /// Style of split line
  final SplitLineStyle style;

  /// Image of split line and fit
  final BoxFit fit;
  final ImageProvider image;

  // Default Config
  static const SplitLineStyle _defaultStyle = SplitLineStyle(
    width: 1,
    height: double.infinity,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    SplitLineStyle _style = style ?? _defaultStyle;
    return Container(
      color: image != null ? null : (_style.color ?? _defaultStyle.color),
      width: _style.width ?? _defaultStyle.width,
      height: _style.height ?? _defaultStyle.height,
      decoration: image == null
          ? image
          : BoxDecoration(
              image: DecorationImage(
                image: image,
                fit: fit ?? BoxFit.cover,
              ),
            ),
    );
  }
}

/// Splity Style
class SplitLineStyle extends Diagnosticable {
  const SplitLineStyle({
    this.width,
    this.height,
    this.color,
  });

  final double width;
  final double height;
  final Color color;
}
