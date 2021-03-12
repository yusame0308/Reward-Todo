import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reward_todo/screens/home_screen.dart';

// class Tasks {
//   List<String> _tasks;
//
//   void getTasks() {
//     _tasks = FirebaseFirestore.instance
//         .collection('tasks')
//         .where('uid', isEqualTo: uid)
//         .where('isDone', isEqualTo: false)
//         .orderBy('point');
//   }
// }

void changeUserPoint(int point) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int _newValue = (prefs.getInt('userPoint') ?? 0) + point;
  prefs.setInt('userPoint', _newValue);
}

Future<int> getUserPoint() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getInt('userPoint') ?? 0);
}

void initRewardList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getStringList('rewardList') == null) {
    prefs.setStringList('rewardList', ['ケーキ', 'チョコレート', 'アイスクリーム']);
  }
}

void setRewardList(List<String> rewardList) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('rewardList', rewardList);
}

Future<List<String>> getRewardList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('rewardList');
}
