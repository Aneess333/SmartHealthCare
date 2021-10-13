import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smarthealth_care/components/messageBubble.dart';
import 'dart:math';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/navigationScreen.dart';

import 'doctorsDashboard.dart';

class ChattingScreen extends StatefulWidget {
  final UserModel userModel;
  final DoctorModel doctorModel;
  final String userName;
  final String chatRoomId;
  const ChattingScreen({Key key, this.chatRoomId, this.userName, this.userModel, this.doctorModel})
      : super(key: key);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  TextEditingController messageTextEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatMessagesStream;

  @override
  void initState() {
    getMessages();
    super.initState();
  }
  bool isLoading = false;
  getMessages() async {
    setState(() {
      isLoading = true;
    });
    await databaseMethods
        .getConversationMessages(widget.chatRoomId,widget.userName)
        .then((value) {
      setState(() {
        chatMessagesStream = value;
        isLoading = false;
      });
    });
  }

  String messageText;
  sendMessage(String message) {
    if (message.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': message,
        'sendBy': widget.userModel!=null?widget.userModel.name:widget.doctorModel.name,
        'timeStamp': DateTime.now(),
        'time': DateFormat.jm().format(DateTime.now()),
        'read' : 'unread'
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      setState(() {
        messageTextEditingController.clear();
      });
    }
  }
  var imageNumber;
  File _image;
  File _fileDoc;
  final _storage = FirebaseStorage.instance;
  final imagePicker = ImagePicker();
  List<PlatformFile> _paths;

  FileType _pickingType = FileType.custom;
  var filePath;
  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['pdf', 'docx'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    print(_paths.first.path);
    if(_paths.first.path!=null){
      setState(() {
        imageNumber = new Random().nextInt(1000);
        _fileDoc = File(_paths.first.path);
      });
      var snapshot = await _storage.ref()
      .child('documents/doc$imageNumber')
      .putFile(_fileDoc);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      sendMessage(downloadUrl);
      print(downloadUrl);
    }
  }
  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 10);
    await Future.delayed(const Duration(seconds: 2), (){});
    setState(() {
      _image = File(image.path);
      print(_image.path);
      imageNumber = new Random().nextInt(1000);
    });
    if(image!=null){
      var snapshot = await _storage.ref()
          .child('folderName/imageName$imageNumber')
          .putFile(_image);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      sendMessage(downloadUrl);
      print(downloadUrl.substring(0,5));
    }
    print(_image.path);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          widget.userModel!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen(selectedTab: 3,userModel: widget.userModel,))):
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorsDashboard(doctorModel: widget.doctorModel,)));
          return false;
        },
      child: Scaffold(
        backgroundColor: Color(0xFF071820),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: (){
              widget.userModel!=null?Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen(selectedTab: 3,userModel: widget.userModel,))):
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DoctorsDashboard(doctorModel: widget.doctorModel,)));
            },
          ),
          toolbarHeight: 60,
          leadingWidth: 20,
          title: Row(
            children: [
              Icon(
                Icons.account_circle,
                size: 40,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                widget.userName,
                style:
                    GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        body: isLoading?Container(child: Center(
          child: CircularProgressIndicator(),
        ),):SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuild(
                myUserName: widget.userModel!=null?widget.userModel.name:widget.doctorModel.name,
                chatMessageStream: chatMessagesStream,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: 8.0, right: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          color: Color(0xFF232d36),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8.0,
                              ),
                              IconButton(

                                splashRadius: 20.0,
                                onPressed: () {
                                  getImage();
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFF9fa5a9),
                                  size: 25.0,
                                ),
                              ),

                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: TextField(
                                  cursorColor: Color(0xFF00b19c),
                                  cursorHeight: 28,
                                  controller: messageTextEditingController,
                                  maxLines: null,
                                  onChanged: (val) {
                                    messageText = val;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Type a message',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: 100,
                                child: IconButton(
                                  onPressed: (){
                                    _openFileExplorer();
                                    // getDocument();
                                  },
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: Color(0xFF9fa5a9),
                                    size: 25.0,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 10.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        messageTextEditingController.clear();
                        sendMessage(messageText);
                        setState(() {
                          messageText = '';
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF00b19c),
                        child: Icon(
                          Icons.send,
                          color: Color(0xFFfdffff),
                          size: 17,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StreamBuild extends StatelessWidget {
  final myUserName;
  final Stream chatMessageStream;
  const StreamBuild({Key key, this.chatMessageStream, this.myUserName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
            stream: chatMessageStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                final messages = snapshot.data.docs.reversed;
                List<MessageBubble> messagesBubbles = [];
                for (var message in messages) {
                  final messageText = message.get('message');
                  final sender = message.get('sendBy');
                  final currentUser =myUserName;
                  final timeStamp = message.get('time');
                  final read = message.get('read');
                  print(timeStamp);

                  final messageBubble = MessageBubble(
                    timeStamp: timeStamp,
                    message: messageText,
                    sender: sender,
                    isMe: currentUser == sender,
                    read: read
                  );
                  messagesBubbles.add(messageBubble);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messagesBubbles,
                  ),
                );
              }
            },
          );
  }
}


