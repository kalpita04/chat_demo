import 'package:chat/screens/chat.dart';
import 'package:chat/screens/home.dart';
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

  
   MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: ChatPage()
    );
  }
}

