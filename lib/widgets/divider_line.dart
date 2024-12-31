import 'package:AgriGuide/utils/appColors.dart';
import 'package:flutter/material.dart';

class DividerLine {
  horizontalDividerLine(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 1,
      width: width,
      color: AppColors.dividerLine,
      margin: const EdgeInsets.only(bottom: 10.0),
    );
  }
  verticalDividerLine(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    return Container(
      height: 50,
      width: 1,
      color: AppColors.dividerLine,
      margin: const EdgeInsets.only(bottom: 10.0),
    );
  }
}
