import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:smarthealth_care/components/imageViewer.dart';
import 'package:url_launcher/url_launcher.dart';
class MessageBubble extends StatefulWidget {
  MessageBubble({this.message, this.sender, this.isMe, this.timeStamp, this.read});
  final String message;
  final String sender;
  final bool isMe;
  final String timeStamp,read;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.only(
        left: widget.isMe ? 60.0 : 17.0,
        right: widget.isMe ? 17.0 : 60.0,
      ),
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      child: Container(
          padding: Uri.parse(widget.message).isAbsolute?EdgeInsets.symmetric(horizontal: 5, vertical: 5):EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: widget.isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0))
                : BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)),
            gradient: LinearGradient(colors: [
              widget.isMe ? Color(0xFF054640) : Color(0xFF212e36),
              widget.isMe ? Color(0xFF043d36) : Color(0xFF212e36)
            ]),
          ),
          child: Uri.parse(widget.message).isAbsolute && widget.message.contains('https://firebasestorage.googleapis.com/v0/b/smarthealthcare-235f1.appspot.com/o/folderName')?ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageViewer(username: widget.sender,time: widget.timeStamp,url: widget.message,)));
              },

              child: Image.network(widget.message,fit: BoxFit.fill,
                loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 300,
                    width: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ?
                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ):widget.message.contains('https://firebasestorage.googleapis.com/v0/b/smarthealthcare-235f1.appspot.com/o/documents')?ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: 130,
                      height: 80,
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.white
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'File',
                          style: GoogleFonts.roboto(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white.withOpacity(0.9))
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                    height: 40,
                    child: IconButton(
                      icon: Icon(
                            Icons.file_download,
                            // color: isSelf
                            //     ? Palette.selfMessageColor
                            //     : Palette.otherMessageColor,
                          ),
                      onPressed: ()async{
                        if (await canLaunch(widget.message)) {
                        await launch(
                        widget.message,
                        forceSafariVC: true,
                        enableJavaScript: true,
                        );
                        } else {
                        throw 'Could not launch $url';
                        }
                      },
                    ),
                        )
              ],
            ),
          ):RichText(
            text: TextSpan(
                text: widget.message,
                style: GoogleFonts.roboto(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9)),
                children: [
                  TextSpan(text: '  '),
                  TextSpan(
                      text: widget.timeStamp,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      )),
                ]),
          )

      ),

    );
  }
}