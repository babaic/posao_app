import 'package:flutter/material.dart';
import 'package:posao_app/models/ITJob.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  bool isLoading = true;

    @override
  void initState() {
    super.initState();
    Provider.of<Jobs>(context, listen: false).getCategoriesFrom_Dzobs().then((value) {
       categories = value;
       setState(() {
         isLoading = false;
       });
  });

  }

    List<String> _locations = [
    'Remote',
    'Sarajevo',
    'Zenica',
    'Mostar',
    'Banja Luka',
    'Tuzla',
  ]; // Option 2,
  String _selectedLocation; // Option 2

  List<String> _iskustva = ['Junior', 'Medior', 'Senior'];
  String _selectedIskustvo;

  List<ITJobCategory> categories;
  String _selectedCategory;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
    icon: Icon(Icons.close, color: Colors.grey),
    onPressed: () => Navigator.of(context).pop(),
  ), 
        title: Text(
          'Filteri',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Grad', style: TextStyle(fontSize: 18),),
                Container(
                  width: 120,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Iskustvo', style: TextStyle(fontSize: 18),),
                Container(
                  width: 200,
                  child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                                'Odaberite iskustvo'), // Not necessary for Option 1
                            value: _selectedIskustvo,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedIskustvo = newValue;
                              });
                            },
                            items: _iskustva.map((location) {
                              return DropdownMenuItem(
                                child: new Text(location),
                                value: location,
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tehnologija', style: TextStyle(fontSize: 18),),
                isLoading ? CircularProgressIndicator() : Container(
                  width: 200,
                  child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                                'Odaberite tehnologiju'), // Not necessary for Option 1
                            value: _selectedCategory,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            },
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                child: new Text(category.label),
                                value: category.value,
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
            Expanded(child: SizedBox(height: 10,)),
            Container(
              width: double.infinity,
              child: FlatButton(
                        color: Colors.blue[900],
                        height: 40,
                        onPressed: () => Navigator.of(context).pop({'lokacija': _selectedLocation, 'iskustvo': _selectedIskustvo, 'kategorija': _selectedCategory}),
                        child: Text('Pretraga',
                            style: TextStyle(color: Colors.white, fontSize: 18)),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid),
                        ),
                      ),
            )
          ],
        ),
      )
    );
  }
}
