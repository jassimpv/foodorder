import 'package:flutter/material.dart';

class Inputfield {
  static Padding textForm(controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey)),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: " Mobile Number",
              prefix: Text('  +91  ')),
          controller: controller,
        ),
      ),
    );
  }
}
