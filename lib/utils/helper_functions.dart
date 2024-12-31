import 'package:AgriGuide/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

String formatTimestamp(BuildContext context, DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 1) {
    return LocaleData.justNow.getString(context);
  } else if (difference.inMinutes < 60) {
    return context.formatString(LocaleData.mAgo.getString(context), [difference.inMinutes]);
  } else if (difference.inHours < 24) {
    return context.formatString(LocaleData.hAgo.getString(context), [difference.inHours]);
  } else {
    return context.formatString(LocaleData.dAgo.getString(context), [difference.inDays]);
  }
}


String formatTimestamp2(BuildContext context, DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays == 0) {
    return LocaleData.today.getString(context);
  } else if (difference.inDays == 1) {
    return LocaleData.yesterday.getString(context);
  } else {
    return LocaleData.older.getString(context);
  }
}

