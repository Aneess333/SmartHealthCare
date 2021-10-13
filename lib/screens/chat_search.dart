import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthealth_care/components/app_bar.dart';
import 'package:smarthealth_care/entities/constants.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/user.dart';
import 'chatting_screen.dart';

class ChatSearch extends StatefulWidget {
  final UserModel userModel;
  const ChatSearch({Key key, this.userModel}) : super(key: key);

  @override
  _ChatSearchState createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {
  void _showToast() {
    Fluttertoast.showToast(
        msg: "You can't chat with yourself",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  getChatRoomId(String a, String b) {
    if (a.compareTo(b) == 1) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.docs[index].get('name'),
                email: searchSnapshot.docs[index].get('email'),
              );
            })
        : Container();
  }

  Widget searchTile({String userName, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName),
              Text(email),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('Message'),
            ),
          )
        ],
      ),
    );
  }

  QuerySnapshot searchSnapshot;
  createChatRoomAndStartConversation(String username) {
    if (username != widget.userModel.name) {
      String chatRoomId = getChatRoomId(username, widget.userModel.name);
      List<String> users = [username, widget.userModel.name];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomId': chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChattingScreen(
                userModel: widget.userModel,
                    chatRoomId: chatRoomId,
                    userName: username,
                  )));
    } else {
      _showToast();
    }
  }

  initiateSearch() {
    databaseMethods
        .getUsersByName(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Chat Search'),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                          hintText: 'Search username...',
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.search)),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}
