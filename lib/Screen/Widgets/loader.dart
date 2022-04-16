import 'package:flutter/material.dart';

class Loader {
  static CircularProgressIndicator cricle() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
    );
  }
}
