// Time format
enum TimeFormat {
  yyyyMMdd,
  yyyyMMddhhmmss, // hh:12
  yyyyMMddHHmmss, // HH:24
  yyyyMMddhhmm, // hh:12
  yyyyMMddHHmm, // HH:24
}

/// TIme Connector
enum TimeConnector {
  horizontalLine,
  obliqueLine,
}

class IDKitTimeUnit {
  // 时间戳转指定样式字符串
  static String formatDateStamp(String stamp,
      {TimeConnector connector, TimeFormat format}) {
    try {
      int value = int.parse(stamp);
      var date = DateTime.fromMillisecondsSinceEpoch(value);
      return IDKitTimeUnit.formatDate(date);
    } catch (err) {
      throw Exception("Timestamp conversion failed.");
    }
  }

  // 时间转指定样式的字符串
  /// Gets the time string of the specified style.
  static String formatDate(DateTime time,
      {TimeConnector connector, TimeFormat format}) {
    if (time != null) {
      String handleStr = '';
      if (connector != null && format != null) {
        handleStr = IDKitTimeUnit()._handleTime(time, connector, format);
      } else if (connector != null) {
        handleStr = IDKitTimeUnit()
            ._handleTime(time, connector, TimeFormat.yyyyMMddHHmmss);
      } else if (format != null) {
        handleStr = IDKitTimeUnit()
            ._handleTime(time, TimeConnector.horizontalLine, format);
      } else {
        handleStr = IDKitTimeUnit()._handleTime(
            time, TimeConnector.horizontalLine, TimeFormat.yyyyMMddHHmmss);
      }
      return handleStr;
    } else {
      throw Exception("Time cannot be null.");
    }
  }

  // 补位
  String _complementInt(int num, int bit) {
    var handleNum = "$num";
    if (handleNum.length < bit) {
      return "0" * (bit - handleNum.length) + handleNum;
    }
    return handleNum;
  }

  // Time handle
  String _handleTime(
    DateTime time,
    TimeConnector connector,
    TimeFormat format,
  ) {
    var resultFront = [];
    resultFront.add(time.year);
    resultFront.add(_complementInt(time.month, 2));
    resultFront.add(_complementInt(time.day, 2));

    var resultLast = [];
    if (format == TimeFormat.yyyyMMddHHmm ||
        format == TimeFormat.yyyyMMddhhmm) {
      resultLast.add(_complementInt(time.hour, 2));
      resultLast.add(_complementInt(time.minute, 2));
    } else if (format == TimeFormat.yyyyMMddHHmmss ||
        format == TimeFormat.yyyyMMddhhmmss) {
      resultLast.add(_complementInt(time.hour, 2));
      resultLast.add(_complementInt(time.minute, 2));
      resultLast.add(_complementInt(time.second, 2));
    }
    String result = "";
    if (connector == TimeConnector.obliqueLine) {
      result = resultFront.join('/') + " " + resultLast.join(':');
    } else {
      result = resultFront.join('-') + " " + resultLast.join(':');
    }
    resultFront.clear();
    resultLast.clear();
    return result;
  }

  // 简明的时间传
  /// The parameter passed in by this method cannot be a timestamp string. The types that can be passed are :
  /// 1. 20200222
  /// 2. 2020-02-12
  /// 3. 2020-02-12 10:12:34
  static String conciseTime(String time) {
    if (time != null) {
      DateTime dateTime;
      try {
        dateTime = DateTime.tryParse(time);
      } finally {
        try {
          int value = int.parse(time);
          dateTime = DateTime.fromMillisecondsSinceEpoch(value);
        } catch (err) {
          throw Exception("Time conversion failed.");
        }
      }
      // continue
      int timeMillisecond = dateTime.millisecondsSinceEpoch;
      int curMillisecond = DateTime.now().millisecondsSinceEpoch;
      int differenceValue = (timeMillisecond - curMillisecond).abs();
      // hour  minutes second day week mouth
      int secondValue = differenceValue ~/ 1000;
      int minutesValue = secondValue ~/ 60;
      int hourValue = minutesValue ~/ 60;
      int dayValue = hourValue ~/ 24;
      int weekValue = dayValue ~/ 7;
      int mouthValue = dayValue ~/ 30;
      var result = "";
      var resultTemp = "之前";
      if (curMillisecond < timeMillisecond) {
        resultTemp = "之后";
      }
      if (secondValue < 60) {
        result = resultTemp == "之后" ? "马上" : "刚刚";
      } else if (minutesValue > 0 && minutesValue < 60) {
        result = "$minutesValue 分钟" + resultTemp;
      } else if (hourValue > 0 && hourValue < 24) {
        result = "$hourValue 小时" + resultTemp;
      } else if (dayValue > 0 && dayValue < 2) {
        result = resultTemp == "之前" ? "昨天" : "明天";
      } else if (dayValue > 2 && dayValue < 3) {
        result = resultTemp == "之前" ? "前天" : "后天";
      } else if (dayValue > 3 && dayValue < 7) {
        result = "$dayValue 天" + resultTemp;
      } else if (weekValue > 0 && mouthValue == 0) {
        result = "$weekValue 周" + resultTemp;
      } else if (mouthValue > 1 && mouthValue < 6) {
        result = "$mouthValue 个月" + resultTemp;
      } else if (mouthValue == 6) {
        result = resultTemp == "之前" ? "半年之前" : "半年之后";
      } else {
        result = IDKitTimeUnit.formatDate(dateTime);
      }
      return result;
    } else {
      throw Exception("Time parameter cannot be empty.");
    }
  }
}
