import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

String getTimeAgo(String dateString) {
  final dateTime = DateTime.parse(dateString);
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays >= 365) {
    final years = (difference.inDays / 365).floor();
    return '$years 年前';
  } else if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    return '$months 個月前';
  } else if (difference.inDays >= 7) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks 周前';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} 天前';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} 小時前';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} 分鐘前';
  } else {
    return '剛剛';
  }
}

String formatNumber(int number) {
  if (number >= 10000) {
    double result = number / 10000;
    return '${result.toStringAsFixed(1)}万';
  } else if (number >= 1000) {
    double result = number / 1000;
    return '${result.toStringAsFixed(1)}千';
  } else {
    return number.toString();
  }
}

Color getRandomColor() {

  // 生成随机的 RGB 颜色值
  int r = Random().nextInt(256);
  int g = Random().nextInt(256);
  int b = Random().nextInt(256);

  // 返回随机颜色
  return Color.fromRGBO(r, g, b, 1);
}