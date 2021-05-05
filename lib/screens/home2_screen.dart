import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'display_jobs.screen.dart';

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
    'Banja Luka'
  ]; // Option 2
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
    print('rebuild');
    return FutureBuilder(
        future: loadCategories(),
        builder: (ctx, fut) {
          if (fut.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 290,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          const NetworkImage("https://i.imgur.com/8yMQpPY.png"),
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
                      hint:
                          Text('Select location'), // Not necessary for Option 1
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
                              'Select department'), // Not necessary for Option 1
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
                  height: 52,
                  width: 277,
                  margin: EdgeInsets.only(top: 24),
                  child: FlatButton(
                    color: Colors.green,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayJobsScreen(
                                  industry: 'industry=' +
                                      selectedProfesion.id.toString(),
                                  title: selectedProfesion.name,
                                  location: _selectedLocation,
                                ))),
                    child: Text('Search',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                )
              ],
            );
          }
        });
  }
}
