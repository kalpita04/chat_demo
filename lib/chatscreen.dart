import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class chatscreen extends StatelessWidget {
  // final Map<String, dynamic>? userData;
  // final String? chatRoomId;
  // chatscreen({this.userData, this.chatRoomId});

  TextEditingController _message = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageFile;

Future getImage() async {    //to get the image from galary

  ImagePicker _picker=ImagePicker();

  await _picker.pickImage(source: ImageSource.gallery).then((xFile){
    if(xFile!=null)
    {
      imageFile=File(xFile.path);
      uploadImage();
    }

  });

}

Future uploadImage() async {  //to upload the image
  String filename=Uuid().v1();     //to generate the unique image files name
int status = 1;
    await _firestore
        .collection('chatrooms')
        .doc('chatRoomId')
        .collection('chats')
        .doc(filename)
        .set({
      "sendby": "Kalpita",
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

  var ref=FirebaseStorage.instance.ref().child('images').child("$filename.jpg");   //to give each image a uniquename

  var uploadTask= await ref.putFile(imageFile!).catchError((error) async{
 await _firestore
        .collection('chatrooms')
        .doc('chatRoomId')
        .collection('chats')
        .doc(filename).delete();

        status=0;});
if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatrooms')
          .doc('chatRoomId')
          .collection('chats')
          .doc(filename)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }



void onSendMessage() async {   //to send the text to server
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "message": _message.text,
        "sendBy":  "Kalpita" ,
        "type":"text",                    //_auth.currentUser!.displayName,
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
    final radius = Radius.circular(20);
     final borderRadius = BorderRadius.all(radius);
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
                radius: 25,
                backgroundImage: NetworkImage('https://www.cloudyml.com/wp-content/uploads/2022/02/CLIENT_img-removebg-preview-4.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Akash Raj",style: TextStyle(fontSize:20 ),),
              )]
      ),
      
    ),
    ),
    body: SingleChildScrollView(
      child: Column(
          children: [
            Container(
             height: size.height / 1.27,
                width: size.width,
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
                            Map<String, dynamic> map=
                            // messageData =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            
                            return  messages(size, map, context);
                            



                            
                //             Container( width: 60,
                //             height: 70,
                //             margin:  messageData["sendBy"]=="Kalpita"?EdgeInsets.fromLTRB(200, 25, 15, 5)
                //             :EdgeInsets.fromLTRB(15, 15, 200, 5),
                //             alignment: messageData["sendBy"]=="Kalpita"?
                //             Alignment.centerRight:Alignment.centerLeft,
                //             decoration: BoxDecoration(
                              
                //         borderRadius: messageData["sendBy"]=="Kalpita"
                //              ?borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                // : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
                        
                //           color: messageData["sendBy"]=="Kalpita"
                //              ? Colors.blue[500]
                //               : Colors.grey[350],),
                //               child: Container(
                                
                //                 padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                //                 child: Text(messageData["message"],
                //                 style: GoogleFonts.lato(fontStyle: FontStyle.italic,fontSize:14 )
                //                 // TextStyle(color: Colors.black87,fontSize: 15),
                                
                                
                               
                //     ),
                //               )
                //               );
                              
                          });
                    } else {
                      return Container();
                    }
                  },
               ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                  height: size.height / 12,
                width: size.width / 1.1,
                child: Row(children: [
                  Container(
                    height: size.height / 12,
                    width: size.width / 1.3,
                    child: TextField(
                      controller: _message,
                      autocorrect: true,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(icon: Icon(Icons.photo), onPressed: ()  => getImage(),
                        ),
                        hintText: "Type A Message",
                        border: OutlineInputBorder(
                          gapPadding: 50,
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

Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {  //help us to show the text and the image in perfect alignment
    return map['type'] == "text"  //checks if our msg is text or image
        ? Container(
            width: size.width,
            alignment: map['sendby'] =="Kalpita"
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Text(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == "Kalpita"
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          );
  }
}
class ShowImage extends StatelessWidget {     //to show the image fullscreen
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network("$imageUrl"),
      ),
    );
  }
}
























// Widget messages(Size size, Map<String, dynamic> map) {
//   print("this is message data: $map");
//     // return Container(
//     //     width: size.width,
//     //     // alignment: map["sendBy"] == "_auth.currentUser!.displayName"
//     //     //     ? Alignment.centerRight
//     //     //     : Alignment.centerLeft,
//     //     child: Container(
//     //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//     //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//           // decoration: BoxDecoration(
//           //   borderRadius: BorderRadius.circular(10),
//     //         // color: map["sendBy"] == _auth.currentUser!.displayName
//     //             // ? Colors.blue
//     //             // : Colors.grey,
//     //       ),
//           return Text(
//             map["message"] as String,
//             style: const TextStyle(color: Colors.white),
//           );
//         // ));
//   }
// }