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
          .add(Profesion( categoriesJson[i]['name'], categoriesJson[i]['id']));
    }
    listProfesions = profesionToAdd;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadCategories(),
        builder: (ctx, fut) {
          if (fut.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return DropdownButtonHideUnderline(
              child: DropdownButton<Profesion>(
                isExpanded: true,
                hint: selectedProfesion != null
                    ? Text(selectedProfesion.name, style: TextStyle(color: Colors.black),)
                    : Text(
                        'Odaberite kategoriju', style: TextStyle(color: Colors.black),), // Not necessary for Option 1
                onChanged: (Profesion newValue) {
                  setState(() {
                    selectedProfesion = newValue;
                    widget.callback(selectedProfesion);
                    print(selectedProfesion.id);
                  });
                },
                items: listProfesions.map((profesion) {
                  return DropdownMenuItem<Profesion>(
                    child: new Text(profesion.name, style: TextStyle(color: Colors.black),),
                    value: profesion,
                  );
                }).toList(),
              ),
            );
          }
        });
  }
}
