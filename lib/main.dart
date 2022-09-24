import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/screens/display_it_jobs.screen.dart';
import 'package:posao_app/screens/display_jobs.screen.dart';
import 'package:posao_app/screens/home2_screen.dart';
import 'package:posao_app/screens/home_screen.dart';
import 'package:posao_app/screens/job_detail_screen.dart';
import 'package:posao_app/screens/jobs_categories_screen.dart';
import 'package:posao_app/screens/saved_jobs_screen.dart';
import 'package:provider/provider.dart';

import 'providers/test.dart';
import 'screens/jobs_categories2_screen.dart';
import 'screens/test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Jobs()),
        ChangeNotifierProvider(create: (context) => Test()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ja BiH posao',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              flexibleSpace: SafeArea(
                child: TabBar(
                  tabs: [
                    Column(
                      children: [
                        Tab(icon: Icon(Icons.search)),
                        Text(
                          'Pretraga',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Tab(icon: Icon(Icons.business_center)),
                        Text(
                          'Kategorije',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Tab(icon: Icon(Icons.favorite_border)),
                        Text(
                          'Sačuvani',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Tab(icon: Icon(Icons.code, color: Colors.yellow,)),
                        Text(
                          'IT poslovi',
                          style: TextStyle(fontSize: 12, color: Colors.yellow),
                        )
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     Tab(icon: Icon(Icons.category)),
                    //     Text(
                    //       'Categories',
                    //       style: TextStyle(fontSize: 12),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Home2Screen(),
                JobsCategories2Screen(),
                SavedJobsScreen(),
                DisplayItJobsScreen(showHeader: false,)
              ],
            ),
          ),
        ),
        routes: {
          //JobDetailScreen.routeName: (ctx) => JobDetailScreen(),
          DisplayJobsScreen.routeName: (ctx) => DisplayJobsScreen()
        },
      ),
    );
  }
}
