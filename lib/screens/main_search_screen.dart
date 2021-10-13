import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/specialities.dart';
import 'package:smarthealth_care/model/user.dart';
import 'package:smarthealth_care/screens/doctors_related_speciality.dart';

class MainSearch extends StatefulWidget {
  final UserModel userModel;
  MainSearch({Key key, this.title, this.userModel}) : super(key: key);
  final String title;

  @override
  _MainSearchState createState() => new _MainSearchState();
}

class _MainSearchState extends State<MainSearch> {
  TextEditingController editingController = TextEditingController();
  var items = [];
  var subtitle = [];
  bool isLoading = true;
  DatabaseMethods databaseMethods = DatabaseMethods();
  final List<SpecialitiesModel> specialities = [];
  final List<SpecialitiesModel> duplicateSpecialities = [];

  @override
  void initState() {
    super.initState();
    getSpecialities();
  }
  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
  Future<void> getSpecialities() async {
    var data = await databaseMethods.getSpecialities();
    if(data.runtimeType == String){
      _showToast(data.toString());
      return;
    }
    data.forEach((shot){
      specialities.add(SpecialitiesModel.fromJson(shot.data()));
      print(specialities[0].speciality);
    });
    if(mounted){
      setState(() {
        specialities.length;
        duplicateSpecialities.addAll(specialities);
        isLoading = !isLoading;
      });
    }

  }
  void filterSearchResults(String query) {
    final List<SpecialitiesModel> dummySpecialities = [];
    dummySpecialities.addAll(duplicateSpecialities);
    if(query.isNotEmpty){
      List<SpecialitiesModel> dummyListData = [];
      dummySpecialities.forEach((element) {
        if(element.speciality.toLowerCase().contains(query.toLowerCase())){
          dummyListData.add(element);
        }
      });
      setState(() {
        specialities.clear();
        specialities.addAll(dummyListData);
      });
      return;
    }
    else{
      setState(() {
        specialities.clear();
        specialities.addAll(duplicateSpecialities);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Search'),
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
                    hintText: "Search Doctors and Specialities",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            isLoading?Expanded(child: Container(alignment: Alignment.center,child: Center(child: CircularProgressIndicator(),),)):
            specialities.isEmpty?Expanded(child: Container(child: Center(child: Text('No speciality found!',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey
            ),)),)):Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: specialities.length,
                itemBuilder: (context, index) {
                  SpecialitiesModel s = specialities[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.lightBlue,
                          child: Icon(Icons.face),
                        ),
                        title: Text('${s.speciality}'),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.green,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorsList(s.speciality,userModel: widget.userModel,),
                            ),
                          );
                        },
                      ),
                      Divider()
                    ],
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
