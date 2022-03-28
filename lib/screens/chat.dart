import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String Course='Deep Learning';
  

  CollectionReference<Map<String, dynamic>> user= FirebaseFirestore.instance.collection('user')
  .doc('group').collection('g_ids');

 
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    SizedBox(height: 40,),
                    ElevatedButton(onPressed : () async
                    {
                      await user.add({
                        'course':Course,
                        'name':'Kalpita'
                        
                      }).then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
                    }, child: Text('Add')),
                    
                  ],
                ),
                
              ),
                
              
            ),
          ],
        ),
      ),
    );
  }
}


class Database {
   DocumentReference<Map<String, dynamic>> course= FirebaseFirestore.instance.collection('courses')
  .doc('Data Science');
 //to get the data

 Stream<DocumentSnapshot<Map<String, dynamic>>> get courses{
   return course.snapshots();
 }
  

}