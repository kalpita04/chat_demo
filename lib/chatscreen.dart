import 'dart:developer';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:image_picker/image_picker.dart";
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

class chatscreen extends StatelessWidget {
  // final Map<String, dynamic>? userData;
  // final String? chatRoomId;
  // chatscreen({this.userData, this.chatRoomId});

  late final groupData;
  String? groupId;

  TextEditingController _message = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageFile;

  File? pickedFile;

  String? pickedFileName;

  Future getImage() async {
    //to get the image from galary

    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    //to upload the image
    String filename = Uuid().v1(); //to generate the unique image files name
    int status = 1;
    await _firestore
        .collection('chatrooms')
        .doc('chatRoomId')
        .collection('chats')
        .doc(filename)
        .set({
      "sendBy": "Kalpita",
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child("$filename.jpg"); //to give each image a uniquename

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatrooms')
          .doc('chatRoomId')
          .collection('chats')
          .doc(filename)
          .delete();

      status = 0;
    });
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

  void onSendMessage() async {
    //to send the text to server
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "message": _message.text,
        "sendBy": "Kalpita",
        "type": "text", //_auth.currentUser!.displayName,
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
    final size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    final radius = Radius.circular(20);
    final borderRadius = BorderRadius.all(radius);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        elevation: 0,
        title: Container(
          padding: EdgeInsets.only(left: 0),
          child: Row(children: [
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
              backgroundImage: NetworkImage(
                  'https://www.cloudyml.com/wp-content/uploads/2022/02/CLIENT_img-removebg-preview-4.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Akash Raj",
                style: TextStyle(fontSize: 20),
              ),
            )
          ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.29,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("chatrooms")
                    .doc("chatRoomId")
                    .collection("chats")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map =
                              // messageData =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                          return messages(size, map, context);


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
                // height: size.height / 12,
                width: size.width / 1.1,
                child: Row(children: [
                  Container(
                    // height: size.height / 6,
                    width: size.width / 1.3,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _message,
                      autocorrect: true,
                      cursorColor: Colors.purple,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 119, 5, 181),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 35, 6, 194),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: "Type A Message",
                        suffixIcon: Container(
                          width: width * 0.3,
                          height: size.height,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.attach_file),
                                color: Colors.purple,
                              ),
                              IconButton(
                                icon: Icon(Icons.camera_alt),
                                color: Colors.purple,
                                onPressed: () => getImage(),
                              ),
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            (10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Ink(
                      decoration: const ShapeDecoration(
                        color: Color.fromARGB(255, 141, 5, 136),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        focusColor: Colors.blue,
                        splashRadius: 30,
                        splashColor: Colors.blueGrey,
                        onPressed: onSendMessage,
                        icon: Icon(Icons.send),
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    //help us to show the text and the image in perfect alignment

    DateTime t = ((map['time']).toDate());
    //  String datetime2 = DateFormat.Hms().format(t);
    //   print(datetime2);

    String datetime4 = DateFormat(('hh:mm a')).format(t);
    // print(datetime4);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return map['type'] == "text" //checks if our msg is text or image
        ? Container(
            width: size.width,
            alignment: map['sendBy'] == "Kalpita"
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child:
           
                Container(
              width: width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(10, 10), // changes position of shadow
                    ),
                
                  ],
                  gradient: RadialGradient(
                      center: Alignment.topRight,
                      // near the top right
                      radius: 6,
                      colors: [
                        Colors.purple,
                        Colors.blue,
                      ])),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      (map['sendBy']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber[900],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SelectableText(map['message'],
                        textWidthBasis: TextWidthBasis.parent,
                        style: GoogleFonts.archivo(
                            color: Colors.white, fontSize: 14)
                        ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "$datetime4",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  )
                  // (map['time']).toDate().toString()))
                ],
              ),
            ),
        
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            alignment: map['sendBy'] == "Kalpita"
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
                width: width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                 
                    
                  ],
                 
                     ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        (map['sendBy']),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber[900],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height:5 ,),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: size.height / 2.5,
                          width: size.width / 2,
                          decoration: BoxDecoration(border: Border.all()),
                          alignment:
                              map['message'] != "" ? null : Alignment.center,
                          child: map['message'] != ""
                              ? Image.network(
                                  map['message'],
                                  fit: BoxFit.cover,
                                )
                              : CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        " $datetime4 ",
                        style: TextStyle(fontSize: 10, color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ));
   
  }
}

class ShowImage extends StatelessWidget {
  //to show the image fullscreen
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = this.imageUrl;

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
