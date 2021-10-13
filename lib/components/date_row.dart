import 'package:flutter/material.dart';

class DateRow extends StatefulWidget {
  final Color color;
  final Function press;
  final String selectedButton;
  final String day;
  final dynamic date;
  final dynamic month;
  const DateRow(
      {Key key,
      this.color,
      this.press,
      this.selectedButton, this.day, this.date, this.month,})
      : super(key: key);

  @override
  _DateRowState createState() => _DateRowState();
}
class _DateRowState extends State<DateRow> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.press,
      style: ElevatedButton.styleFrom(
        primary:
            '${widget.date} ${widget.month}' == widget.selectedButton ? Colors.blue : widget.color,
        side: BorderSide(
          color: Colors.blue,
          width: 0.5,
        ),
        shadowColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Text('${widget.date} ${widget.month}',style: TextStyle(
              fontWeight: FontWeight.w400
            ),),
            Text(widget.day.substring(0,3),style: TextStyle(
                fontWeight: FontWeight.w400
            )),
          ],
        ),
      ),
    );
  }
}
