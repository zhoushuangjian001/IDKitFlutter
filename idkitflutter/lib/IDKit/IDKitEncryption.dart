import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

class IDKitEncryption {
  /// MD5 加密
  static String md5String(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  /// MD5 字符串的截取
  /// start: 字符串的开始位置
  /// end: 字符串结束的位置
  /// start & end 的参考点是 0.
  static String md5StringIntercept(String data, int start, [int end]) {
    String md5str = md5String(data);
    if (start < 0) {
      start = 0;
    } else if (start > md5str.length) {
      throw "Begin to intercept the length value of a string longer than MD5.";
    } else if (start > end && end != 0) {
      throw "The range of intercept length is at least 0, and cannot be negative.";
    } else if (end > md5str.length) {
      end = md5str.length;
    }
    return end == 0 ? md5str.substring(start) : md5str.substring(start, end);
  }

  /// MD5 指定长度字符串的截取
  /// start: 字符串的开始位置
  /// length: 要截取字符串的长度
  /// start 的参考点是 0.
  static String md5StringInterceptLength(String data, int start, [int length]) {
    String md5str = md5String(data);
    if (start < 0) {
      start = 0;
    } else if (start > md5str.length) {
      throw "Begin to intercept the length value of a string longer than MD5.";
    } else if ((start + length) > md5str.length) {
      length = md5str.length - start;
    } else if (length < 0) {
      length = 0;
    }
    return md5str.substring(start, start + length);
  }

  /// Base64 加密
  static String base64String(String data) {
    var content = Utf8Encoder().convert(data);
    return base64Encode(content);
  }

  static String base64Uint8List(Uint8List data) {
    return base64Encode(data);
  }

  /// Base64 解密
  static String base64StringDecode(String data) {
    var content = "";
    try {
      var utf8List = base64Decode(data);
      content = Utf8Decoder().convert(utf8List);
    } catch (err) {
      content = data;
    }
    return content;
  }

  /// 本地 Bundle 图片 Base64
  static Future<String> base64ImageBundle(String imagePath) async {
    ByteData byteData = await rootBundle.load(imagePath);
    Uint8List uint8List = byteData.buffer.asUint8List();
    String base64String = base64Encode(uint8List);
    return Future.value(base64String);
  }

  /// 本地图片 Base64
  static Future<String> base64Image(String imagePath) async {
    File _file = File(imagePath);
    _file.open();
    Uint8List uint8List = await _file.readAsBytes();
    String base64String = base64Encode(uint8List);
    return Future.value(base64String);
  }

  /// 加载 Base64 图像
  static Uint8List loadBase64Image(String data) {
    var utf8List;
    try {
      utf8List = base64Decode(data);
    } catch (err) {
      utf8List = Uint8List(0);
    }
    return utf8List;
  }

  /// SHA1 加密
  static String sha1String(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = sha1.convert(content);
    return hex.encode(digest.bytes);
  }

  /// SHA256 加密
  static String sha256String(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = sha256.convert(content);
    return hex.encode(digest.bytes);
  }

  /// SHA384 加密
  static String sha384String(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = sha384.convert(content);
    return hex.encode(digest.bytes);
  }

  /// SHA512 加密
  static String sha512String(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = sha512.convert(content);
    return hex.encode(digest.bytes);
  }
}
