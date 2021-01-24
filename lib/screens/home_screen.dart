import 'package:flutter/material.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/widgets/job_tile.dart';
import 'package:provider/provider.dart';

import 'job_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  height: 230,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage('https://i.imgur.com/GMnqUlv.png'),
                    fit: BoxFit.cover,
                  )),
              Container(
                height: 230,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      'job finder',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Text(
                      'Find the job that fits your life',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                            decoration: InputDecoration(
                                suffixIcon: Container(
                                    color: Colors.green,
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    )),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Search Companies')))
                  ],
                ),
              ),
            ],
          ),
          Container(width: double.infinity, padding: EdgeInsets.only(left: 15, top:10, bottom: 10), child: Text('Latest jobs on market', style: TextStyle(fontSize: 20),)),
          FutureBuilder(
            future: Provider.of<Jobs>(context, listen: false).fetchAndSetJobs(),
            builder: (ctx, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 340,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
              else {
                return Consumer<Jobs>(
                  //Navigator.of(context).pushNamed(JobDetailScreen.routeName, arguments: jobsData.jobs[index].id)
                  builder: (ctx, jobsData, child) => SizedBox(height: 340, child: ListView.builder(itemCount:jobsData.jobs.length, itemBuilder: (ctx, index) {return InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetailScreen(jobsData.jobs[index].id))), child: JobTile(jobsData.jobs[index]));}))
                );
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(15),
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 80,
                  width: 90,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Image.network('https://www.joeogden.com/wp-content/uploads/2016/02/joe-ogden-logo-design-portfolio-43.png'),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 80,
                  width: 90,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Image.network('https://www.joeogden.com/wp-content/uploads/2016/02/joe-ogden-logo-design-portfolio-43.png'),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 80,
                  width: 90,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Image.network('https://www.joeogden.com/wp-content/uploads/2016/02/joe-ogden-logo-design-portfolio-43.png'),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 80,
                  width: 90,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Image.network('https://www.joeogden.com/wp-content/uploads/2016/02/joe-ogden-logo-design-portfolio-43.png'),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 80,
                  width: 90,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Image.network('https://www.joeogden.com/wp-content/uploads/2016/02/joe-ogden-logo-design-portfolio-43.png'),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 80,
                  width: 90,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Image.network('https://www.joeogden.com/wp-content/uploads/2016/02/joe-ogden-logo-design-portfolio-43.png'),
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
}
