import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'appColors.dart';

class Utility {
  static bool isDebug = false;

  static applog(String msg) {
    if (isDebug == true) {
      log(msg);
    }
  }

  static showToast({String? msg}) {
    Get.snackbar(isDebug ? msg.toString() : "unexpected Error", "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white);
  }

  static Widget progress(BuildContext context, {Color? color}) {
    return Container(
      alignment: Alignment.center,
      color: color ?? Colors.transparent,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            backgroundColor: AppColors.blackColor.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.blackColor),
          ),
        ),
      ),
    );
  }
}
