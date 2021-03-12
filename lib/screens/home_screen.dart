import 'package:flutter/material.dart';
import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:reward_todo/screens/reward_screen.dart';
import 'package:reward_todo/widgets/tasks_list.dart';
import 'package:reward_todo/widgets/point_row.dart';
import 'package:reward_todo/widgets/input_task_dialog.dart';
import 'package:reward_todo/models/preferences.dart';

String uid;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  int _userPoint = 0;

  @override
  Widget build(BuildContext context) {
    getUserPoint().then((value) {
      setState(() {
        _userPoint = value;
      });
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Color(0xff74cfc1),
              ),
              onPressed: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return InputTaskDialog(
                      isAddTask: true,
                    );
                  },
                );
              },
            ),
          ),
          title: Center(
            child: Column(
              children: [
                Text(
                  'やることリスト',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(
                  width: 120.0,
                  child: Hero(
                    tag: 'point',
                    child: PointRow(
                      point: _userPoint,
                    ),
                  ),
                ),
                SizedBox(
                  height: Platform.isAndroid ? 0.0 : 10.0,
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(
                  Icons.card_giftcard,
                  color: Color(0xff74cfc1),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return RewardScreen(_userPoint);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SafeArea(
              child: TasksList(
                showConfetti: () {
                  _confettiController.play();
                },
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.03,
              numberOfParticles: 15,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ],
        ),
      ),
    );
  }
}
