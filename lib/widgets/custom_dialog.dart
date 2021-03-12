import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog(
      {this.title = '', this.body, this.actions, this.hasPadding = true});

  final String title;
  final List<Widget> actions;
  final Widget body;
  final bool hasPadding;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      contentPadding: EdgeInsets.all(0.0),
      titlePadding: EdgeInsets.all(0.0),
      title: Container(
        height: 300.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 20.0,
                color: Colors.white,
              ),
              splashRadius: 28.0,
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                ),
              ),
            ),
            actions: actions ?? [],
          ),
          body: Container(
            padding: EdgeInsets.all(hasPadding ? 15.0 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Color(0xff2d273b),
            ),
            child: body,
          ),
        ),
      ),
    );
  }
}
