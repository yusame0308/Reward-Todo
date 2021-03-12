import 'package:flutter/material.dart';
import 'package:reward_todo/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reward_todo/models/preferences.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signInAnonymously();
    uid = _auth.currentUser.uid;
    initRewardList();
  } catch (e) {
    print(e);
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(RewardTodo());
}

class RewardTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xff2d273b),
        appBarTheme: AppBarTheme(
          color: Color(0xff2a263a),
        ),
        accentColor: Color(0xff74cfc1),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
