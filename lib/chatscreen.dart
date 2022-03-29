import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatscreen extends StatelessWidget {
  // final Map<String, dynamic>? userData;
  // final String? chatRoomId;
  // chatscreen({this.userData, this.chatRoomId});

  TextEditingController _message = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "message": _message.text,
        "sendBy":  "Kalpita"  ,                    //_auth.currentUser!.displayName,
        "time": FieldValue.serverTimestamp()
      };

      await _firestore
          .collection("chatrooms")
          .doc("chatRoomId")
          .collection("chats")
          .add(message);

      _message.clear();
    }
  }
  
 
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          padding: EdgeInsets.only(left: 0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_back),
                  )),
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('https://www.cloudyml.com/wp-content/uploads/2022/02/CLIENT_img-removebg-preview-4.png'),
              ),]
      ),
      
    ),
    ),
    body: SingleChildScrollView(
      child: Column(
          children: [
            Container(
              height: 20,
              child: StreamBuilder<QuerySnapshot>(stream : _firestore
                      .collection("chatrooms")
                      .doc("chatRoomId")
                      .collection("chats")
                      .orderBy("time", descending: false)
                      .snapshots(),
                       builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> messageData =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            
                            return messages( size, messageData);
                          });
                    } else {
                      return Container();
                    }
                  },
               ),
            ),
            Container(
              height: 1200,
              // width: 100,
              alignment: Alignment.center,
              child: Container(
                 height: 50,
                width: 200,
                child: Row(children: [
                  Container(
                    height: 500,
                    width: 150,
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            (10),
                          ),
                        ),
                      ),
                    ),
                  ),
                   IconButton(
                    onPressed: onSendMessage,
                    
                    icon: Icon(Icons.send),
                  ),
           ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget messages(Size size, Map<String, dynamic> map) {
  print("this is message data: $map");
    // return Container(
    //     width: size.width,
    //     // alignment: map["sendBy"] == _auth.currentUser!.displayName
    //     //     ? Alignment.centerRight
    //     //     : Alignment.centerLeft,
    //     child: Container(
    //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         // color: map["sendBy"] == _auth.currentUser!.displayName
    //             // ? Colors.blue
    //             // : Colors.grey,
    //       ),
          return Text(
            map["message"] as String,
            style: const TextStyle(color: Colors.white),
          );
        // ));
  }
}