import 'package:flutter/material.dart';
import 'package:reward_todo/widgets/task_tile.dart';
import 'package:reward_todo/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TasksList extends StatelessWidget {
  TasksList({this.showConfetti});

  final Function showConfetti;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .where('isDone', isEqualTo: false)
          .orderBy('point')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return TaskTile(
              taskId: document.id,
              title: document['title'],
              isDone: document['isDone'],
              point: document['point'],
              showConfetti: showConfetti,
            );
          }).toList(),
        );
      },
    );
  }
}
