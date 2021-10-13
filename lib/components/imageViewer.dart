import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageViewer extends StatelessWidget {
  final String username,time,url;
  const ImageViewer({Key key, this.username, this.time, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 60,
        leadingWidth: 50,
        title: Row(
          children: [
            SizedBox(
              width: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style:
                  GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(time, style:
                GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w200),)
              ],
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black
        ),
        alignment: Alignment.center,
        child: Image.network(url),
      ),
    );
  }
}
