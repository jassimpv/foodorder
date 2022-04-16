import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:foodorder/utility/utility.dart';
import 'package:http/http.dart' as http;

class DataFetch {
  static getfooddata() async {
    var url = Uri.parse('http://mocky.io/v2/5dfccffc310000efc8d2c1ad');

    var response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body)[0];

        var category = jsonResponse['table_menu_list'];
        return category;
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        Utility.showToast(msg: 'Check your Connectivity');
      }
    }
  }
}
