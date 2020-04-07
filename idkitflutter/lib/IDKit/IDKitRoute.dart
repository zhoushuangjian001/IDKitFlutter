import 'package:flutter/material.dart';

class IDKitRoute {
  /// Property settings
  // Hashcode value
  String hashMark;
  // Route configuration map
  Map _routesMap;
  // Back to the barrier
  bool _popBarrier;

  /// Create a single interest object
  static IDKitRoute _instance;
  factory IDKitRoute() => _initInstance();
  static IDKitRoute _initInstance() {
    if (_instance == null) {
      _instance = IDKitRoute._init();
    }
    return _instance;
  }

  IDKitRoute._init() {
    hashMark = "IDKit";
    _popBarrier = false;
  }

  /// Route extension methods
  // Registered Routes
  registeredRoutes(Map map) {
    _routesMap = map;
  }

  // Get route delivery parameters
  static RouteMap getRouteMap(BuildContext context) {
    return ModalRoute.of(context).settings.arguments;
  }

  // Get the name of the current route
  static String getRouteName(BuildContext context) {
    return ModalRoute.of(context).settings.name;
  }

  // Binding route
  static bindingRoutes(RouteSettings settings) {
    final _routeName = settings.name;
    final Function _routeBuilder = _instance._routesMap[_routeName];
    if (_routeBuilder != null) {
      return MaterialPageRoute(
        builder: (context) => _routeBuilder(context),
        settings: settings,
      );
    }
  }

  // No corresponding routing exception page was found in route jump.
  static unknownRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Route Jump Fail"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "No corresponding routing exception page was found in route jump.\n 路由跳转没有找到对应的路由。",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// Routing and rollback methods
  // Push Route Method
  static pushRoute(
    BuildContext context,
    String routeName, {
    RouteMap routeMap,
    Function(dynamic) completeCallback,
  }) {
    Navigator.of(context)
        .pushNamed(routeName, arguments: routeMap)
        .then((onValue) {
      completeCallback(onValue);
    });
  }

  // Push Route And pop root push
  static pushRouteAndPopRootRoute(
    BuildContext context,
    String routeName, {
    RouteMap routeMap,
    Function(dynamic) completeCallback,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (Route<dynamic> route) => route.isFirst,
      arguments: routeMap,
    );
  }

  // Remove the current route and push to the next route
  static pushRouteAndRemoveCurRoute(
    BuildContext context,
    String routeName, {
    RouteMap routeMap,
  }) {
    Navigator.of(context).pushReplacementNamed(
      routeName,
      arguments: routeMap,
    );
  }

  // Pop Route Method
  static popRoute(
    BuildContext context, {
    dynamic backInfo,
  }) {
    var isCan = Navigator.canPop(context);
    if (isCan) {
      Navigator.of(context).pop(backInfo);
    }
  }

  // Fallback to root route
  static popRootRoute(BuildContext context) {
    var isCan = Navigator.canPop(context);
    if (isCan) {
      Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
    }
  }

  // Rollback to a certain route
  static popCertainRoute(BuildContext context, String routeName) {
    _instance._popBarrier = false;
    if (routeName.length == 0 || routeName == null)
      throw "Route name cannot be empty and a string of length 0.";
    Navigator.maybePop(context).then((maybePop) {
      if (maybePop) {
        Navigator.of(context).popUntil((Route<dynamic> route) {
          if (_instance._popBarrier) {
            return true;
          } else {
            if (route.settings.name == routeName) {
              _instance._popBarrier = true;
              return true;
            }
            return false;
          }
        });
      } else {
        throw "Cannot fallback to a route because it is not in the routing stack.";
      }
    });
  }
}

/// Spezifikation des Routing-Parameters
/// Type
enum MapType {
  _int,
  _double,
  _list,
  _string,
  _bool,
  _map,
}

/// Route delivery parameter configuration
class RouteMap {
  // Parameter attribute determinacy through map
  Map<String, dynamic> _idkitMap = {};
  // Map setter method
  _setValueForKey(String key, dynamic value) => _idkitMap[key] = value;
  // Map getter method
  _getValueForKey(String key) {
    // Is the detected key stored in the test
    if (_idkitMap.containsKey(key)) {
      return _idkitMap[key];
    }
    throw Exception("This key is not in map, Please check it.");
  }

  // Get the specified type add property processing
  _handleValueForKey(String key, MapType type) {
    var _value = _getValueForKey(key);
    if (type == MapType._int) {
      if (!(_value is int)) {
        _value = int.parse(_value.toString());
      }
    } else if (type == MapType._double) {
      if (!(_value is double)) {
        _value = double.parse(_value.toString());
      }
    } else if (type == MapType._bool) {
      if (!(_value is bool)) {
        _value = _value == null ? false : true;
      }
    } else if (type == MapType._list) {
      if (!(_value is List)) {
        _value = [_value.toString()];
      }
    } else if (type == MapType._string) {
      if (!(_value is String)) {
        _value = _value.toString();
      }
    } else if (type == MapType._map) {
      if (!(_value is Map)) {
        _value = {"key": "Cannot convert to map."};
      }
    }
    return _value;
  }

  // Specify type add property
  addParamInt(String key, int value) => _setValueForKey(key, value);
  addParamDouble(String key, double value) => _setValueForKey(key, value);
  addParamNum(String key, num value) => _setValueForKey(key, value);
  addParamString(String key, String value) => _setValueForKey(key, value);
  addParamBool(String key, bool value) => _setValueForKey(key, value);
  addParamList<T>(String key, List<T> value) => _setValueForKey(key, value);
  addParamMap<K, V>(String key, Map<K, V> value) => _setValueForKey(key, value);
  addParamDynamic(String key, dynamic value) => _setValueForKey(key, value);

  // Gets the attribute of the specified type
  int getValueInt(String key) => _handleValueForKey(key, MapType._int);
  double getValueDouble(String key) => _handleValueForKey(key, MapType._double);
  String getValueString(String key) => _handleValueForKey(key, MapType._string);
  bool getValueBool(String key) => _handleValueForKey(key, MapType._bool);
  List getValueList(String key) => _handleValueForKey(key, MapType._list);
  Map getValueMap(String key) => _handleValueForKey(key, MapType._map);

  // Map output as string
  @override
  String toString() {
    return _idkitMap.toString();
  }
}
