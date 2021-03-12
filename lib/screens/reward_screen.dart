import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';
import 'package:reward_todo/widgets/point_row.dart';
import 'package:reward_todo/models/preferences.dart';
import 'package:reward_todo/widgets/custom_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RewardScreen extends StatefulWidget {
  static const String id = 'reward_screen';

  RewardScreen(this._givenUserPoint);
  final int _givenUserPoint;

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  ConfettiController _confettiController;

  StreamController<int> selected = StreamController<int>();
  int onEndedSelected;
  int shownSelected;
  int _userPoint = 0;
  bool spinning = false;

  List<String> _rewards = ['a', 'b'];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _userPoint = widget._givenUserPoint ?? 0;
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    selected.close();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    getRewardList().then((value) {
      setState(() {
        _rewards = value;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Hero(
            tag: 'point',
            child: Transform.scale(
              scale: 1.4,
              child: PointRow(
                point: _userPoint,
              ),
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: 70.0,
            child: FlatButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return CustomDialog(
                        title: 'ご褒美一覧',
                        hasPadding: false,
                        actions: [
                          Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: IconButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      String rewardTitle = '';

                                      return CustomDialog(
                                        title: '新しいご褒美',
                                        body: Column(
                                          children: [
                                            TextField(
                                              decoration: InputDecoration(
                                                labelText: 'タイトル',
                                              ),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'GenJyuuGothicX',
                                                letterSpacing: 2,
                                              ),
                                              maxLength: 12,
                                              textAlign: TextAlign.center,
                                              autofocus: true,
                                              onChanged: (value) {
                                                rewardTitle = value;
                                              },
                                            ),
                                            SizedBox(
                                              height: 36.0,
                                            ),
                                            RaisedButton(
                                              onPressed: () async {
                                                try {
                                                  setState(() {
                                                    _rewards.add(rewardTitle);
                                                    setRewardList(_rewards);
                                                  });
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  print('もう一度試してください。');
                                                }
                                              },
                                              color: Colors.teal,
                                              textColor: Colors.white,
                                              child: Text(
                                                '追加',
                                                style: TextStyle(
                                                  fontFamily: 'GenJyuuGothicX',
                                                  letterSpacing: 3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.add,
                                size: 20.0,
                                color: Color(0xff74cfc1),
                              ),
                              splashRadius: 28.0,
                            ),
                          ),
                        ],
                        body: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              final String reward = _rewards[index];

                              return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.2,
                                child: Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[700],
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      reward,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'GenJyuuGothicX',
                                        color: Colors.white,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                  ),
                                ),
                                secondaryActions: _rewards.length > 2
                                    ? [
                                        IconSlideAction(
                                          caption: '削除',
                                          color: Colors.red,
                                          icon: Icons.close,
                                          onTap: () {
                                            try {
                                              setState(() {
                                                _rewards.removeWhere(
                                                    (t) => t == reward);
                                                setRewardList(_rewards);
                                              });
                                            } catch (e) {
                                              print('e');
                                            }
                                          },
                                        )
                                      ]
                                    : null,
                              );
                            },
                            itemCount: _rewards.length,
                          ),
                        ),
                      );
                    });
                  },
                );
              },
              child: Text('編集'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight - 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenWidth - 24.0,
                        child: FortuneWheel(
                          animateFirst: false,
                          duration: Duration(seconds: 4),
                          rotationCount: 10,
                          physics: CircularPanPhysics(
                            duration: Duration(seconds: 1),
                            curve: Curves.decelerate,
                          ),
                          selected: selected.stream,
                          items: [
                            for (var str in _rewards)
                              FortuneItem(
                                child: Text(str),
                              ),
                          ],
                          onAnimationEnd: () {
                            setState(() {
                              shownSelected = onEndedSelected;
                            });
                            _confettiController.play();
                          },
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: screenWidth - 24.0,
                        color: Colors.transparent,
                      ),
                    ],
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
              Text(
                shownSelected == null ? '' : _rewards[shownSelected],
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'GenJyuuGothicX',
                  letterSpacing: 3,
                ),
              ),
              RaisedButton(
                onPressed: _userPoint >= 100 && !spinning
                    ? () async {
                        final int randomInt = Random().nextInt(_rewards.length);
                        setState(() {
                          _userPoint = _userPoint - 100;
                          changeUserPoint(-100);
                          selected.add(
                            randomInt,
                          );
                          onEndedSelected = randomInt;
                          spinning = true;
                        });
                        await Future.delayed(Duration(seconds: 6));
                        setState(() {
                          spinning = false;
                        });
                      }
                    : null,
                color: Colors.teal.shade800,
                textColor: Colors.white,
                child: SizedBox(
                  width: 120,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ご褒美をもらう',
                        style: TextStyle(
                          fontFamily: 'GenJyuuGothicX',
                          letterSpacing: 3,
                        ),
                      ),
                      PointRow(
                        point: 100,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
