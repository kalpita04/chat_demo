import 'package:chat/chatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  CollectionReference abc = FirebaseFirestore.instance.collection('chatrooms');
   String title = 'Firebase Chat';
  // String userData= abc.id;
  

  



  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        
        home: chatscreen(
                                // chatRoomId: 'PAebTTuaISad9LIRgFUG',
                                // userData:userData?["name"]
                              ),
      );
}

