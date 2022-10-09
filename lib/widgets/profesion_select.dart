import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../screens/home2_screen.dart';

class ProfesionSelect extends StatefulWidget {
  final Function callback;
  ProfesionSelect(this.callback);

  @override
  State<ProfesionSelect> createState() => _ProfesionSelectState();
}

class _ProfesionSelectState extends State<ProfesionSelect> {
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

  void reset() {
    setState(() {
      selectedProfesion = null;
      widget.callback(Profesion("Pretraga", 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Positioned(
      top: 270,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: selectedProfesion != null ? 274 : 324,
            height: 40,
            padding: EdgeInsets.only(left: 20),
            child: FutureBuilder(
                future: loadCategories(),
                builder: (ctx, fut) {
                  if (fut.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<Profesion>(
                        isExpanded: true,
                        hint: selectedProfesion != null
                            ? Text(
                                selectedProfesion.name,
                                style: TextStyle(color: Colors.black),
                              )
                            : Text(
                                'Odaberite kategoriju',
                                style: TextStyle(color: Colors.black),
                              ), // Not necessary for Option 1
                        onChanged: (Profesion newValue) {
                          setState(() {
                            selectedProfesion = newValue;
                            widget.callback(selectedProfesion);
                            print(selectedProfesion.id);
                          });
                        },
                        items: listProfesions.map((profesion) {
                          return DropdownMenuItem<Profesion>(
                            child: new Text(
                              profesion.name,
                              style: TextStyle(color: Colors.black),
                            ),
                            value: profesion,
                          );
                        }).toList(),
                      ),
                    );
                  }
                }),
          ),
          Visibility(
            visible: selectedProfesion != null,
            child: Container(
                width: 50,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                              style: BorderStyle.solid),
                          ),
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  onPressed: reset,
                  child: Icon(Icons.close)
                )
              ),
          )
        ],
      ),
    );
  }
}
