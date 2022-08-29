import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:posao_app/models/job.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class JobDetailScreen extends StatelessWidget {
  static const routeName = '/job-detail';

  final int id;
  JobDetailScreen(this.id);

  var title = '';

  static const kHtml = '''
<p>...</p>
<div class="carousel">
  <div class="image">
    <img src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba" />
  </div>
  ...
</div>
<p>...</p>
''';

  void _launchURL(String _url) async =>
    await launch(_url);


  @override
  Widget build(BuildContext context) {
    //final id = ModalRoute.of(context).settings.arguments as int;
    var jobsData = Provider.of<Jobs>(context, listen: false).selectedJobDetails;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Consumer<Jobs>(
            builder: (context, data, _) {
              return Text(data.title);
            },
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 1)),
                  child: FutureBuilder(
                      future: Provider.of<Jobs>(context, listen: false)
                          .selectedJob(id),
                      builder: (ctx, AsyncSnapshot<Job> future) {
                        if (future.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          return FlatButton.icon(
                              onPressed: () =>
                                  Provider.of<Jobs>(context, listen: false)
                                      .saveJob(future.data),
                              icon: future.data.saved
                                  ? Icon(Icons.favorite, color: Colors.blue)
                                  : Icon(
                                      Icons.favorite_border,
                                      color: Colors.blue,
                                    ),
                              label: Text(
                                'SPASI',
                                style: TextStyle(color: Colors.blue),
                              ));
                        }
                      })),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue, width: 1)),
                  child: FlatButton(
                      onPressed: () => _launchURL(
                          'https://www.mojposao.ba/#apply;jobId=$id'),
                      child: Text('Prijavi se',
                          style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: Provider.of<Jobs>(context, listen: false).getJobById(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                );
              } else {
                //return Text(snapshot.data['description']);
                return Column(children: [
                  Stack(
                    children: [
                      Container(
                        height: 60,
                        width: double.infinity,
                        color: Colors.green,
                      ),
                      Center(
                        child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.green,
                            child: Hero(
                              tag: 'job-img-$id',
                              child: Image.network(
                                Provider.of<Jobs>(context, listen: false)
                                    .selectedJobDetails
                                    .company
                                    .photo,
                                fit: BoxFit.fill,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Consumer<Jobs>(
                        builder: (context, jobsData, _) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              // Text(
                              //   jobsData.selectedJobDetails.title,
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 15),
                              // ),
                              VisibilityDetector(
                                key: Key('jobdesc'),
                                onVisibilityChanged: (visibilityInfo) {
                                  var visiblePercentage =
                                      visibilityInfo.visibleFraction * 100;
                                  print(
                                      'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
                                  if (visiblePercentage < 10) {
                                    Provider.of<Jobs>(context, listen: false)
                                        .changeTitle(
                                            jobsData.selectedJobDetails.title);
                                  } else {
                                    Provider.of<Jobs>(context, listen: false)
                                        .changeTitle('');
                                  }
                                },
                                child: Text(
                                  jobsData.selectedJobDetails.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                jobsData.selectedJobDetails.company.name,
                                style: TextStyle(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                jobsData.selectedJobDetails.company.city,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Divider(color: Colors.grey)
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: HtmlWidget(
                          // the first parameter (`html`) is required
                          '''
${snapshot.data['description']}
  <!-- anything goes here -->
  ''',

                          // all other parameters are optional, a few notable params:

                          // specify custom styling for an element
                          // see supported inline styling below
                          customStylesBuilder: (element) {
                            if (element.classes.contains('foo')) {
                              return {'color': 'red'};
                            }

                            return null;
                          },

                          // render a custom widget

                          // this callback will be triggered when user taps a link
                          onTapUrl: (url) => print('tapped $url'),

                          // set the default styling for text
                          textStyle: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  )
                ]);
              }
            },
          ),
        ));
  }
}
