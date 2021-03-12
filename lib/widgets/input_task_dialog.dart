import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reward_todo/widgets/custom_dialog.dart';
import 'package:reward_todo/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class InputTaskDialog extends StatelessWidget {
  InputTaskDialog(
      {this.isAddTask, this.taskId, this.taskTitle = '', this.taskPoint = 30});

  final bool isAddTask;
  final String taskId;
  final String taskTitle;
  final int taskPoint;

  @override
  Widget build(BuildContext context) {
    String inputTaskTitle = taskTitle;
    String inputTaskPoint = taskPoint.toString();

    return CustomDialog(
      title: isAddTask ? '新しいタスク' : 'タスクの編集',
      body: Column(
        children: [
          TextField(
            controller: TextEditingController(text: inputTaskTitle),
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
              inputTaskTitle = value;
            },
          ),
          SizedBox(
            width: 80,
            child: TextField(
              controller: TextEditingController(text: inputTaskPoint),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                isDense: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 1.5),
                  child: Icon(
                    Icons.stars,
                    size: 16.0,
                    color: Color(0xffb07df7),
                  ),
                ),
                prefixIconConstraints: BoxConstraints(),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                color: Color(0xffb07df7),
                fontSize: 18.0,
              ),
              onChanged: (value) {
                inputTaskPoint = value;
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          RaisedButton(
            onPressed: () async {
              try {
                Navigator.pop(context);
                if (isAddTask) {
                  await _firestore.collection('tasks').add({
                    'uid': uid,
                    'title': inputTaskTitle,
                    'isDone': false,
                    'point': int.parse(inputTaskPoint),
                  });
                } else {
                  await _firestore.collection('tasks').doc(taskId).update({
                    'title': inputTaskTitle,
                    'point': int.parse(inputTaskPoint),
                  });
                }
              } catch (e) {
                print('もう一度試してください。');
              }
            },
            color: Colors.teal,
            textColor: Colors.white,
            child: Text(
              isAddTask ? '追加' : '保存',
              style: TextStyle(
                fontFamily: 'GenJyuuGothicX',
                letterSpacing: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
