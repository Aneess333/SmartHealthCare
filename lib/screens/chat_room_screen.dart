import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/chat_search.dart';
import 'package:smarthealth_care/screens/chatting_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarthealth_care/screens/navigationScreen.dart';

class ChatRoom extends StatefulWidget {
  final UserModel userModel;
  const ChatRoom({Key key, this.userModel}) : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}
class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRooms;
  QuerySnapshot notificationSnapshot;
  DateTime currentBackPressTime;
  String userName = '';
  List<dynamic> list = [];
  bool isLoading= false;
  @override
  void initState() {
    super.initState();
    getChatRooms();
    getNotifications();
  }
  getNotifications()async{
    setState(() {
      print('herendbcsj');
      isLoading = true;
    });
    await databaseMethods.getNotifications(widget.userModel.name).then((value){
      if(mounted) {
        setState(() {
          notificationSnapshot = value;
        });
      }
    });
    List<dynamic> dummyList = [];
    print(notificationSnapshot.docs.length);
    for(int i=0;i<notificationSnapshot.docs.length;i++){
      String chatRoomId = notificationSnapshot.docs[i].id;
      userName = chatRoomId.substring(0,chatRoomId.indexOf('_'));
      if(widget.userModel.name == userName){
        userName = chatRoomId.substring(chatRoomId.indexOf('_')+1);
      }
      print(userName);
      QuerySnapshot chats = await FirebaseFirestore.instance
          .collection('ChatRoom')
          .doc(notificationSnapshot.docs[i].id)
          .collection('chats')
          .where('sendBy', isEqualTo: userName)
          .where('read',isEqualTo: 'unread').get();
        dummyList.add(chats.docs.length);
        print(chats.docs.length);
    }
    if(mounted){
      setState(() {
        list = dummyList;
        isLoading = false;
      });
    }

  }


  getChatRooms() async {
    await databaseMethods.getChatRooms(widget.userModel.name).then((val) {
      setState(() {
        chatRooms = val;
      });
    });
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String chatRoomId = snapshot.data.docs[index].get('chatroomId');
                  String result = chatRoomId.substring(0,chatRoomId.indexOf('_'));
                  if(widget.userModel.name == result){
                    result = chatRoomId.substring(chatRoomId.indexOf('_')+1);
                  }
                  return ChatRoomsTile(
                    userModel: widget.userModel,
                    userName: result,
                    chatRoomId: snapshot.data.docs[index].get('chatroomId'),
                    notifications: list.isEmpty?'':(list.asMap().containsKey(index)?list[index].toString():''),
                  );
                },
              )
            : Container(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen(selectedTab: 0,userModel: widget.userModel,)));
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Color(0xFF071820),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Chat Room'),
        ),
        body: isLoading?Container(child: Center(
          child: CircularProgressIndicator(),
        ),):chatRoomList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  final String notifications;
  final UserModel userModel;
  const ChatRoomsTile({Key key, this.userName, this.chatRoomId, this.notifications, this.userModel})
      : super(key: key);

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot lastMessages;
  String lastMessage= '';
  String readStatus = 'unread';
  bool isMe = false;
  @override
  void initState() {
    super.initState();
    getLast();
  }
  getLast() async {
    await databaseMethods.getLastMessage(widget.chatRoomId, widget.userName).then((value){
        lastMessages = value;
        if(lastMessages.docs.length>0){
          if(mounted){
            setState(() {
              lastMessage = lastMessages.docs[0].get('message')==null?'':lastMessages.docs[0].get('message');
              readStatus = lastMessages.docs[0].get('read');
              isMe = lastMessages.docs[0].get('sendBy') == widget.userModel.name;
            });
          }

        }

    });



  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChattingScreen(
                          userModel: widget.userModel,
                              userName: widget.userName,
                              chatRoomId: widget.chatRoomId,
                            )));
              },
              child: Row(
                children: [
                  // Text(databaseMethods.getLastMessage(widget.chatRoomId)),
                  Icon(
                    Icons.account_circle,
                    size: 64.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.userName,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                              Row(
                                children: [
                                  isMe?readStatus == 'read'?Icon(Icons.check,size: 15,color: Color(0xff47b2d0),):Icon(Icons.check,size: 15,color: Color(0xff9eb38d)):Text(''),
                                  lastMessage.contains('https://firebasestorage.googleapis.com/v0/b/smarthealthcare-235f1.appspot.com/o/')?
                                      Row(
                                        children: [
                                          lastMessage.contains('https://firebasestorage.googleapis.com/v0/b/smarthealthcare-235f1.appspot.com/o/documents')?Icon(Icons.book,size: 16,color: Color(0xff6f6f6f)):Icon(Icons.photo,size: 16,color: Color(0xff6f6f6f)),
                                          lastMessage.contains('https://firebasestorage.googleapis.com/v0/b/smarthealthcare-235f1.appspot.com/o/documents')?Text('Document',style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w300, fontSize: 16,color: Color(0xff6f6f6f))):Text('Photo',style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w300, fontSize: 16,color: Color(0xff6f6f6f)))
                                        ],
                                      )
                                      :Text(lastMessage.length<45?lastMessage:(lastMessage.substring(0,45)+'...'),style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w300, fontSize: 16,color: Color(0xff6f6f6f)),),
                                ],
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: widget.notifications=='0'?null:BoxDecoration(shape: BoxShape.circle, color: Color(0xFF07d362)),
                            alignment: Alignment.center,
                            child: widget.notifications=='0'?null:Text(widget.notifications,style: TextStyle(
                                color: Colors.white
                            ),),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
