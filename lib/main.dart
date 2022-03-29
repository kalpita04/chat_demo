import 'package:chat/chatscreen.dart';


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: 
    "AIzaSyAky9SWuSMKD0vA26yGNxEVs5eDvNO3v2s",
     appId: " ",
      messagingSenderId: " ", projectId: "chat-516d4")
  );
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  static final String title = 'Firebase Chat';

  



  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: ChatScreen('username', 'name'),
      );
}

