import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/screens/display_it_jobs.screen.dart';
import 'package:posao_app/screens/it_job_detail_screen.dart';
import 'package:posao_app/widgets/profesion_select.dart';
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
  Profesion selectedProfesion;

  void getSelectedProfesion(var profesion) {
    selectedProfesion = profesion;
    print('profesion ${selectedProfesion.name}');
  }

  // List<Profesion> listProfesions = [];
  // Profesion selectedProfesion;

  static const List<String> _kOptions = <String>[
    'Banovići',
'Banja Luka',
'Berkovići',
'Bihać',
'Bijeljina',
'Bileća',
'Bosanska Krupa',
'Bosanski Brod',
'Bosanski Petrovac',
'Bosansko Grahovo',
'Bratunac',
'Brčko',
'Breza',
'Bugojno',
'Busovača',
'Bužim',
'Cazin',
'Čajniče',
'Čapljina',
'Čelić',
'Čelinac',
'Čitluk',
'Derventa',
'Doboj',
'Doboj-Istok',
'Doboj-Jug',
'Dobretići',
'Domaljevac-Šamac',
'Donji Vakuf',
'Donji Žabar',
'Drvar',
'Foča',
'Fojnica',
'Gacko',
'Glamoč',
'Goražde',
'Gornji Vakuf - Uskoplje',
'Gračanica',
'Mostar',
'Gradačac',
'Gradiška',
'Grude',
'Han Pijesak',
'Istočna Ilidža',
'Istočni Drvar',
'Istočni Stari Grad',
'Istočno Novo Sarajevo',
'Jablanica',
'Jajce',
'Jezero',
'Kakanj',
'Kalesija',
'Kalinovik',
'Kiseljak',
'Kladanj',
'Ključ',
'Kneževo',
'Konjic',
'Kostajnica',
'Kotor Varoš',
'Kozarska Dubica',
'Kreševo',
'Krupa na Uni',
'Kupres',
'Kupres-Blagaj',
'Laktaši',
'Livno',
'Lopare',
'Lukavac',
'Ljubinje',
'Ljubuški',
'Maglaj',
'Milići',
'Modriča',
'Mrkonjić Grad',
'Neum',
'Nevesinje',
'Novi Grad',
'Novi Travnik',
'Odžak',
'Olovo',
'Orašje',
'Osmaci',
'Oštra Luka',
'Pale',
'Pelagićevo',
'Petrovac-Drinić',
'Petrovo',
'Posušje',
'Prijedor',
'Prnjavor',
'Prozor',
'Ravno',
'Ribnik',
'Rogatica',
'Rudo',
'Sarajevo',
'Sanski Most',
'Sapna',
'Skelani',
'Sokolac',
'Srbac',
'Srebrenica',
'Srebrenik',
'Stolac',
'Šamac',
'Šipovo',
'Široki Brijeg',
'Teočak',
'Teslić',
'Tešanj',
'Tomislavgrad',
'Travnik',
'Trebinje',
'Tuzla',
'Ugljevik',
'Usora',
'Ustiprača',
'Vareš',
'Velika Kladuša',
'Visoko',
'Višegrad',
'Vitez',
'Vlasenica',
'Vukosavlje',
'Zavidovići',
'Zenica',
'Zvornik',
'Žepče',
'Živinice'
  ];

  // Future<void> loadCategories() async {
  //   List<Profesion> profesionToAdd = new List<Profesion>();
  //   String data = await DefaultAssetBundle.of(context)
  //       .loadString("assets/categories.json");
  //   final categoriesJson = json.decode(data);
  //   for (var i = 0; i < categoriesJson.length; i++) {
  //     profesionToAdd
  //         .add(Profesion(categoriesJson[i]['name'], categoriesJson[i]['id']));
  //   }
  //   listProfesions = profesionToAdd;
  // }

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
                    child: Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        _selectedLocation = selection;
        FocusManager.instance.primaryFocus?.unfocus();
        // debugPrint('You just selected $selection');
      },
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
                    child: ProfesionSelect(getSelectedProfesion),
                  ),
                  Container(
                    height: 42,
                    width: 257,
                    margin: EdgeInsets.only(top: 24),
                    child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(20)),
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
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
            child: const Text('Pretraga'),
          ),
                    // child: TextButton(
                    //   style: ButtonStyle(
                    //     backgroundColor: Colors.red,
                    //   ),
                    //   onPressed: () => selectedProfesion == null
                    //       ? null
                    //       : Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => DisplayJobsScreen(
                    //                     industry: 'industry=' +
                    //                         selectedProfesion.id.toString(),
                    //                     title: selectedProfesion.name,
                    //                     location: _selectedLocation,
                    //                   ))),
                    //   child: Text('Pretraga',
                    //       style: TextStyle(color: Colors.white, fontSize: 18)),
                    // ),
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
}
