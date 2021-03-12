import 'package:flutter/material.dart';
import 'package:reward_todo/widgets/point_row.dart';
import 'package:reward_todo/widgets/input_task_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reward_todo/models/preferences.dart';

final _firestore = FirebaseFirestore.instance;

class TaskTile extends StatelessWidget {
  TaskTile(
      {this.taskId, this.title, this.isDone, this.point, this.showConfetti});

  final String taskId;
  final String title;
  final bool isDone;
  final int point;
  final Function showConfetti;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: 60.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[700],
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'GenJyuuGothicX',
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            PointRow(point: point),
          ],
        ),
      ),
      actions: [
        IconSlideAction(
          caption: '完了',
          color: Colors.blue,
          icon: Icons.check,
          onTap: () {
            try {
              showConfetti();
              _firestore
                  .collection('tasks')
                  .doc(taskId)
                  .update({'isDone': true});
              changeUserPoint(point);
            } catch (e) {
              print(e);
            }
          },
        ),
        IconSlideAction(
          caption: '編集',
          color: Colors.indigo,
          icon: Icons.keyboard_control,
          onTap: () async {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return InputTaskDialog(
                  isAddTask: false,
                  taskId: taskId,
                  taskTitle: title,
                  taskPoint: point,
                );
              },
            );
          },
        )
      ],
      secondaryActions: [
        IconSlideAction(
          caption: '削除',
          color: Colors.red,
          icon: Icons.close,
          onTap: () {
            try {
              _firestore.collection('tasks').doc(taskId).delete();
            } catch (e) {
              print('e');
            }
          },
        )
      ],
    );
  }
}
