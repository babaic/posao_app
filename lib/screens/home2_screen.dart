import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/screens/display_it_jobs.screen.dart';
import 'package:posao_app/screens/it_job_detail_screen.dart';
import 'package:provider/provider.dart';

import 'display_jobs.screen.dart';
import 'job_detail_screen.dart';

class Home2Screen extends StatefulWidget {
  @override
  _Home2ScreenState createState() => _Home2ScreenState();
}

class Profesion {
  final String name;
  final int id;
  Profesion(this.name, this.id);
}

class _Home2ScreenState extends State<Home2Screen> {
  List<Map<String, dynamic>> categories = new List<Map<String, dynamic>>();

  List<String> _locations = [
    'Sarajevo',
    'Zenica',
    'Mostar',
    'Banja Luka',
    'Tuzla'
  ]; // Option 2,
  String _selectedLocation; // Option 2

  List<Profesion> listProfesions = [];
  Profesion selectedProfesion;

  Future<void> loadCategories() async {
    List<Profesion> profesionToAdd = new List<Profesion>();
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/categories.json");
    final categoriesJson = json.decode(data);
    for (var i = 0; i < categoriesJson.length; i++) {
      profesionToAdd
          .add(Profesion(categoriesJson[i]['name'], categoriesJson[i]['id']));
    }
    listProfesions = profesionToAdd;
  }

  // @override
  // Future<void> initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   loadCategories();
  // }

  @override
  Widget build(BuildContext context) {
    var jobsProvider = Provider.of<Jobs>(context, listen: false);
    print('rebuild');
    return FutureBuilder(
        future: loadCategories(),
        builder: (ctx, fut) {
          if (fut.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 210,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: const AssetImage("assets/header.png"),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(196, 196, 196, 40),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: 384,
                    height: 36,
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(
                            'Odaberite lokaciju'), // Not necessary for Option 1
                        value: _selectedLocation,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(196, 196, 196, 40),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: 384,
                    height: 36,
                    padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Profesion>(
                        isExpanded: true,
                        hint: selectedProfesion != null
                            ? Text(selectedProfesion.name)
                            : Text(
                                'Odaberite kategoriju'), // Not necessary for Option 1
                        onChanged: (Profesion newValue) {
                          setState(() {
                            selectedProfesion = newValue;
                            print(selectedProfesion.id);
                          });
                        },
                        items: listProfesions.map((profesion) {
                          return DropdownMenuItem<Profesion>(
                            child: new Text(profesion.name),
                            value: profesion,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 257,
                    margin: EdgeInsets.only(top: 24),
                    child: FlatButton(
                      color: Colors.green,
                      onPressed: () => selectedProfesion == null
                          ? null
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DisplayJobsScreen(
                                        industry: 'industry=' +
                                            selectedProfesion.id.toString(),
                                        title: selectedProfesion.name,
                                        location: _selectedLocation,
                                      ))),
                      child: Text('Pretraga',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Novi poslovi',
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  'Iz kategorija koje pratite',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Expanded(flex: 2, child: Icon(Icons.add_circle, color: Colors.grey[400],))
                        ],
                      )),
                  FutureBuilder(future: Provider.of<Jobs>(context, listen: false).getJobsFromCategoryInterest(), builder: (ctx, futureSnapshot) {
                    if(futureSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    else if(Provider.of<Jobs>(context, listen: false).jobs.length == 0) {
                       return Center(child: Container(padding: EdgeInsets.only(top: 40), child: Text('Nema poslova'))); 
                      }
                    else {
                      return Container(
                      height: 160,
                      child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: Provider.of<Jobs>(context, listen: false).jobs.length, itemBuilder: (context, index) => InkWell(
                        child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            width: 160.0,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  child: Image.network(jobsProvider.jobs[index].company.photo),
                                ),
                                Text(jobsProvider.jobs[index].title, style: TextStyle(overflow: TextOverflow.ellipsis),),
                                Text(jobsProvider.jobs[index].company.name, style: TextStyle(overflow: TextOverflow.ellipsis)),
                                Text(jobsProvider.jobs[index].company.city, style: TextStyle(overflow: TextOverflow.ellipsis))
                              ],
                            ),
                            ),
                          ),
                          onTap: () =>
                              Navigator.of(context).push(PageRouteBuilder(
                                transitionDuration:
                                    Duration(milliseconds: 1000),
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    JobDetailScreen(jobsProvider.jobs[index].id),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var tween = Tween(begin: begin, end: end);
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ))
                      )));
                    }
                  }
                      
                    ),
                ],
              ),
            );
          }
        });
  }
}
