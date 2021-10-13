import 'package:flutter/material.dart';
import 'package:smarthealth_care/model/datesModel.dart';
import 'date_row.dart';

class DateRowList extends StatefulWidget {
  final List<DateModel> dates ;
  const DateRowList({Key key, this.dates}) : super(key: key);

  @override
  _DateRowListState createState() => _DateRowListState();
}

class _DateRowListState extends State<DateRowList> {
  Color color = Colors.transparent;
  String selectedItem;
  @override
  void initState() {
    selectedItem = widget.dates[0].date;
    super.initState();
  }
  Widget getRow(){
    List<Widget> list = [];
    for(int i=0;i<widget.dates.length;i++){
      list.add(DateRow(
        selectedButton: selectedItem,
        color: color,
        press: () {
          setState(() {
            selectedItem = widget.dates[i].date;
          });
        },
        day: widget.dates[i].day,
        date: widget.dates[i].date,
        month: widget.dates[i].month,
      ),);
      list.add(SizedBox(width: 5.0,));
    }
    return Row(children: list,);
  }
  @override
  Widget build(BuildContext context) {
    return getRow();
  }
}
