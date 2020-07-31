import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ListViewStyle with Diagnosticable {
  const ListViewStyle({
    this.bgColor,
  });

  /// backgroundcolor
  final Color bgColor;
}

class IDKitListView extends StatefulWidget {
  /// view of hearder
  final Widget headerWidget;

  /// view of fotter
  final Widget fotterWidget;

  /// item height
  final double itemHeight;

  /// height fixed
  final bool fixed;

  /// item count
  final int itemCount;

  /// item
  final Function(BuildContext context, int index) buildChildWidget;

  /// margin
  final EdgeInsetsGeometry margin;

  /// padding
  final EdgeInsetsGeometry padding;

  /// controller
  final ScrollController controller;

  /// style
  final ListViewStyle style;

  const IDKitListView({
    @required this.buildChildWidget,
    @required this.itemCount,
    this.headerWidget,
    this.fotterWidget,
    this.itemHeight = 44,
    this.fixed = true,
    this.margin,
    this.padding,
    this.controller,
    this.style,
    Key key,
  })  : assert(buildChildWidget != null,
            "Item callback function cannot be empty."),
        super(key: key);

  @override
  _IDKitListView createState() => _IDKitListView();
}

class _IDKitListView extends State<IDKitListView> {
  // 默认样式
  ListViewStyle defaultStyle = ListViewStyle(
    bgColor: Colors.white,
  );
  // 样式命名
  ListViewStyle _style;

  @override
  Widget build(BuildContext context) {
    _style = widget.style ?? defaultStyle;
    Widget child = widget.fixed == true
        ? SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) =>
                  widget.buildChildWidget(context, index),
              childCount: widget.itemCount,
            ),
            itemExtent: widget.itemHeight,
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) =>
                  widget.buildChildWidget(context, index),
              childCount: widget.itemCount,
            ),
          );
    return Container(
      margin: widget.margin ?? EdgeInsets.all(0),
      padding: widget.padding ?? EdgeInsets.all(0),
      color: _style.bgColor,
      child: CustomScrollView(
        controller: widget.controller,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: widget.headerWidget,
          ),
          child,
          SliverToBoxAdapter(
            child: widget.fotterWidget,
          ),
        ],
      ),
    );
  }
}
