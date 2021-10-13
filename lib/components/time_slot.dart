import 'package:flutter/material.dart';
import 'package:smarthealth_care/model/slots_model.dart';

class TimeSlot extends StatefulWidget {
  final SlotsModel time;
  final String selectedTime;
  final Color color;
  final Function press;
  const TimeSlot(
      {Key key, this.time, this.selectedTime, this.color, this.press})
      : super(key: key);

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: widget.selectedTime == '${widget.time.hour} : ${widget.time.min}${widget.time.time}'? Colors.blue : widget.color,
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        child: Text(
          '${widget.time.hour}:${widget.time.min} ${widget.time.time}',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600
          ),
        ),
        onPressed: widget.press,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory
        ),
      ),
    );
  }
}
