import 'package:flutter/material.dart';

class Button {
  static InkWell loginButton({color, title, icon, tap, required size}) {
    return InkWell(
      onTap: tap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          gradient: LinearGradient(
            colors: color,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        height: 60,
        width: size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: icon),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20)),
            const Text("            ")
          ],
        ),
      ),
    );
  }
}
