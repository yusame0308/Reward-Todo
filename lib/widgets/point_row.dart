import 'package:flutter/material.dart';

class PointRow extends StatelessWidget {
  PointRow({this.point});

  final int point;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.stars,
          color: Color(0xffb07df7),
          size: 14.0,
        ),
        SizedBox(
          width: 1.0,
        ),
        Text(
          point.toString(),
          style: TextStyle(
            color: Color(0xffb07df7),
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
