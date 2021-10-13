import 'package:flutter/material.dart';

class ChooseSpeciality extends StatefulWidget {
  ChooseSpeciality({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChooseSpecialityState createState() => new _ChooseSpecialityState();
}

class _ChooseSpecialityState extends State<ChooseSpeciality> {
  TextEditingController editingController = TextEditingController();
  static List<String> subtitleDataList = [
    "Doctor in Islamabad",
    "Doctor in Islamabad",
    "Doctor in Islamabad",
    "Doctor in Rawalpindi",
    "Doctor in Rawalpindi",
    "Doctor in Lahore",
    "Doctor in Peshawar",
    "Doctor in Attock",
    "Doctor in Texila",
    "Doctor in Jhelum",
    "Doctor in Jhang",
    "Doctor in Pithorani",
    "Doctor in Bagh",
    "Doctor in Gujrat",
    "Doctor in Sialkot",
    "Doctor in Islamabad",
    "Doctor in Lahore",
    "Doctor in Gujranwala"
  ];
  // final iconsList = [
  //   Icon(Icons.face),
  //   Icon(Icons.dentistz),
  //   "Pediatric Gastroenterologist",
  //   "Hijama Specialist",
  //   "Rehabilitation",
  //   "Psychiatrist",
  //   "Radiologist",
  //   "Cancer Specialist / Oncologist",
  //   "Hematologist",
  //   "Speech Therapist",
  //   "Allergy Specialist",
  //   "Gynecologist",
  //   "Maternal Fetal Medicine Specialist",
  //   "Anesthetist",
  //   "Infectious Disease",
  //   "Audiologist",
  //   "Dermatologist",
  //   "Pediatric Cardiologist"
  // ];

  final duplicateItems = [
    "Oral and Maxillofacial Surgeon",
    "Dentist",
    "Pediatric Gastroenterologist",
    "Hijama Specialist",
    "Rehabilitation",
    "Psychiatrist",
    "Radiologist",
    "Cancer Specialist / Oncologist",
    "Hematologist",
    "Speech Therapist",
    "Allergy Specialist",
    "Gynecologist",
    "Maternal Fetal Medicine Specialist",
    "Anesthetist",
    "Infectious Disease",
    "Audiologist",
    "Dermatologist",
    "Pediatric Cardiologist"
  ];
  var items = [];
  var subtitle = [];

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Search Speciality'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search Specialities",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.lightBlue,
                      child: Icon(Icons.face),
                    ),
                    subtitle: Text(
                      '${subtitleDataList[index]}',
                      style: TextStyle(color: Colors.green),
                    ),
                    title: Text('${items[index]}'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
