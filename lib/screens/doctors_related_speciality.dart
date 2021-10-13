import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthealth_care/components/doctors_list_view.dart';
import 'package:smarthealth_care/helper/database.dart';
import 'package:smarthealth_care/model/doctor_model.dart';
import 'package:smarthealth_care/model/rating.dart';
import 'package:smarthealth_care/model/user.dart';

class DoctorsList extends StatefulWidget {
  final UserModel userModel;
  final String speciality;
  const DoctorsList(this.speciality, {Key key, this.userModel}) : super(key: key);

  @override
  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList>
    with SingleTickerProviderStateMixin {
  TextEditingController editingController = TextEditingController();
  var items = [];
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'ALL DOCTORS'),
    Tab(text: 'NEARBY DOCTORS'),
  ];
  List<DoctorModel> doctors = [];
  List<DoctorModel> nearbyDoctors = [];
  List<DoctorModel> duplicateDoctors = [];
  List<RatingModel> ratings = [];
  List<DoctorModel> duplicateNearbyDoctors = [];
  DatabaseMethods databaseMethods = DatabaseMethods();
  TabController _tabController;
  bool isLoading = true;
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    getDoctors();
    getNearbyDocs();
  }
  void filterSearchResults(String query,String docType) {
    final List<DoctorModel> dummyDoctors = [];
    if(docType == 'All doctors'){
      dummyDoctors.addAll(duplicateDoctors);
    }
    else{
      dummyDoctors.addAll(duplicateNearbyDoctors);
    }

    if(query.isNotEmpty){
      List<DoctorModel> dummyListData = [];
      dummyDoctors.forEach((element) {
        if(element.name.toLowerCase().contains(query.toLowerCase())){
          dummyListData.add(element);
        }
      });
      setState(() {
        if(docType == 'All doctors'){
          doctors.clear();
          doctors.addAll(dummyListData);
        }
        else{
          nearbyDoctors.clear();
          nearbyDoctors.addAll(dummyListData);
        }

      });
      return;
    }
    else{
      setState(() {
        if(docType == 'All doctors'){
          doctors.clear();
          doctors.addAll(duplicateDoctors);
        }
        else{
          nearbyDoctors.clear();
          nearbyDoctors.addAll(duplicateNearbyDoctors);
        }

      });
    }
  }
  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
  Future<void> getNearbyDocs() async {
    var data = await databaseMethods.getDoctorsWithSpeciality(widget.speciality,true,widget.userModel);
    if(data.runtimeType == String){
      // _showToast(data.toString());
      return;
    }
    data.forEach((shot){
      nearbyDoctors.add(DoctorModel.fromJson(shot.data()));
    });
    setState(() {
      nearbyDoctors.length;
      duplicateNearbyDoctors.addAll(nearbyDoctors);
      //isLoading = !isLoading;
    });
  }
  Future<void> getDoctors() async {
    var data = await databaseMethods.getDoctorsWithSpeciality(widget.speciality,false,widget.userModel);
    if(data.runtimeType == String){
      _showToast(data.toString());
      return;
    }
    data.forEach((shot) async {
      doctors.add(DoctorModel.fromJson(shot.data()));
    });
    var rate = 0.0;
      for(int i=0;i<doctors.length;i++){
        var ratingsList = await databaseMethods.getRatings(doctors[i].name);
        if(ratingsList.runtimeType == String){
          _showToast(ratingsList.toString());
          return;
        }
        int j =0;
        ratingsList.forEach((shot){
          ratings.add(RatingModel.fromJson(shot.data()));
          rate = rate + ratings[j].rating;
          print(ratings[j].review);
          j++;
        });
        doctors[i].rating = rate/(j);
        print(doctors[i].rating);
        ratings.clear();
        print(rate);
        rate = 0.0;

      }


    setState(() {
      doctors.length;
      duplicateDoctors.addAll(doctors);
      isLoading = !isLoading;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.speciality),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: isLoading?Container(child: Center(child: CircularProgressIndicator(),),):Padding(
        padding: EdgeInsets.all(10.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                SizedBox(height: 10,),
        TextField(
        onChanged: (value) {
      filterSearchResults(value,'All doctors');
      },
        controller: editingController,
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Search Doctors and Specialities",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
                SizedBox(height: 10,),
                DoctorsListView(userModel: widget.userModel,
                    items: doctors,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 10,),
                TextField(
                onChanged: (value) {
    filterSearchResults(value,'Nearby Doctors');
    },
      controller: editingController,
      decoration: InputDecoration(
          labelText: "Search",
          hintText: "Search Doctors and Specialities",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
    ),
                SizedBox(height: 10,),
                DoctorsListView(
                  userModel: widget.userModel,
                    items: nearbyDoctors,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
